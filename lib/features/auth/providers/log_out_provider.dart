import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/services/log_out_services.dart';
import 'auth_provider.dart';

class LogoutProvider extends ChangeNotifier {
  final LogoutService _service = LogoutService();
  final AuthProvider _authProvider;

  LogoutProvider({
    required AuthProvider authProvider,
  }) : _authProvider = authProvider;

  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  String? get errorMessage => _errorMessage;

  Future<bool> logout() async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      /*
       * نحاول إرسال طلب Logout للسيرفر.
       * حتى لو فشل السيرفر، نحذف التوكن محلياً.
       */
      if (token != null && token.trim().isNotEmpty) {
        try {
          await _service.logout(token);
        } catch (e) {
          debugPrint('Server logout error: $e');
        }
      }

      await prefs.remove('auth_token');
      await prefs.remove('user_pk');

      _isSuccess = true;

      // يغير AppRoot مباشرة إلى SignInPage
      _authProvider.setLoggedOut();

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isSuccess = false;

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _isLoading = false;
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();
  }
}