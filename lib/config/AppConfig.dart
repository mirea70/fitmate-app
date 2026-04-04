import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

enum Environment { dev, prod }

class AppConfig {
  static final AppConfig _instance = AppConfig._privateConstructor();
  static Environment _environment = Environment.dev;

  factory AppConfig() => _instance;
  AppConfig._privateConstructor();

  // ──────────── 환경 변수 (--dart-define-from-file) ────────────

  static const _env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static const kakaoNativeAppKey = String.fromEnvironment('KAKAO_NATIVE_APP_KEY');
  static const naverClientId = String.fromEnvironment('NAVER_CLIENT_ID');
  static const naverClientSecret = String.fromEnvironment('NAVER_CLIENT_SECRET');

  // ──────────── 초기화 ────────────

  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 환경 설정
    _environment = _env == 'prod' ? Environment.prod : Environment.dev;
    debugPrint('=== 실행 환경: $_env | baseUrl: ${AppConfig().baseUrl} ===');

    // Firebase
    await Firebase.initializeApp();

    // Kakao SDK
    KakaoSdk.init(nativeAppKey: kakaoNativeAppKey);

    // 날짜 포맷
    await initializeDateFormatting();
  }

  // ──────────── Getter ────────────

  Environment get environment => _environment;
  bool get isProd => _environment == Environment.prod;

  String get baseUrl => _getBaseUrl();

  String _getBaseUrl() {
    if (_environment == Environment.prod) {
      return 'https://www.fitmate.site';
    }
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8090';
    }
    return 'http://192.168.45.98:8090';
  }
}
