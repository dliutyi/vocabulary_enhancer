class AppConfig {
  // Private constructor to prevent instantiation.
  AppConfig._();

  // Static properties
  static const String appName = "My Awesome App";
  static const String apiBaseUrl = "https://myapi.com/v1";
  static const String defaultLanguage = "en";
  // static const String serverLocation = "ambitious-noreen-dliutyi-b3e46d66.koyeb.app";
  static const String serverLocation = "10.0.2.2:5000";

  static void logAppInfo() {
    print('App name: $appName');
    print('Base url: $apiBaseUrl');
  }
}