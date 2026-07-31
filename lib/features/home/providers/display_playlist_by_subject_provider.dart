import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/services/display_playlist_by_subject_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/display_favourite_model.dart';
import '../data/models/display_playlist_by_subject_model.dart';
import '../data/services/display_favourite_service.dart';

class DisplayPlaylistBySubjectProvider with ChangeNotifier {
  final DisplayPlaylistBySubjectService _service = DisplayPlaylistBySubjectService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  List<DisplayPlayListBySubjectModel> _playlists = [];

  List<DisplayPlayListBySubjectModel> get playlists => _playlists;

  Future<void> getPlaylists({required int id}) async {
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

      _playlists = await _service.getPlaylists(token: token, id: id);

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