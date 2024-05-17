class AppConfig {
  static final AppConfig _instance = AppConfig._privateConstructor();

  factory AppConfig() {
    return _instance;
  }

  AppConfig._privateConstructor();

  final String host = 'http://localhost:8090';
}