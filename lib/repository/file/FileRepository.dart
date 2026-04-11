import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fitmate_app/config/Dio.dart';
import 'package:fitmate_app/config/ImageCacheService.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fileRepositoryProvider = Provider<FileRepository>(
    (ref) {
      final dio = ref.watch(dioProvider);
      return FileRepository(dio, ref);
    });

class FileRepository {
  final Dio dio;
  final Ref ref;

  FileRepository(this.dio, this.ref);

  Future<List<Map<String, dynamic>>> uploadFiles(List<String> filePaths) async {
    String endpoint = "/api/file";
    final formData = FormData.fromMap({
      'multipartFiles': filePaths.map((path) => MultipartFile.fromFileSync(path)).toList(),
    });
    final response = await dio.post(
      endpoint,
      options: Options(
        headers: {'accessToken': true},
        contentType: Headers.multipartFormDataContentType,
      ),
      data: formData,
    );
    final results = List<Map<String, dynamic>>.from(response.data);

    // 업로드된 파일을 즉시 캐시에 적재
    final cache = ref.read(imageCacheServiceProvider);
    for (int i = 0; i < results.length && i < filePaths.length; i++) {
      final fileId = results[i]['id'] as int?;
      if (fileId != null) {
        try {
          final bytes = await File(filePaths[i]).readAsBytes();
          await cache.put(fileId, bytes);
        } catch (_) {}
      }
    }

    return results;
  }

  Future<Uint8List> downloadFile(int fileId) async {
    String endpoint = "/api/file/$fileId";
    final response = await dio.get(
      endpoint,
      options: Options(
        headers: {
          'accessToken': true
        },
        responseType: ResponseType.bytes,
      ),
    );
    return response.data;
  }

  Future<Uint8List> downloadThumbnail(int fileId) async {
    String endpoint = "/api/file/$fileId/thumbnail";
    final response = await dio.get(
      endpoint,
      options: Options(
        headers: {
          'accessToken': true
        },
        responseType: ResponseType.bytes,
      ),
    );
    return response.data;
  }
}