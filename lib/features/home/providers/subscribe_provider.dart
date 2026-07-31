import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/subscribe_model.dart';
import 'package:graduationprojct/features/home/data/services/subscribe_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/add_video_to_fav_model.dart';
import '../data/services/add_video_to_fav_service.dart';

class SubscribeProvider with ChangeNotifier {
  final SubscribeService _service = SubscribeService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  SubscribeModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  SubscribeModel? get response => _response;

  Future<void> subscribe({
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
      final userPk = prefs.getInt("user_pk");
      print(userPk);
      if (token == null || token.isEmpty) {
        throw Exception("Authentication token not found");
      }

      if (userPk == null) {
        throw Exception("User PK not found");
      }

      _response = await _service.subscribe(
        id: userPk,
        token: token, playlistId: id,
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