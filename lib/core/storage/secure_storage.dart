import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_keys.dart';

/// Wrapper around FlutterSecureStorage for secure token and sensitive data storage
class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage(this._storage);

  // Token management
  Future<void> saveToken(String token) async {
    await _storage.write(key: StorageKeys.authToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: StorageKeys.authToken);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: StorageKeys.authToken);
  }

  // User ID
  Future<void> saveUserId(int userId) async {
    await _storage.write(
      key: StorageKeys.userId,
      value: userId.toString(),
    );
  }

  Future<int?> getUserId() async {
    final id = await _storage.read(key: StorageKeys.userId);
    return id != null ? int.tryParse(id) : null;
  }

  // User email
  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: StorageKeys.userEmail, value: email);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: StorageKeys.userEmail);
  }

  // User name
  Future<void> saveUserName(String name) async {
    await _storage.write(key: StorageKeys.userName, value: name);
  }

  Future<String?> getUserName() async {
    return await _storage.read(key: StorageKeys.userName);
  }

  // Clear all secure data
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Check if user has token (is logged in)
  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
