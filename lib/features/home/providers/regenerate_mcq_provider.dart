import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/data/models/ai_features_model.dart';
import 'package:graduationprojct/features/home/data/services/ai_features_service.dart';
import 'package:graduationprojct/features/home/data/services/regenerate_mcq_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/regenerate_mcq_model.dart';

class RegenerateMcqProvider with ChangeNotifier {
  final RegenerateMcqService _service = RegenerateMcqService();

  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;

  RegnerateMcqModel? _mcq;

  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  String? get errorMessage => _errorMessage;

  RegnerateMcqModel? get mcq => _mcq;

  Future<void> regenerate({required int videoId}) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("auth_token");

      if (token == null || token.isEmpty) {
        throw Exception("Authentication token not found");
      }

      _mcq = await _service.regenerate(
        token: token,
        videoId: videoId,
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
    _isSuccess = false;
    _errorMessage = null;
    _mcq = null;
    notifyListeners();
  }
}