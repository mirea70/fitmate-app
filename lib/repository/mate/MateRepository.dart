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

  Future<void> requestRegister(Mate mate, List<String> introImagePaths) async {
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

    await dio.post(
      endPoint,
      options: Options(
        contentType: Headers.multipartFormDataContentType,
        headers: headers,
      ),
      data: body,
    );
  }

  Future<void> requestModify(int mateId, Mate mate) async {
    String endPoint = "/api/mate/$mateId";
    final jsonBody = mate.toJson();
    jsonBody.remove('writerAccountId');
    jsonBody.remove('writerNickName');
    jsonBody.remove('writerImageId');
    jsonBody.remove('waitingAccountIds');
    jsonBody.remove('approvedAccountIds');
    jsonBody.remove('totalFee');

    final headers = {
      'accessToken': true,
    };

    await dio.patch(
      endPoint,
      options: Options(
        contentType: Headers.jsonContentType,
        headers: headers,
      ),
      data: jsonBody,
    );
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

  Future<List<MateListItem>> findAll(int page, {bool includeClosed = false}) async {
    String endPoint = "/api/mate/list";

    Map<String, dynamic> body = MateListRequestModel.initial().toJson();
    body['page'] = page;
    body['size'] = 15;
    body['includeClosed'] = includeClosed;
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

  Future<List<MateListItem>> getMyMates() async {
    final response = await dio.get(
      '/api/account/profile/my/mate/list',
      options: Options(headers: {'accessToken': true}),
    );
    return List<Map<String, dynamic>>.from(response.data)
        .map((item) => MateListItem.fromJson(item))
        .toList();
  }

  Future<Map<String, dynamic>> getMateQuestion(int mateId) async {
    final response = await dio.get(
      '/api/mate/request/$mateId/question',
      options: Options(headers: {'accessToken': true}),
    );
    return Map<String, dynamic>.from(response.data);
  }

  Future<void> approveMate(int mateId, int applierId) async {
    await dio.put(
      '/api/mate/request/$mateId/approve',
      options: Options(
        headers: {'accessToken': true},
        contentType: Headers.jsonContentType,
      ),
      data: {'applierId': applierId},
    );
  }

  Future<bool> toggleWish(int mateId) async {
    final response = await dio.put(
      '/api/mate/wish/$mateId',
      options: Options(headers: {'accessToken': true}),
    );
    return response.data['wished'] as bool;
  }

  Future<List<MateListItem>> getMyWishList() async {
    final response = await dio.get(
      '/api/mate/wish/my',
      options: Options(headers: {'accessToken': true}),
    );
    return List<Map<String, dynamic>>.from(response.data)
        .map((item) => MateListItem.fromJson(item))
        .toList();
  }

  Future<void> cancelMateApply(int mateId, String cancelReason) async {
    await dio.delete(
      '/api/mate/request/$mateId/cancel',
      options: Options(
        headers: {'accessToken': true},
        contentType: Headers.jsonContentType,
      ),
      data: {'cancelReason': cancelReason},
    );
  }

  Future<void> closeMate(int mateId) async {
    await dio.patch(
      '/api/mate/$mateId/close',
      options: Options(headers: {'accessToken': true}),
    );
  }

  Future<void> applyMate(int mateId, String comeAnswer) async {
    await dio.put(
      '/api/mate/request/$mateId/apply',
      options: Options(
        headers: {'accessToken': true},
        contentType: Headers.jsonContentType,
      ),
      data: {'comeAnswer': comeAnswer},
    );
  }
}