/// Application configuration
class AppConfig {
  AppConfig._();

  // API Configuration
  static const String apiBaseUrl = 'http://192.168.0.156/api';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // App Configuration
  static const String appName = 'IoT Environment Monitor';
  static const String appVersion = '1.0.0';

  // Pagination
  static const int defaultPageSize = 15;

  // Chart Configuration
  static const int maxChartDataPoints = 100;

  // Cache Configuration
  static const Duration cacheValidDuration = Duration(minutes: 5);
}
