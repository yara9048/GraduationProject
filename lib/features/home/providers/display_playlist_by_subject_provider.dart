import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/display_playlist_by_subject_model.dart';
import '../data/services/display_playlist_by_subject_service.dart';

class DisplayPlaylistBySubjectProvider with ChangeNotifier {
  final DisplayPlaylistBySubjectService _service =
  DisplayPlaylistBySubjectService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  List<DisplayPlayListBySubjectModel> _playlists = [];

  List<DisplayPlayListBySubjectModel> get playlists => _playlists;

  Future<void> getPlaylists({
    required int subjectId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      final prefs =
      await SharedPreferences.getInstance();

      final token =
      prefs.getString("auth_token");

      if (token == null ||
          token.isEmpty ) {
        throw Exception(
          "Authentication token or class id not found",
        );
      }


      _playlists =
      await _service.getPlaylists(
        token: token,
        subjectId: subjectId,
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