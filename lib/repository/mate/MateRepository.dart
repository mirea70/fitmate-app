import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fitmate_app/config/Dio.dart';
import 'package:fitmate_app/model/mate/Mate.dart';
import 'package:fitmate_app/model/mate/MateListItem.dart';
import 'package:fitmate_app/model/mate/MateListRequestModel.dart';
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

  Future<List<MateListItem>> findAll(int page) async {
    String endPoint = "/api/mate/list";

    Map<String, dynamic> body = MateListRequestModel.initial().toJson();
    body['page'] = page;
    body['size'] = 15;
    final headers = {
      'accessToken': true
    };

    final response = await dio.post(
        endPoint,
      options: Options(
        headers: headers,
      ),
      data: body
    );
    print(response.data.toString());

    List<MateListItem> mates = List<Map<String, dynamic>>.from(response.data['content'])
    .map((item) {
      return MateListItem.fromJson(item);
    }).toList();

    return mates;
  }

  Future<List<MateListItem>> findAllWithCondition(MateListRequestModel requestModel, int page, String? keyword) async {
    String endPoint = "/api/mate/list";
    Map<String, dynamic> body = requestModel.toJson();
    body['page'] = page;
    body['size'] = 15;
    body['keyword'] = keyword;

    final headers = {
      'accessToken': true
    };

    final response = await dio.post(
      endPoint,
      options: Options(
        headers: headers,
      ),
      data: body,
    );

    List<MateListItem> mates = List<Map<String, dynamic>>.from(response.data['content'])
        .map((item) {
      return MateListItem.fromJson(item);
    }).toList();

    return mates;
  }

  Future<Mate> getMateOne(int mateId) async {
    String endPoint = "/api/mate/" + mateId.toString();

    final headers = {
      'accessToken': true
    };
    final response = await dio.get(
      endPoint,
      options: Options(
        headers: headers,
      ),
    );
    return Mate.fromJson(response.data);
  }
}