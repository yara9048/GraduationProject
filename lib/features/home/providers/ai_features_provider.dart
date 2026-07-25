import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/data/models/ai_features_model.dart';
import 'package:graduationprojct/features/home/data/services/ai_features_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiFeaturesProvider with ChangeNotifier {
  final AiFeaturesService _service = AiFeaturesService();

  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;

  AiFeaturesModel? _aiFeatures;

  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  String? get errorMessage => _errorMessage;

  AiFeaturesModel? get aiFeatures => _aiFeatures;

  List<Summary> get summaries => _aiFeatures?.summaries ?? [];
  List<Mcq> get mcqs => _aiFeatures?.mcqs ?? [];
  List<Chat> get chats => _aiFeatures?.chats ?? [];

  Future<void> getAiFeatures({required int videoId}) async {
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

      _aiFeatures = await _service.getAiFeatures(
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

  Summary? getSummaryByType(String type) {
    try {
      return summaries.firstWhere(
            (e) => e.type == type,
      );
    } catch (_) {
      return null;
    }
  }

  String getSummaryText(Summary? summary) {
    if (summary == null) return "";

    if (summary.data is String) {
      return summary.data;
    }

    if (summary.data is Map &&
        summary.data["text"] != null) {
      return summary.data["text"];
    }

    return summary.data.toString();
  }

  void reset() {
    _isLoading = false;
    _isSuccess = false;
    _errorMessage = null;
    _aiFeatures = null;
    notifyListeners();
  }
}