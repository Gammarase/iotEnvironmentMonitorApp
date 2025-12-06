/// Data formatting utilities
class Converters {
  Converters._();

  static double decimalStringToFloat(Object? jsonValue)
  {
    if (jsonValue is String) {
      return double.tryParse(jsonValue) ?? 0.0; // Handle potential parsing errors with a default value
    }
    // Handle cases where the value might already be a number or null
    if (jsonValue is num) {
      return jsonValue.toDouble();
    }
    return 0.0; // Default value if not a string or number
  }
}