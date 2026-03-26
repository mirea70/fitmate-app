import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:fitmate_app/config/Dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fileRepositoryProvider = Provider<FileRepository>(
    (ref) {
      final dio = ref.watch(dioProvider);
      return FileRepository(dio);
    });

class FileRepository {
  final Dio dio;

  FileRepository(this.dio);

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
    return List<Map<String, dynamic>>.from(response.data);
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
}