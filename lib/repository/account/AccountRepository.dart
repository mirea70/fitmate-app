import 'dart:convert';
import 'package:fitmate_app/model/account/Account.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../config/AppConfig.dart';

final accountRepositoryProvider = Provider<AccountRepository>((_) => AccountRepositoryImpl());

abstract class AccountRepository {
  Future<bool> validateDuplicatedLoginName (String loginName);
  Future<bool> validateDuplicatedPhone (String phone);
  Future<bool> requestSmsCode(String phone);
  Future<bool> checkValidateCode(String code);
  Future<dynamic> requestJoin(Account account);
}

class AccountRepositoryImpl extends AccountRepository {

  @override
  Future<bool> validateDuplicatedLoginName(String loginName) async {
    String baseUri = AppConfig().host;
    String endPoint = "/api/account/check/loginName";
    Map<String, String> queryString = {"loginName": loginName};
    var uri = Uri.http(baseUri, endPoint, queryString);
    var response = await http.get(uri);

    if(response.statusCode == 200) return true;
    else {
      Map<String, dynamic> data = jsonDecode(response.body);
      if(response.statusCode != 200 && data['code'] == 'DUPLICATED_ACCOUNT_JOIN')
        return false;
      else throw 'UnKnown Exception';
    }
  }

  @override
  Future<bool> validateDuplicatedPhone(String phone) async {
    String baseUri = AppConfig().host;
    String endPoint = "/api/account/check/phone";
    Map<String, String> queryString = {"phone": phone};
    var uri = Uri.http(baseUri, endPoint, queryString);
    var response = await http.get(uri);

    if(response.statusCode == 200) return true;
    else {
      Map<String, dynamic> data = jsonDecode(response.body);
      if(response.statusCode != 200 && data['code'] == 'DUPLICATED_ACCOUNT_JOIN')
        return false;
      else throw 'UnKnown Exception';
    }
  }

  @override
  Future<bool> requestSmsCode(String phone) async {
    String baseUri = AppConfig().host;
    String endPoint = "/api/sms/request/code";

    Map<String, String> headers = {
      'Content-Type': 'application/json'
    };
    Map<String, String> body = {
      "phone": phone
    };

    var uri = Uri.http(baseUri, endPoint);
    var response = await http.post(uri, headers: headers, body: jsonEncode(body));

    if(response.statusCode == 200) return true;
    else return false;
  }

  @override
  Future<bool> checkValidateCode(String code) async {
    String baseUri = AppConfig().host;
    String endPoint = "/api/sms/check/code";
    Map<String, String> queryString = {"inputCode": code};
    var uri = Uri.http(baseUri, endPoint, queryString);
    var response = await http.get(uri);

    if(response.statusCode == 200) return true;
    else return false;
  }

  @override
  Future<dynamic> requestJoin(Account account) async {
    String baseUri = AppConfig().host;
    String endPoint = "/api/account/join";
    Map<String, String> headers = {
      'Content-Type': 'application/json'
    };
    Map<String, dynamic> body = account.toJson();
    body.remove('profileImageId');
    print(body.toString());

    var uri = Uri.http(baseUri, endPoint);
    var response = await http.post(uri, headers: headers, body: jsonEncode(body));

    if(response.statusCode == 200) return null;
    else {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
  }
}