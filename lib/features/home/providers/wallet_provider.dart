import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/wallet_model.dart';
import 'package:graduationprojct/features/home/data/services/wallet_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WalletProvider with ChangeNotifier {
  final WalletService _service = WalletService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  WalletModel? _wallet;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  WalletModel? get wallet => _wallet;

  Future<void> getWallet() async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString("auth_token");

      if (token == null || token.isEmpty) {
        throw Exception("Authentication token not found");
      }

      _wallet = await _service.getWallet(token: token);

      _isSuccess = true;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }


  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _isSuccess = false;
    _wallet = null;
    notifyListeners();
  }
}