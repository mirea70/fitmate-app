import 'dart:convert';
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