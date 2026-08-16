import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/funding_request_model.dart';
import 'package:graduationprojct/features/home/data/models/rating_playlist_model.dart';
import 'package:graduationprojct/features/home/data/models/send_rag_message_model.dart';
import 'package:graduationprojct/features/home/data/models/send_web_search_model.dart';
import 'package:graduationprojct/features/home/data/services/funding_request_service.dart';
import 'package:graduationprojct/features/home/data/services/rating_playlist_service.dart';
import 'package:graduationprojct/features/home/data/services/send_rag_message_service.dart';
import 'package:graduationprojct/features/home/data/services/send_web_search_message_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/add_video_to_fav_model.dart';
import '../data/services/add_video_to_fav_service.dart';

class SendWebSearchMessageProvider with ChangeNotifier {
  final SendWebSearchMessageService _service = SendWebSearchMessageService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  SendWebSearchModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  SendWebSearchModel? get response => _response;

  Future<void> sendWeb({
    required String text,
    required int chatId,
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

      _response = await _service.sendWeb(
        token: token,
        text:text,
        chatId:chatId,
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