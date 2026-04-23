import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _currentUsername;
  String? _errorMessage;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get currentUsername => _currentUsername;
  String? get errorMessage => _errorMessage;

  // Инициализация при запуске приложения
  Future<void> checkLoginStatus() async {
    _isLoggedIn = await AuthService.isLoggedIn();
    if (_isLoggedIn) {
      final isValid = await AuthService.verifyToken();
      _isLoggedIn = isValid;
      if (!isValid) {
        await AuthService.logout();
      }
    }
    notifyListeners();
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await AuthService.register(
        username: username,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (result == null) {
        _errorMessage = 'Неизвестная ошибка';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (result.containsKey('error')) {
        _errorMessage = result['error'];
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _isLoggedIn = true;
      _currentUsername = username;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await AuthService.login(
        username: username,
        password: password,
      );

      if (result == null) {
        _errorMessage = 'Неизвестная ошибка';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (result.containsKey('error')) {
        _errorMessage = result['error'];
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _isLoggedIn = true;
      _currentUsername = username;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Ошибка: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    _isLoggedIn = false;
    _currentUsername = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
