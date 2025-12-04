import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../../../core/error/failures.dart';

/// Auth state
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
}

/// Auth provider for global authentication state
class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
  });

  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _error;
  bool _isLoading = false;

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  /// Check authentication status on app start
  Future<void> checkAuthStatus() async {
    _status = AuthStatus.loading;
    notifyListeners();

    final result = await getCurrentUserUseCase();

    result.fold(
      (failure) {
        _status = AuthStatus.unauthenticated;
        _user = null;
        notifyListeners();
      },
      (user) {
        _status = AuthStatus.authenticated;
        _user = user;
        notifyListeners();
      },
    );
  }

  /// Login
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await loginUseCase(email: email, password: password);

    return result.fold(
      (failure) {
        _isLoading = false;
        _error = _mapFailureToMessage(failure);
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      },
      (data) {
        _isLoading = false;
        _user = data['user'] as User;
        _status = AuthStatus.authenticated;
        _error = null;
        notifyListeners();
        return true;
      },
    );
  }

  /// Register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    String? timezone,
    String? language,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final result = await registerUseCase(
      name: name,
      email: email,
      password: password,
      timezone: timezone,
      language: language,
    );

    return result.fold(
      (failure) {
        _isLoading = false;
        _error = _mapFailureToMessage(failure);
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return false;
      },
      (data) {
        _isLoading = false;
        _user = data['user'] as User;
        _status = AuthStatus.authenticated;
        _error = null;
        notifyListeners();
        return true;
      },
    );
  }

  /// Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await logoutUseCase();

    _isLoading = false;
    _user = null;
    _status = AuthStatus.unauthenticated;
    _error = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Map failure to user-friendly message
  String _mapFailureToMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return 'No internet connection. Please check your network.';
    } else if (failure is AuthenticationFailure) {
      return failure.message;
    } else if (failure is ValidationFailure) {
      // Get first validation error
      final firstError = failure.errors.values.first.first;
      return firstError;
    } else if (failure is ServerFailure) {
      return failure.message;
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
