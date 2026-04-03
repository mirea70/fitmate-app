import 'dart:io';
import 'dart:typed_data';
import 'dart:collection';

import 'package:fitmate_app/repository/file/FileRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final imageCacheServiceProvider = Provider<ImageCacheService>((ref) {
  return ImageCacheService(ref);
});

/// 메모리 LRU + 디스크 영구 캐시
///
/// 흐름:
/// 1. get() → 메모리 히트 → 즉시 반환
/// 2. get() → 메모리 미스 → 디스크 확인 → 있으면 메모리 적재 후 반환
/// 3. load() → 디스크에도 없음 → 네트워크 다운로드 → 메모리+디스크 저장
class ImageCacheService {
  final Ref ref;
  static const int _maxMemoryCacheSize = 150;
  final LinkedHashMap<int, Uint8List> _memoryCache = LinkedHashMap();
  String? _diskCacheDir;
  final Set<int> _loadingIds = {};

  ImageCacheService(this.ref);

  /// 디스크 캐시 디렉토리 (lazy init)
  Future<String> _getDiskCacheDir() async {
    if (_diskCacheDir != null) return _diskCacheDir!;
    final dir = await getTemporaryDirectory();
    final cacheDir = Directory('${dir.path}/image_cache');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    _diskCacheDir = cacheDir.path;
    return _diskCacheDir!;
  }

  File _diskFile(String dir, int fileId) => File('$dir/$fileId');

  // ──────────── 메모리 캐시 ────────────

  void _memoryPut(int fileId, Uint8List data) {
    _memoryCache.remove(fileId);
    if (_memoryCache.length >= _maxMemoryCacheSize) {
      _memoryCache.remove(_memoryCache.keys.first);
    }
    _memoryCache[fileId] = data;
  }

  Uint8List? _memoryGet(int fileId) {
    final data = _memoryCache.remove(fileId);
    if (data != null) {
      _memoryCache[fileId] = data;
    }
    return data;
  }

  // ──────────── Public API ────────────

  /// 동기적 조회 (메모리만). 빌드 메서드에서 사용.
  Uint8List? get(int fileId) => _memoryGet(fileId);

  /// 메모리에 있는지 확인
  bool has(int fileId) => _memoryCache.containsKey(fileId);

  /// 메모리 + 디스크에 즉시 저장 (업로드 직후 사용)
  Future<void> put(int fileId, Uint8List data) async {
    _memoryPut(fileId, data);
    try {
      final dir = await _getDiskCacheDir();
      await _diskFile(dir, fileId).writeAsBytes(data);
    } catch (_) {}
  }

  /// 캐시 무효화 (이미지 변경 시)
  Future<void> invalidate(int fileId) async {
    _memoryCache.remove(fileId);
    try {
      final dir = await _getDiskCacheDir();
      final file = _diskFile(dir, fileId);
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }

  /// 이미지 로드: 메모리 → 디스크 → 네트워크 순서
  Future<Uint8List?> load(int fileId) async {
    // 1. 메모리 캐시
    final memCached = _memoryGet(fileId);
    if (memCached != null) return memCached;

    // 2. 디스크 캐시
    try {
      final dir = await _getDiskCacheDir();
      final file = _diskFile(dir, fileId);
      if (await file.exists()) {
        final data = await file.readAsBytes();
        _memoryPut(fileId, data);
        return data;
      }
    } catch (_) {}

    // 3. 네트워크 (중복 요청 방지)
    if (_loadingIds.contains(fileId)) return null;
    _loadingIds.add(fileId);
    try {
      final data = await ref.read(fileRepositoryProvider).downloadFile(fileId);
      _memoryPut(fileId, data);
      // 디스크에 비동기 저장
      _getDiskCacheDir().then((dir) {
        _diskFile(dir, fileId).writeAsBytes(data);
      }).catchError((_) {});
      return data;
    } catch (_) {
      return null;
    } finally {
      _loadingIds.remove(fileId);
    }
  }

  /// 선행 캐시 적재 (await). 화면에 즉시 보여야 할 이미지 용.
  /// 디스크 캐시가 있으면 네트워크 없이 즉시 완료.
  Future<void> ensureLoaded(List<int?> fileIds) async {
    final ids = fileIds.whereType<int>().where((id) => !_memoryCache.containsKey(id)).toSet();
    if (ids.isEmpty) return;
    await Future.wait(ids.map((id) => load(id)));
  }

  /// 백그라운드 프리로드 (fire-and-forget)
  void preloadInBackground(List<int?> fileIds) {
    final ids = fileIds.whereType<int>().where((id) => !_memoryCache.containsKey(id)).toSet();
    if (ids.isEmpty) return;
    Future.wait(ids.map((id) => load(id)));
  }
}
