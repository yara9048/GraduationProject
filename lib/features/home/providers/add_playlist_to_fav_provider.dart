import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/add_playlist_to_fav_model.dart';
import '../data/services/add_playlist_to_fav_service.dart';

class AddPlaylistToFavProvider with ChangeNotifier {
  final AddPlaylistToFavService _service = AddPlaylistToFavService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  AddToFavModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  AddToFavModel? get response => _response;

  Future<void> addPlaylistToFav({
    required int id,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    _response = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString("auth_token");
      final userPk = prefs.getInt("user_pk");

      if (token == null || token.isEmpty) {
        throw Exception("Authentication token not found");
      }

      if (userPk == null) {
        throw Exception("User PK not found");
      }

      _response = await _service.addToFavPlaylist(
        id: id,
        token: token,
      );

      await prefs.setBool(
        "fav_playlist_${userPk}_$id",
        _response!.status == "added to favorites",
      );

      _isSuccess = true;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _isSuccess = false;
    _response = null;
    notifyListeners();
  }
}