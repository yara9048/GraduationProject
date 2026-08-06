import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/services/now_showing_playlists_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/now_showing_playlist_model.dart';

class NowShowingPlaylistProvider with ChangeNotifier {
  final NowShowingPlaylistsService _service =
  NowShowingPlaylistsService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  List<NowShowingPlaylistModel> _playlists = [];

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get isSuccess => _isSuccess;

  List<NowShowingPlaylistModel> get playlists => _playlists;

  bool get hasPlaylists => _playlists.isNotEmpty;

  Future<void> getPlaylists() async {
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

      final result =
      await _service.getNowShowingPlaylists(token);

      print("API items count: ${result.length}");

      final Map<int, NowShowingPlaylistModel> uniqueCourses = {};

      for (final item in result) {
        final courseId = item.courseDetail?.id;

        if (courseId != null) {
          uniqueCourses[courseId] = item;
        }
      }

      _playlists = uniqueCourses.values.toList();

      print("Unique courses count: ${_playlists.length}");

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

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _isSuccess = false;
    _playlists = [];

    notifyListeners();
  }
}