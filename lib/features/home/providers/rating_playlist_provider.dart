import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/rating_playlist_model.dart';
import 'package:graduationprojct/features/home/data/services/rating_playlist_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/add_video_to_fav_model.dart';
import '../data/services/add_video_to_fav_service.dart';

class RatingPlaylistProvider with ChangeNotifier {
  final RatingPlaylistService _service = RatingPlaylistService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  RatingPlaylistModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  RatingPlaylistModel? get response => _response;

  Future<void> rate({
    required int id,
    required String review,
    required int rating
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

      _response = await _service.ratePlaylist(
        token: token,
        playlistId: id,
        rating: rating,
        review: review

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