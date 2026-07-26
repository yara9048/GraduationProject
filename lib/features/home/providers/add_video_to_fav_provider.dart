import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/add_video_to_fav_model.dart';
import '../data/services/add_video_to_fav_service.dart';

class AddVideoToFavProvider with ChangeNotifier {
  final AddVideoToFavService _service = AddVideoToFavService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  AddVideoToFavModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  AddVideoToFavModel? get response => _response;

  Future<void> addVidToFav({
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
      print(userPk);
      if (token == null || token.isEmpty) {
        throw Exception("Authentication token not found");
      }

      if (userPk == null) {
        throw Exception("User PK not found");
      }

      _response = await _service.addVidToFavPlaylist(
        id: id,
        token: token,
      );

      await prefs.setBool(
        "fav_video_${userPk}_$id",
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