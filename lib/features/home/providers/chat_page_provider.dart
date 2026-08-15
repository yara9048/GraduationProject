import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/services/chat_message_service.dart';
import '../data/services/view_chat_service.dart';

class ChatUiMessage {
  final String type;
  final String text;

  const ChatUiMessage({
    required this.type,
    required this.text,
  });

  bool get isUser => type == 'user';
}

class ChatPageProvider extends ChangeNotifier {
  final ViewChatService _viewChatService = ViewChatService();
  final ChatMessageService _chatMessageService = ChatMessageService();

  final List<ChatUiMessage> _messages = [];

  List<ChatUiMessage> get messages =>
      List.unmodifiable(_messages);

  bool _isLoadingHistory = false;

  bool get isLoadingHistory => _isLoadingHistory;

  bool _isSending = false;

  bool get isSending => _isSending;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  int _activeChatId = 2;

  int get activeChatId => _activeChatId;

  bool get hasMessages => _messages.isNotEmpty;

  Future<String> _getToken() async {
    final prefs =
    await SharedPreferences.getInstance();

    final token =
    prefs.getString('auth_token');

    if (token == null || token.isEmpty) {
      throw Exception(
        'Authentication token not found',
      );
    }

    return token;
  }
  void addUserMessage(String text) {
    final cleanText = text.trim();

    if (cleanText.isEmpty) return;

    _messages.add(
      ChatUiMessage(
        type: 'user',
        text: cleanText,
      ),
    );

    notifyListeners();
  }

  void addBotMessage(String text) {
    final cleanText = text.trim();

    if (cleanText.isEmpty) return;

    _messages.add(
      ChatUiMessage(
        type: 'bot',
        text: cleanText,
      ),
    );

    notifyListeners();
  }
  Future<void> loadHistory({
    int chatId = 2,
  }) async {
    if (_isLoadingHistory) return;

    _isLoadingHistory = true;
    _errorMessage = null;
    _activeChatId = chatId;

    notifyListeners();

    try {
      final token = await _getToken();

      final chats =
      await _viewChatService.getChat(
        id: chatId,
        token: token,
      );

      if (chats.isEmpty) {
        _messages.clear();

        _errorMessage =
        'لا توجد محادثات متاحة';

        return;
      }

      final selectedChat = chats.firstWhere(
            (chat) => chat.id == chatId,
        orElse: () => chats.first,
      );

      _activeChatId = selectedChat.id;

      _messages.clear();

      for (final message
      in selectedChat.messages) {
        _messages.add(
          ChatUiMessage(
            type: message.sender == 'user'
                ? 'user'
                : 'bot',
            text: message.text,
          ),
        );
      }
    } catch (e) {
      _errorMessage =
          _cleanErrorMessage(e);
    } finally {
      _isLoadingHistory = false;

      notifyListeners();
    }
  }

  Future<bool> sendMessage({
    required String text,
  }) async {
    final cleanText = text.trim();

    if (cleanText.isEmpty || _isSending) {
      return false;
    }

    _errorMessage = null;
    _isSending = true;

    _messages.add(
      ChatUiMessage(
        type: 'user',
        text: cleanText,
      ),
    );

    notifyListeners();

    try {
      final token = await _getToken();

      final response =
      await _chatMessageService.create(
        token: token,
        id: _activeChatId,
        text: cleanText,
      );

      /*
       * هذا الجزء يعمل فقط إذا endpoint إرسال الرسالة
       * يرجع جواب AI مباشرة بالشكل:
       *
       * {
       *   "sender": "ai",
       *   "text": "جواب الذكاء الاصطناعي"
       * }
       */

      if (response.sender == 'ai' &&
          response.text.trim().isNotEmpty) {
        _messages.add(
          ChatUiMessage(
            type: 'bot',
            text: response.text.trim(),
          ),
        );
      }

      return true;
    } catch (e) {
      _errorMessage =
          _cleanErrorMessage(e);

      return false;
    } finally {
      _isSending = false;

      notifyListeners();
    }
  }

  Future<void> refreshHistory() async {
    await loadHistory(
      chatId: _activeChatId,
    );
  }

  void clearError() {
    _errorMessage = null;

    notifyListeners();
  }

  void reset() {
    _messages.clear();
    _errorMessage = null;
    _isLoadingHistory = false;
    _isSending = false;
    _activeChatId = 2;

    notifyListeners();
  }

  String _cleanErrorMessage(
      Object error,
      ) {
    return error
        .toString()
        .replaceFirst(
      'Exception: ',
      '',
    );
  }
}