import 'dart:io';

class AppConfig {
  static final AppConfig _instance = AppConfig._privateConstructor();

  factory AppConfig() {
    return _instance;
  }

  AppConfig._privateConstructor();

  final String baseUrl = getBaseUrl();
  // final String baseUrl = 'http://10.0.2.2:8090';

  static String getBaseUrl() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8090';
    }
    return 'http://192.168.45.98:8090';
  }
}