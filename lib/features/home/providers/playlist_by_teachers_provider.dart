import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/display_playlists_model.dart';
import 'package:graduationprojct/features/home/data/services/playlist_by_teachers_service.dart';
import 'package:graduationprojct/features/home/data/services/playlist_search_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistByTeachersProvider with ChangeNotifier {
  final PlaylistByTeachersService _service =
  PlaylistByTeachersService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  List<DisplayPlaylistsModel> _playlists = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  List<DisplayPlaylistsModel> get playlists =>
      _playlists;

  Future<void> playlistByTeacher({
    required int id,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    _playlists = [];

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

      _playlists =
      await _service.playlistByTeacher(
        token: token,
        id: id,
      );

      _isSuccess = true;
    } catch (e) {
      _playlists = [];
      _errorMessage = e.toString();
      _isSuccess = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetSearch() {
    _playlists.clear();
    _errorMessage = null;
    _isLoading = false;
    _isSuccess = false;
    notifyListeners();
  }
}