import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/display_playlists_model.dart';
import 'package:graduationprojct/features/home/data/models/filtered_playlist_model.dart';
import 'package:graduationprojct/features/home/data/services/filtered_playlist_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/data/models/profile_model.dart';
import '../data/services/display_playlists_service.dart';
import '../../auth/data/services/profile_service.dart';

class FilteredPlaylistProvider with ChangeNotifier {
  final FilteredPlaylistService _service = FilteredPlaylistService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;


  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  List<FilteredPlayListsModel> _filtered_playlists = [];
  List<FilteredPlayListsModel> get filtered_playlists => _filtered_playlists;


  Future<void> getFilteredPlaylists() async {
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
      _filtered_playlists = await _service.getFilteredPlayLists(token);

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
    _filtered_playlists = [];
    notifyListeners();
  }
}