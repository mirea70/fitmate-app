import 'dart:typed_data';

import 'package:fitmate_app/repository/file/FileRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final imageCacheServiceProvider = Provider<ImageCacheService>((ref) {
  return ImageCacheService(ref);
});

class ImageCacheService {
  final Ref ref;
  final Map<int, Uint8List> _cache = {};

  ImageCacheService(this.ref);

  Uint8List? get(int fileId) => _cache[fileId];

  void put(int fileId, Uint8List data) => _cache[fileId] = data;

  void remove(int fileId) => _cache.remove(fileId);

  bool has(int fileId) => _cache.containsKey(fileId);

  Future<Uint8List?> load(int fileId) async {
    if (_cache.containsKey(fileId)) return _cache[fileId];
    try {
      final data = await ref.read(fileRepositoryProvider).downloadFile(fileId);
      _cache[fileId] = data;
      return data;
    } catch (_) {
      return null;
    }
  }

  Future<void> preloadAll(List<int?> fileIds) async {
    final ids = fileIds.whereType<int>().where((id) => !_cache.containsKey(id)).toSet();
    await Future.wait(ids.map((id) => load(id)));
  }
}
