class AppConfig {
  static final AppConfig _instance = AppConfig._privateConstructor();

  factory AppConfig() {
    return _instance;
  }

  AppConfig._privateConstructor();

  // final String baseUrl = 'http://localhost:8090';
  final String baseUrl = 'http://10.0.2.2:8090';
}