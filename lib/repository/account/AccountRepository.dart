import 'package:fitmate_app/config/Dio.dart';
import 'package:fitmate_app/model/account/Account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

import '../../config/AppConfig.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AccountRepository(dio);
});

class AccountRepository {
  final Dio dio;

  AccountRepository(this.dio);

  Future<bool> validateDuplicatedLoginName(String loginName) async {
    String endPoint = "/account/check/loginName";
    Map<String, String> queryString = {"loginName": loginName};

    try {
      await dio.get(endPoint, queryParameters: queryString);
      return true;
    } on DioException catch (e) {
      if(e.response!.data['code'] == 'DUPLICATED_ACCOUNT_JOIN')
        return false;
      else throw 'UnKnown Exception';
    }
  }

  Future<bool> validateDuplicatedPhone(String phone) async {
    String endPoint = "/account/check/phone";
    Map<String, String> queryString = {"phone": phone};

    try {
      await dio.get(endPoint, queryParameters: queryString);
      return true;
    } on DioException catch (e) {
      if(e.response!.data['code'] == 'DUPLICATED_ACCOUNT_JOIN')
        return false;
      else throw 'UnKnown Exception';
    }
  }

  Future<bool> requestSmsCode(String phone) async {
    String endPoint = "/sms/request/code";

    Map<String, String> body = {
      "phone": phone
    };

    try {
      await dio.post(endPoint,
          options: Options(
            contentType: Headers.jsonContentType,
          ),
          data: body);
      return true;
    } on DioException catch (e) {
      return false;
    }
  }

  Future<bool> checkValidateCode(String code) async {
    String endPoint = "/sms/check/code";
    Map<String, String> queryString = {"inputCode": code};

    try {
      await dio.get(endPoint, queryParameters: queryString);
      return true;
    } on DioException catch (e) {
      return false;
    }
  }

  Future<dynamic> requestJoin(Account account) async {
    String endPoint = "/account/join";
    Map<String, dynamic> body = account.toJson();
    body.remove('profileImageId');

    try {
      await dio.post(endPoint,
          options: Options(
            contentType: Headers.jsonContentType,
          ),
          data: body);
      return null;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }
}