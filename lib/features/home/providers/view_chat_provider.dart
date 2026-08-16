import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/view_chat_model.dart';
import '../data/services/view_chat_service.dart';

class ViewChatProvider with ChangeNotifier {
  final ViewChatService _service =
  ViewChatService();

  bool _isLoading = false;
  bool _isSuccess = false;

  String? _errorMessage;

  ViewChatModel? _chat;

  bool get isLoading => _isLoading;

  bool get isSuccess => _isSuccess;

  String? get errorMessage =>
      _errorMessage;

  ViewChatModel? get chat =>
      _chat;

  Future<void> getChat({
    required int videoId,
  }) async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = null;
    _chat = null;

    notifyListeners();

    try {
      debugPrint(
        '========== VIEW CHAT PROVIDER ==========',
      );

      debugPrint(
        'videoId = $videoId',
      );

      final prefs =
      await SharedPreferences.getInstance();

      final token =
      prefs.getString("auth_token");

      if (token == null ||
          token.isEmpty) {
        throw Exception(
          "Authentication token not found",
        );
      }

      _chat =
      await _service.getChat(
        token: token,
        videoId: videoId,
      );

      _isSuccess = true;

      debugPrint(
        'Provider chatId = ${_chat?.id}',
      );

      debugPrint(
        'Provider messages = ${_chat?.messages.length}',
      );
    } catch (e, stackTrace) {
      _errorMessage =
          e.toString();

      _isSuccess = false;

      debugPrint(
        'VIEW CHAT PROVIDER ERROR',
      );

      debugPrint('$e');
      debugPrint('$stackTrace');
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  void reset() {
    _isLoading = false;
    _isSuccess = false;
    _errorMessage = null;
    _chat = null;

    notifyListeners();
  }
}