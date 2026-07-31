import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/sign_in_model.dart';
import '../data/services/sign_in_service.dart';
import 'auth_provider.dart';

class SignInProvider with ChangeNotifier {
  final SignInService _service = SignInService();
  final AuthProvider _authProvider;

  SignInProvider({
    required AuthProvider authProvider,
  }) : _authProvider = authProvider;

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<bool> login(
      String email,
      String password,
      ) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      final SignInModel user = await _service.signIn(
        email: email.trim(),
        password: password,
      );

      final String token = user.access.trim();

      if (token.isEmpty) {
        throw Exception('لم يتم إرجاع التوكن من السيرفر');
      }

      final prefs = await SharedPreferences.getInstance();

      final bool tokenSaved = await prefs.setString(
        'auth_token',
        token,
      );

      final bool userIdSaved = await prefs.setInt(
        'user_pk',
        user.user.pk,
      );

      if (!tokenSaved || !userIdSaved) {
        throw Exception('فشل حفظ بيانات تسجيل الدخول');
      }

      final savedToken = prefs.getString('auth_token');

      if (savedToken == null || savedToken.trim().isEmpty) {
        throw Exception('فشل حفظ التوكن');
      }

      print('Saved token: $savedToken');

      _isSuccess = true;

      await _authProvider.setLoggedIn();

      print(
        'AuthProvider isLoggedIn: ${_authProvider.isLoggedIn}',
      );

      return true;
    } catch (e) {
      _isSuccess = false;
      _errorMessage = e
          .toString()
          .replaceFirst('Exception: ', '');

      print('Login error: $_errorMessage');

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _isSuccess = false;

    notifyListeners();
  }
}