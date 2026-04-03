import 'package:fitmate_app/config/AppConfig.dart';
import 'package:fitmate_app/config/Dio.dart';
import 'package:fitmate_app/view/homeView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const env = String.fromEnvironment('ENV', defaultValue: 'dev');
  AppConfig.init(env == 'prod' ? Environment.prod : Environment.dev);
  debugPrint('=== 실행 환경: $env | baseUrl: ${AppConfig().baseUrl} ===');

  const kakaoAppKey = String.fromEnvironment('KAKAO_NATIVE_APP_KEY');
  KakaoSdk.init(nativeAppKey: kakaoAppKey);
  await initializeDateFormatting();
  runApp(
    ProviderScope(
      child: const FitMateApp(),
    ),
  );
}

class FitMateApp extends ConsumerWidget {
  const FitMateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigatorKey = ref.watch(navigatorKeyProvider);

    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: Colors.white
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      home: HomeView(),
    );
  }
}
