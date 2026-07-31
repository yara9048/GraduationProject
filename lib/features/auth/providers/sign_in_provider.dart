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

      final prefs = await SharedPreferences.getInstance();

      final token = user.access.trim();

      if (token.isEmpty) {
        throw Exception('لم يتم إرجاع التوكن من السيرفر');
      }

      await prefs.setString(
        'auth_token',
        token,
      );

      await prefs.setInt(
        'user_pk',
        user.user.pk,
      );

      final savedToken = prefs.getString('auth_token');

      if (savedToken == null || savedToken.isEmpty) {
        throw Exception('فشل حفظ التوكن');
      }

      print('Saved token: $savedToken');

      _isSuccess = true;

      // يغير AppRoot مباشرة إلى MainNavigationPage
      _authProvider.setLoggedIn();

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
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();
  }
}