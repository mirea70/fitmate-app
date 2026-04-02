import 'package:fitmate_app/config/Dio.dart';
import 'package:fitmate_app/model/account/Account.dart';
import 'package:fitmate_app/model/account/AccountProfile.dart';
import 'package:fitmate_app/model/account/FollowDetail.dart';
import 'package:fitmate_app/model/account/MateRequestResponse.dart';
import 'package:fitmate_app/model/account/NoticeResponse.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

final accountRepositoryProvider = Provider<AccountRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AccountRepository(dio);
});

class AccountRepository {
  final Dio dio;

  AccountRepository(this.dio);

  Future<bool> validateDuplicatedLoginName(String loginName) async {
    String endPoint = "/api/account/check/loginName";
    Map<String, String> queryString = {"loginName": loginName};

    try {
      await dio.get(endPoint, queryParameters: queryString);
      return true;
    } on DioException catch (e) {
      if (e.response!.data['code'] == 'DUPLICATED_ACCOUNT_JOIN')
        return false;
      else
        throw 'UnKnown Exception';
    }
  }

  Future<bool> validateDuplicatedPhone(String phone) async {
    String endPoint = "/api/account/check/phone";
    Map<String, String> queryString = {"phone": phone};

    try {
      await dio.get(endPoint, queryParameters: queryString);
      return true;
    } on DioException catch (e) {
      if (e.response!.data['code'] == 'DUPLICATED_ACCOUNT_JOIN')
        return false;
      else
        throw 'UnKnown Exception';
    }
  }

  Future<bool> requestSmsCode(String phone) async {
    String endPoint = "/api/sms/request/code";

    Map<String, String> body = {"phone": phone};

    try {
      await dio.post(endPoint,
          options: Options(
            contentType: Headers.jsonContentType,
          ),
          data: body);
      return true;
    } on DioException {
      return false;
    }
  }

  Future<bool> checkValidateCode(String phone, String code) async {
    String endPoint = "/api/sms/check/code";
    Map<String, String> queryString = {"phone": phone, "inputCode": code};

    try {
      await dio.get(endPoint, queryParameters: queryString);
      return true;
    } on DioException {
      return false;
    }
  }

  Future<AccountProfile> getMyProfile() async {
    String endPoint = "/api/account";
    final response = await dio.get(
      endPoint,
      options: Options(
        headers: {'accessToken': true},
      ),
    );
    return AccountProfile.fromJson(response.data);
  }

  Future<AccountProfile> getProfileByAccountId(int accountId) async {
    String endPoint = "/api/account/$accountId";
    final response = await dio.get(
      endPoint,
      options: Options(
        headers: {'accessToken': true},
      ),
    );
    return AccountProfile.fromJson(response.data);
  }

  Future<void> updateProfile({
    required String nickName,
    required String introduction,
    required String name,
    required String phone,
    required String email,
    int? profileImageId,
  }) async {
    String endPoint = "/api/account/profile";
    Map<String, dynamic> body = {
      'nickName': nickName,
      'introduction': introduction,
      'name': name,
      'phone': phone,
      'email': email,
      'profileImageId': profileImageId,
    };
    await dio.patch(
      endPoint,
      options: Options(
        headers: {'accessToken': true},
        contentType: Headers.jsonContentType,
      ),
      data: body,
    );
  }

  Future<List<NoticeResponse>> getMyNotices() async {
    String endPoint = "/api/account/profile/my/notices";
    final response = await dio.get(
      endPoint,
      options: Options(headers: {'accessToken': true}),
    );
    return List<Map<String, dynamic>>.from(response.data)
        .map((item) => NoticeResponse.fromJson(item))
        .toList();
  }

  Future<int> getUnreadNoticeCount() async {
    final response = await dio.get(
      '/api/account/profile/my/notices/unread/count',
      options: Options(headers: {'accessToken': true}),
    );
    return response.data['count'] as int;
  }

  Future<void> markNoticesAsRead() async {
    await dio.put(
      '/api/account/profile/my/notices/read',
      options: Options(headers: {'accessToken': true}),
    );
  }

  Future<List<MateRequestResponse>> getMyMateRequests(String approveStatus) async {
    String endPoint = "/api/account/profile/my/mate/request";
    final response = await dio.get(
      endPoint,
      queryParameters: {'approveStatus': approveStatus},
      options: Options(headers: {'accessToken': true}),
    );
    return List<Map<String, dynamic>>.from(response.data)
        .map((item) => MateRequestResponse.fromJson(item))
        .toList();
  }

  Future<void> deleteAccount(int accountId) async {
    String endPoint = "/api/account/$accountId";
    await dio.delete(
      endPoint,
      options: Options(
        headers: {'accessToken': true},
      ),
    );
  }

  Future<List<FollowDetail>> getMyFollowers() async {
    final response = await dio.get(
      '/api/account/profile/my/followers',
      options: Options(headers: {'accessToken': true}),
    );
    return List<Map<String, dynamic>>.from(response.data)
        .map((item) => FollowDetail.fromJson(item))
        .toList();
  }

  Future<List<FollowDetail>> getMyFollowings() async {
    final response = await dio.get(
      '/api/account/profile/my/followings',
      options: Options(headers: {'accessToken': true}),
    );
    return List<Map<String, dynamic>>.from(response.data)
        .map((item) => FollowDetail.fromJson(item))
        .toList();
  }

  Future<void> followUser(int targetAccountId) async {
    await dio.put(
      '/api/account/profile/follow',
      queryParameters: {'targetAccountId': targetAccountId},
      options: Options(headers: {'accessToken': true}),
    );
  }

  Future<dynamic> requestJoin(Account account) async {
    String endPoint = "/api/account/join";
    Map<String, dynamic> body = account.toJson();
    body.remove('profileImageId');

    try {
      await dio.post(
        endPoint,
        options: Options(
          contentType: Headers.jsonContentType,
        ),
        data: body,
      );
      return null;
    } on DioException catch (e) {
      return e.response!.data;
    }
  }
}
