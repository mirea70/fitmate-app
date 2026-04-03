import 'dart:io';

enum Environment { dev, prod }

class AppConfig {
  static final AppConfig _instance = AppConfig._privateConstructor();
  static Environment _environment = Environment.dev;

  factory AppConfig() {
    return _instance;
  }

  AppConfig._privateConstructor();

  static void init(Environment env) {
    _environment = env;
  }

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
