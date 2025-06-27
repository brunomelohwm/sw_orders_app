import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sw_orders_app/core/helpers/error_helper.dart';
import 'package:sw_orders_app/models/user_model.dart';
import 'package:sw_orders_app/services/auth_service.dart';
import 'package:sw_orders_app/services/user_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;
  final UserService _userService;
  AuthViewModel(this._authService, this._userService);

  String _username = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;
  UserModel? _currentUser;

  String get userame => _username;
  String get password => _password;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;

  void setUsername(String value) {
    _username = value;
  }

  void setPassword(String value) {
    _password = value;
  }

  Future<bool> login() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final tokenResponse = await _authService.login(_username, _password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('access_token', tokenResponse.accessToken);
      await prefs.setString('refresh_token', tokenResponse.refreshToken);

      final user = await _userService.getCurrentUser(tokenResponse.accessToken);

      _currentUser = user;

      return true;
    } catch (e) {
      _errorMessage = ErrorHelper.getErrorMessage(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token != null && token.isNotEmpty) {
      try {
        final user = await _userService.getCurrentUser(token);
        _currentUser = user;
        notifyListeners();
      } catch (e) {
        _errorMessage = ErrorHelper.getErrorMessage(e);
        return;
      }
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
    _currentUser = null;
    notifyListeners();
  }
}
