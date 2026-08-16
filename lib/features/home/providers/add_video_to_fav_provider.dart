import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/add_video_to_fav_model.dart';
import '../data/services/add_video_to_fav_service.dart';

class AddVideoToFavProvider with ChangeNotifier {
  final AddVideoToFavService _service =
  AddVideoToFavService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool _isFavorite = false;

  AddVideoToFavModel? _response;

  bool get isLoading => _isLoading;

  String? get errorMessage =>
      _errorMessage;

  bool get isSuccess => _isSuccess;

  bool get isFavorite => _isFavorite;

  AddVideoToFavModel? get response =>
      _response;

  // =====================================================
  // Load Initial Favorite State
  // =====================================================

  Future<void> loadFavoriteState({
    required int id,
  }) async {
    try {
      final prefs =
      await SharedPreferences
          .getInstance();

      final int? userPk =
      prefs.getInt(
        "user_pk",
      );

      if (userPk == null) {
        _isFavorite = false;

        notifyListeners();

        return;
      }

      _isFavorite =
          prefs.getBool(
            "fav_video_${userPk}_$id",
          ) ??
              false;

      notifyListeners();
    } catch (e) {
      _isFavorite = false;

      notifyListeners();
    }
  }

  // =====================================================
  // Add / Remove Favorite
  // =====================================================

  Future<void> addVidToFav({
    required int id,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    _response = null;

    notifyListeners();

    try {
      final prefs =
      await SharedPreferences
          .getInstance();

      final String? token =
      prefs.getString(
        "auth_token",
      );

      final int? userPk =
      prefs.getInt(
        "user_pk",
      );

      if (token == null ||
          token.isEmpty) {
        throw Exception(
          "Authentication token not found",
        );
      }

      if (userPk == null) {
        throw Exception(
          "User PK not found",
        );
      }

      _response =
      await _service
          .addVidToFavPlaylist(
        id: id,
        token: token,
      );

      // السيرفر بيرجع:
      // added to favorites
      // أو حالة الإزالة

      _isFavorite =
          _response!.status ==
              "added to favorites";

      await prefs.setBool(
        "fav_video_${userPk}_$id",
        _isFavorite,
      );

      _isSuccess = true;
    } catch (e) {
      _errorMessage =
          e.toString();
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