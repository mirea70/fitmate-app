import 'dart:typed_data';
import 'dart:collection';

import 'package:fitmate_app/repository/file/FileRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageCacheServiceProvider = Provider<ImageCacheService>((ref) {
  return ImageCacheService(ref);
});

class ImageCacheService {
  final Ref ref;
  static const int _maxCacheSize = 100;
  final LinkedHashMap<int, Uint8List> _cache = LinkedHashMap();

  ImageCacheService(this.ref);

  Uint8List? get(int fileId) {
    final data = _cache.remove(fileId);
    if (data != null) {
      _cache[fileId] = data;
    }
    return data;
  }

  void put(int fileId, Uint8List data) {
    _cache.remove(fileId);
    if (_cache.length >= _maxCacheSize) {
      _cache.remove(_cache.keys.first);
    }
    _cache[fileId] = data;
  }

  void remove(int fileId) => _cache.remove(fileId);

  bool has(int fileId) => _cache.containsKey(fileId);

  Future<Uint8List?> load(int fileId) async {
    final cached = get(fileId);
    if (cached != null) return cached;
    try {
      final data = await ref.read(fileRepositoryProvider).downloadFile(fileId);
      put(fileId, data);
      return data;
    } catch (_) {
      return null;
    }
  }

  /// Non-blocking: fires preload in background, does not await
  void preloadInBackground(List<int?> fileIds) {
    final ids = fileIds.whereType<int>().where((id) => !_cache.containsKey(id)).toSet();
    if (ids.isEmpty) return;
    Future.wait(ids.map((id) => load(id)));
  }

  /// Blocking: awaits all images (use only when absolutely needed)
  Future<void> preloadAll(List<int?> fileIds) async {
    final ids = fileIds.whereType<int>().where((id) => !_cache.containsKey(id)).toSet();
    await Future.wait(ids.map((id) => load(id)));
  }
}
