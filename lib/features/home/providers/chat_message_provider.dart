import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/chat_message_model.dart';
import 'package:graduationprojct/features/home/data/models/create_chat_model.dart';
import 'package:graduationprojct/features/home/data/models/funding_request_model.dart';
import 'package:graduationprojct/features/home/data/models/rating_playlist_model.dart';
import 'package:graduationprojct/features/home/data/models/refund_request_model.dart';
import 'package:graduationprojct/features/home/data/services/chat_message_service.dart';
import 'package:graduationprojct/features/home/data/services/create_chat_service.dart';
import 'package:graduationprojct/features/home/data/services/funding_request_service.dart';
import 'package:graduationprojct/features/home/data/services/rating_playlist_service.dart';
import 'package:graduationprojct/features/home/data/services/refund_request_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/add_video_to_fav_model.dart';
import '../data/services/add_video_to_fav_service.dart';

class ChatMessageProvider with ChangeNotifier {
  final ChatMessageService _service = ChatMessageService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  ChatMessageModel? _response;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  ChatMessageModel? get response => _response;

  Future<void> create({
    required int id,
    required String text
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

      _response = await _service.create(
        token: token,
        id: id,
        text: text
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