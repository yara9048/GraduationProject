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

      final String accessToken = user.access.trim();
      final String refreshToken = user.refresh.trim();
      final int classId = user.user.classId;

      if (accessToken.isEmpty) {
        throw Exception('لم يتم إرجاع access token من السيرفر');
      }

      if (refreshToken.isEmpty) {
        throw Exception('لم يتم إرجاع refresh token من السيرفر');
      }
      if (classId.isNaN) {
        throw Exception('لم يتم إرجاعclassid من السيرفر');
      }
      final prefs = await SharedPreferences.getInstance();

      final bool accessSaved = await prefs.setString(
        'auth_token',
        accessToken,
      );

      final bool refreshSaved = await prefs.setString(
        'refresh_token',
        refreshToken,
      );

      final bool userIdSaved = await prefs.setInt(
        'user_pk',
        user.user.id,
      );

      final bool subjectIdSaves = await prefs.setInt(
        'class_id',
        user.user.classId,
      );

      if (!accessSaved || !refreshSaved || !userIdSaved || !subjectIdSaves) {
        throw Exception('فشل حفظ بيانات تسجيل الدخول');
      }

      print('Access Token saved');
      print('Refresh Token saved');
      print('user id saved');
      print('class id saved');

      _isSuccess = true;

      await _authProvider.setLoggedIn();

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