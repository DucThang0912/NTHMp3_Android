import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/auth/login_request.dart';
import '../models/auth/signup_request.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  String? _username;

  AuthProvider(this._authService) {
    _checkAuthStatus();
  }

  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  String? get username => _username;

  // Kiểm tra token có hợp lệ không
  Future<void> _checkAuthStatus() async {
    _isAuthenticated = await _authService.isAuthenticated();
    notifyListeners();
  }

  // Đăng nhập
  Future<bool> login(String username, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _authService
          .login(LoginRequest(username: username, password: password));
      await _authService.saveToken(response.token);
      _isAuthenticated = true;
      _username = username;

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Đăng ký
  Future<bool> register(String username, String email, String password) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      await _authService.register(SignupRequest(
        username: username,
        email: email,
        password: password,
      ));
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    await _authService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}
