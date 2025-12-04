/// API endpoint constants
class ApiEndpoints {
  ApiEndpoints._();

  // Auth endpoints
  static const String register = '/auths/register';
  static const String login = '/auths/login';
  static const String logout = '/auths/logout';
  static const String getUser = '/auths/get-user';
  static const String updateUser = '/auths/update-user';

  // Device endpoints
  static const String devices = '/devices';
  static String deviceById(int id) => '/devices/$id';

  // Recommendation endpoints
  static const String recommendations = '/recommendations';
  static const String pendingRecommendations = '/recommendations/pending';
  static String recommendationById(int id) => '/recommendations/$id';
  static const String acknowledgeRecommendation = '/recommendations/acknowledge';
  static const String dismissRecommendation = '/recommendations/dismiss';

  // Sensor reading endpoints
  static const String currentReadings = '/sensor-readings/current';
  static const String readingsHistory = '/sensor-readings/history';
  static const String createReading = '/sensor-readings';
}
