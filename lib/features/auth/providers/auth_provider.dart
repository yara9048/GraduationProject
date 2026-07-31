import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  Future<void> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("auth_token");

    print("Saved token: $token");

    _isLoggedIn =
        token != null && token.trim().isNotEmpty;
  }

  Future<void> setLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("auth_token");

    _isLoggedIn =
        token != null && token.trim().isNotEmpty;

    notifyListeners();
  }

  Future<void> setLoggedOut() async {
    _isLoggedIn = false;
    notifyListeners();
  }
}