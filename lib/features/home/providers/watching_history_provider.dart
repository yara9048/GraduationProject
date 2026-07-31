import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/watching_history_nodel.dart';
import 'package:graduationprojct/features/home/data/services/now_showing_playlists_service.dart';
import 'package:graduationprojct/features/home/data/services/watching_history_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/now_showing_playlist_model.dart';

class WatchingHistoryProvider with ChangeNotifier {
  final WatchingHistoryService _service =
  WatchingHistoryService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  List<WatchingHistoryModel> _playlists = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  List<WatchingHistoryModel> get playlists => _playlists;

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

      _playlists = await _service.getHistory(token);

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