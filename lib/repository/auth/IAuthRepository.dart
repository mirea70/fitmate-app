import '../../model/login/LoginResponse.dart';

abstract class IAuthRepository {
  Future<LoginResponse> login({
    required String loginName,
    required String password,
  });
  Future<Map<String, dynamic>> kakaoLogin({required String kakaoAccessToken});
  Future<LoginResponse> kakaoRegister({
    required String kakaoAccessToken,
    required String name,
    required String gender,
    required String birthDate,
    required String phone,
    required String nickName,
    String? email,
  });
}
