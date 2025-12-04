import 'constants.dart';

/// Form validation utilities
class Validators {
  Validators._();

  /// Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    if (value.length > AppConstants.maxEmailLength) {
      return 'Email is too long (max ${AppConstants.maxEmailLength} characters)';
    }

    return null;
  }

  /// Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    return null;
  }

  /// Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.length > AppConstants.maxNameLength) {
      return 'Name is too long (max ${AppConstants.maxNameLength} characters)';
    }

    return null;
  }

  /// Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Numeric validation
  static String? validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (double.tryParse(value) == null) {
      return '$fieldName must be a number';
    }

    return null;
  }

  /// Latitude validation
  static String? validateLatitude(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    final lat = double.tryParse(value);
    if (lat == null) {
      return 'Latitude must be a number';
    }

    if (lat < -90 || lat > 90) {
      return 'Latitude must be between -90 and 90';
    }

    return null;
  }

  /// Longitude validation
  static String? validateLongitude(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Optional field
    }

    final lon = double.tryParse(value);
    if (lon == null) {
      return 'Longitude must be a number';
    }

    if (lon < -180 || lon > 180) {
      return 'Longitude must be between -180 and 180';
    }

    return null;
  }
}
