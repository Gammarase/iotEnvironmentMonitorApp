import 'package:intl/intl.dart';
import 'constants.dart';

/// Data formatting utilities
class Formatters {
  Formatters._();

  /// Format Unix timestamp to date string
  static String formatDate(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat(AppConstants.dateFormat).format(date);
  }

  /// Format Unix timestamp to date-time string
  static String formatDateTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat(AppConstants.dateTimeFormat).format(date);
  }

  /// Format Unix timestamp to time string
  static String formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat(AppConstants.timeFormat).format(date);
  }

  /// Format DateTime to API format (ISO 8601)
  static String formatDateTimeForApi(DateTime dateTime) {
    return dateTime.toIso8601String();
  }

  /// Format number with decimal places
  static String formatNumber(double value, {int decimals = 2}) {
    return value.toStringAsFixed(decimals);
  }

  /// Format temperature value
  static String formatTemperature(String temperature) {
    final temp = double.tryParse(temperature);
    if (temp == null) return temperature;
    return '${formatNumber(temp, decimals: 1)}${AppConstants.temperatureUnit}';
  }

  /// Format humidity value
  static String formatHumidity(String humidity) {
    final hum = double.tryParse(humidity);
    if (hum == null) return humidity;
    return '${formatNumber(hum, decimals: 1)}${AppConstants.humidityUnit}';
  }

  /// Format light value
  static String formatLight(int light) {
    return '$light ${AppConstants.lightUnit}';
  }

  /// Format noise value
  static String formatNoise(int noise) {
    return '$noise ${AppConstants.noiseUnit}';
  }

  /// Format TVOC value
  static String formatTvoc(int? tvoc) {
    if (tvoc == null) return 'N/A';
    return '$tvoc ${AppConstants.tvocUnit}';
  }

  /// Format relative time (e.g., "2 hours ago")
  static String formatRelativeTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return formatDate(timestamp);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }
}
