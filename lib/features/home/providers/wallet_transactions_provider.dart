import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/display_playlists_model.dart';
import 'package:graduationprojct/features/home/data/models/wallet_transactions_model.dart';
import 'package:graduationprojct/features/home/data/services/playlist_by_teachers_service.dart';
import 'package:graduationprojct/features/home/data/services/playlist_search_service.dart';
import 'package:graduationprojct/features/home/data/services/wallet_transactions_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletTransactionsProvider with ChangeNotifier {
  final WalletTransactionsService _service =
  WalletTransactionsService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  List<WalletTransactionsModel> _transactions = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  List<WalletTransactionsModel> get transactions =>
      _transactions;

  Future<void> getTransactions() async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    _transactions = [];

    notifyListeners();

    try {
      final prefs =
      await SharedPreferences.getInstance();

      final token =
      prefs.getString("auth_token");

      if (token == null || token.isEmpty) {
        throw Exception(
          "Authentication token not found",
        );
      }

      _transactions =
      await _service.getTransactions(token: token);

      _isSuccess = true;
    } catch (e) {
      _transactions = [];
      _errorMessage = e.toString();
      _isSuccess = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _errorMessage = null;
    _isLoading = false;
    _isSuccess = false;
    notifyListeners();
  }
}