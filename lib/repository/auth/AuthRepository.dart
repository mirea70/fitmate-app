import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/Dio.dart';
import '../../model/login/LoginResponse.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

class AuthRepository {
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
}
