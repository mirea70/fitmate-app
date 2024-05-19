import 'package:dio/dio.dart';

import '../../model/login/LoginResponse.dart';

class AuthRepository {
  final Dio dio;

  AuthRepository({required this.dio});

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

    return LoginResponse.fromJson(response.data);
  }
}
