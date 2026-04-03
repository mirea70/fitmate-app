import 'package:dio/dio.dart';
import 'package:fitmate_app/repository/auth/IAuthRepository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/Dio.dart';
import '../../model/login/LoginResponse.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

class AuthRepository implements IAuthRepository {
  final Dio dio;

  AuthRepository(this.dio);

  Future<LoginResponse> login({
    required String loginName,
    required String password,
  }) async {
    String endPoint = '/login';
    Map<String, dynamic> body = {
      'username': loginName,
      'password': password,
    };

    final response = await dio.post(
      endPoint,
      options: Options(
        contentType: Headers.jsonContentType,
      ),
      data: body,
    );

    String? accessToken = response.headers.value('access');
    String? refreshToken = response.headers.value('refresh');

    return LoginResponse(accessToken: accessToken!, refreshToken: refreshToken!);
  }

  Future<Map<String, dynamic>> kakaoLogin({required String kakaoAccessToken}) async {
    final response = await dio.post(
      '/api/auth/kakao',
      options: Options(contentType: Headers.jsonContentType),
      data: {'accessToken': kakaoAccessToken},
    );

    bool isNewUser = response.data['newUser'] == true;

    if (isNewUser) {
      return {
        'isNewUser': true,
        'kakaoNickName': response.data['kakaoNickName'] ?? '',
        'kakaoEmail': response.data['kakaoEmail'] ?? '',
      };
    }

    return {
      'isNewUser': false,
      'loginResponse': LoginResponse(
        accessToken: 'Bearer ${response.data['accessToken']}',
        refreshToken: 'Bearer ${response.data['refreshToken']}',
      ),
    };
  }

  Future<LoginResponse> kakaoRegister({
    required String kakaoAccessToken,
    required String name,
    required String gender,
    required String birthDate,
    required String phone,
    required String nickName,
    String? email,
  }) async {
    final response = await dio.post(
      '/api/auth/kakao/register',
      options: Options(contentType: Headers.jsonContentType),
      data: {
        'accessToken': kakaoAccessToken,
        'name': name,
        'gender': gender,
        'birthDate': birthDate,
        'phone': phone,
        'nickName': nickName,
        'email': email,
      },
    );

    return LoginResponse(
      accessToken: 'Bearer ${response.data['accessToken']}',
      refreshToken: 'Bearer ${response.data['refreshToken']}',
    );
  }
}
