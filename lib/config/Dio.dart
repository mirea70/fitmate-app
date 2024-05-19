import 'package:dio/dio.dart';
import 'package:fitmate_app/config/AppConfig.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.baseUrl = AppConfig().baseUrl;
  dio.interceptors.add(
      CustomInterceptor()
  );
  return dio;
});

class CustomInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    return handler.reject(err);
  }
}