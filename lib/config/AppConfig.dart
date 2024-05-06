class AppConfig {
  static final AppConfig _instance = AppConfig._privateConstructor();

  factory AppConfig() {
    return _instance;
  }

  AppConfig._privateConstructor();

  final String apiBaseUri = 'http://localhost:8090/api';
}