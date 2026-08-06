import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/view_chat_model.dart';
import 'package:graduationprojct/features/home/data/services/view_chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/display_favourite_model.dart';
import '../data/services/display_favourite_service.dart';

class ViewChatProvider with ChangeNotifier {
  final ViewChatService _service = ViewChatService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  List<ViewChatModel> _chat = [];

  List<ViewChatModel> get chat => _chat;

  Future<void> getChat({required int id}) async {
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

      _chat = await _service.getChat(token: token, id: id);

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
    _chat = [];
    notifyListeners();
  }
}