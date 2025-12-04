/// Storage key constants for secure storage and shared preferences
class StorageKeys {
  StorageKeys._();

  // Auth tokens
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';

  // User data
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';

  // App state
  static const String isFirstLaunch = 'is_first_launch';
  static const String selectedLanguage = 'selected_language';
  static const String selectedTheme = 'selected_theme';

  // Device selection
  static const String lastSelectedDeviceId = 'last_selected_device_id';
}
