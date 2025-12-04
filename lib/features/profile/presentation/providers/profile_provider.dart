import 'package:flutter/foundation.dart';
import '../../../auth/domain/entities/user.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';

class ProfileProvider extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  ProfileProvider({
    required this.getProfileUseCase,
    required this.updateProfileUseCase,
  });

  // State
  User? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load profile
  Future<void> loadProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await getProfileUseCase();

    result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
      },
      (user) {
        _user = user;
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Update profile
  Future<bool> updateProfile({
    required String name,
    String? timezone,
    required String language,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await updateProfileUseCase(
      name: name,
      timezone: timezone,
      language: language,
    );

    return result.fold(
      (failure) {
        _error = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (user) {
        _user = user;
        _isLoading = false;
        notifyListeners();
        return true;
      },
    );
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
