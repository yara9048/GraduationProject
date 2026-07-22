import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/add_playlist_to_fav_model.dart';
import 'package:graduationprojct/features/home/data/services/add_playlist_to_fav_service.dart';
import 'package:graduationprojct/features/home/data/services/add_video_to_fav_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/add_video_to_fav_model.dart';

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

      if (token == null || token.isEmpty) {
        throw Exception("Authentication token not found");
      }

      _response = await _service.addVidToFavPlaylist(
        id: id,
        token: token,
      );

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
    _response = null;
    notifyListeners();
  }
}