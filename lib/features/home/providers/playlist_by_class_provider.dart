import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/playlist_by_class_model.dart';
import '../data/services/playlist_by_class_service.dart';

class PlaylistByClassProvider with ChangeNotifier {
  final PlaylistByClassService _service =
  PlaylistByClassService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  List<PlaylistByClassModel> _playlists = [];

  List<PlaylistByClassModel> get playlists =>
      _playlists;

  Future<void> getPlaylists() async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      final prefs =
      await SharedPreferences.getInstance();

      final token =
      prefs.getString("auth_token");

      final classId =
      prefs.getInt("class_id");

      if (token == null ||
          token.isEmpty ||
          classId == null) {
        throw Exception(
          "Authentication token or class id not found",
        );
      }

      _playlists =
      await _service.getPlaylists(
        token: token,
        classId: classId,
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
    _playlists = [];
    notifyListeners();
  }
}