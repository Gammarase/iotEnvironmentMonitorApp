/// App-wide constants
class AppConstants {
  AppConstants._();

  // Date formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 255;
  static const int maxEmailLength = 255;

  // Enums
  static const List<String> supportedLanguages = ['en', 'uk'];
  static const List<String> priorities = ['low', 'medium', 'high'];
  static const List<String> recommendationStatuses = [
    'pending',
    'acknowledged',
    'dismissed'
  ];
  static const List<String> recommendationTypes = [
    'ventilate',
    'lighting',
    'noise',
    'break',
    'temperature',
    'humidity'
  ];

  // Sensor units
  static const String temperatureUnit = '°C';
  static const String humidityUnit = '%';
  static const String lightUnit = 'lux';
  static const String noiseUnit = 'dB';
  static const String tvocUnit = 'ppm';

  // Statistics periods
  static const String periodWeek = 'week';
  static const String periodMonth = 'month';
}
