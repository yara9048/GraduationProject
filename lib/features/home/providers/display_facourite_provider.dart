import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/display_favourite_model.dart';
import '../data/services/display_favourite_service.dart';

class DisplayFavouriteProvider with ChangeNotifier {
  final DisplayFavouriteService _service = DisplayFavouriteService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  List<DisplayFavouriteModel> _favourites = [];

  List<DisplayFavouriteModel> get favourites => _favourites;

  Future<void> getFavourites() async {
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

      _favourites = await _service.getFavourites(token: token);

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
    _favourites = [];
    notifyListeners();
  }
}