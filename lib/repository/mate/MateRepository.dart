import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fitmate_app/config/Dio.dart';
import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/model/mate/MateListItem.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final mateRepositoryProvider = Provider<MateRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return MateRepository(dio);
});

class MateRepository {
  final Dio dio;

  MateRepository(this.dio);

  Future<dynamic> requestRegister(Mate mate, List<String> introImagePaths) async {
    String endPoint = "/api/mate";
    final jsonBody = mate.toJson();
    jsonBody.remove('introImageIds');
    jsonBody.remove('watingAccountIds');
    jsonBody.remove('approvedAccountIds');
    final body = FormData.fromMap(
      {
        'createRequest': jsonEncode(jsonBody),
        'introImages' : List.generate(introImagePaths.length, (index) => MultipartFile.fromFileSync(introImagePaths[index])),
      }
    );
    final headers = {
      'accessToken': true
    };

    try {
      await dio.post(
        endPoint,
        options: Options(
          contentType: Headers.multipartFormDataContentType,
          headers: headers,
        ),
        data: body,
      );
      return null;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }

  String generateCurlCommand(String url, Map<String, dynamic> headers, FormData formData) {
    final buffer = StringBuffer();
    buffer.write('curl -X POST ');
    headers.forEach((key, value) {
      buffer.write('-H "$key: $value" ');
    });

    formData.fields.forEach((field) {
      buffer.write('-F "${field.key}=${field.value}" ');
    });

    formData.files.forEach((file) {
      buffer.write('-F "${file.key}=@${file.value.filename}" ');
    });

    buffer.write(url);
    return buffer.toString();
  }

  Future<List<MateListItem>> findAll(int lastMateId) async {
    String endPoint = "/api/mate";
    Map<String, int> queryString = {
      "lastMateId": lastMateId,
      "limit": 15,
    };
    final headers = {
      'accessToken': true
    };

    final response = await dio.get(
        endPoint,
        queryParameters: queryString,
      options: Options(
        headers: headers,
      ),
    );

    List<MateListItem> mates = List<Map<String, dynamic>>.from(response.data)
    .map((item) {
      return MateListItem.fromJson(item);
    }).toList();

    return mates;
  }
}