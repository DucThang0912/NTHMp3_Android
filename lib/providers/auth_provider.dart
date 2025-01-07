import 'package:flutter/material.dart';
import 'package:nthmusicmp3/models/user.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/auth/login_request.dart';
import '../models/auth/signup_request.dart';
import '../models/auth/social_login_request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;
  String? _username;
  User? _currentUser;

  User? get currentUser => _currentUser;

  AuthProvider(this._authService) {
    _initializeAuth();
  }

  // Khởi tạo trạng thái đăng nhập
  Future<void> _initializeAuth() async {
    try {
      _isAuthenticated = await _authService.isAuthenticated();
      if (_isAuthenticated) {
        final prefs = await SharedPreferences.getInstance();
        _username = prefs.getString('username');

        if (_username != null) {
          // Lấy thông tin user từ API
          final userService = UserService();
          _currentUser = await userService.getUserProfile();
        }
      }
    } catch (e) {
      print('Error initializing auth: $e');
      _isAuthenticated = false;
      _username = null;
      _currentUser = null;
    } finally {
      notifyListeners();
    }
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

      print('Calling login API...');
      final response = await _authService
          .login(LoginRequest(username: username, password: password));
      print('Login response: $response');

      await _authService.saveToken(response.token);
      _isAuthenticated = true;
      _username = username;

      return true;
    } catch (e) {
      print('Login error details: $e');
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

  Future<bool> socialLogin(SocialLoginRequest request) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _authService.socialLogin(request);
      await _authService.saveToken(response.token);
      _isAuthenticated = true;
      _username = response.username;

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
