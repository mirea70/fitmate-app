import 'package:dio/dio.dart';
import 'package:fitmate_app/config/AppConfig.dart';
import 'package:fitmate_app/config/Const.dart';
import 'package:fitmate_app/config/SecureStorage.dart';
import 'package:fitmate_app/view_model/account/login/LoginViewModel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as Storage;

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  dio.options.baseUrl = AppConfig().baseUrl;
  final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
      CustomInterceptor(storage: storage, ref: ref),
  );
  return dio;
});

class CustomInterceptor extends Interceptor {
  final Ref ref;
  final Storage.FlutterSecureStorage storage;


  CustomInterceptor({required this.ref, required this.storage});

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    if(options.headers['accessToken'] == 'true') {
      options.headers.remove('accessToken');
      final token = await storage.read(key: accessTokenKey);

      options.headers.addAll({
        'Authorization': token,
      });
    }
    else if(options.headers['refreshToken'] == 'true') {
      options.headers.remove('refreshToken');
      final token = await storage.read(key: accessTokenKey);

      options.headers.addAll({
        'refresh': token,
      });
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/api/auth/refresh';
    final isLogin = err.requestOptions.path == '/login';

    if(isStatus401 && !isPathRefresh && !isLogin) {
      final dio = Dio();

      try {
        final refreshToken = await storage.read(key: refreshTokenKey);
        if(refreshToken == null) {
          return handler.reject(err);
        }

        final response = await dio.post(
          AppConfig().baseUrl + "/api/auth/refresh",
          options: Options(
            headers: {
              'refresh': refreshToken,
            },
          ),
        );

        String? newAccessToken = response.headers.value('access');
        String? newRefreshToken = response.headers.value('refresh');

        await storage.write(key: accessTokenKey, value: newAccessToken);
        await storage.write(key: refreshTokenKey, value: newRefreshToken);

        final options = err.requestOptions;
        options.headers.addAll({
          'Authorization': newAccessToken,
        });

        final newResponse = await dio.fetch(options);
        return handler.resolve(newResponse);
      }
      on DioException catch (e) {
        ref.read(loginViewModelProvider.notifier).logout();
        return handler.reject(e);
      }
    }

    return handler.reject(err);
  }
}