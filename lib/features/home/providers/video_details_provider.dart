import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/video_details_model.dart';
import 'package:graduationprojct/features/home/data/services/video_details_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class VideoDetailsProvider with ChangeNotifier {
  final VideoDetailsService _service = VideoDetailsService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  VideoDetailsModel? _videoDetails;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  VideoDetailsModel? get videoDetails => _videoDetails;

  Future<void> getDetails({required int id}) async {
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
      _videoDetails = await _service.getDetails(id: id, token: token);

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
    _videoDetails = null;
    notifyListeners();
  }
}