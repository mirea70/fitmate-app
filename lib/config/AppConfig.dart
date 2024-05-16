class AppConfig {
  static final AppConfig _instance = AppConfig._privateConstructor();

  factory AppConfig() {
    return _instance;
  }

  AppConfig._privateConstructor();

  final String host = '192.168.45.130:8090';
}