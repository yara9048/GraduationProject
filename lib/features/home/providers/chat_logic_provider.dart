import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/send_web_search_model.dart';
import '../data/models/view_chat_model.dart';

import '../data/services/send_rag_message_service.dart';
import '../data/services/send_web_search_message_service.dart';
import '../data/services/view_chat_service.dart';

class ChatLogicMessage {
  final String type;
  final String text;

  const ChatLogicMessage({
    required this.type,
    required this.text,
  });

  bool get isUser =>
      type == 'user';

  bool get isAi =>
      !isUser;
}

class ChatLogicProvider
    extends ChangeNotifier {
  final ViewChatService
  _viewChatService =
  ViewChatService();

  final SendRagMessageService
  _ragService =
  SendRagMessageService();

  final SendWebSearchMessageService
  _webService =
  SendWebSearchMessageService();

  // =============================================================
  // Chat
  // =============================================================

  ViewChatModel? _chat;

  ViewChatModel? get chat =>
      _chat;

  int? _chatId;

  int? get chatId =>
      _chatId;

  int? _videoId;

  int? get videoId =>
      _videoId;

  final List<ChatLogicMessage>
  _messages = [];

  List<ChatLogicMessage>
  get messages =>
      List.unmodifiable(
        _messages,
      );

  bool get hasMessages =>
      _messages.isNotEmpty;

  // =============================================================
  // States
  // =============================================================

  bool _isSending = false;

  bool get isSending =>
      _isSending;

  bool _isWaitingForAi = false;

  bool get isWaitingForAi =>
      _isWaitingForAi;

  bool _isPolling = false;

  bool get isPolling =>
      _isPolling;

  bool _isCheckingPoll = false;

  // =============================================================
  // Web
  // =============================================================

  bool _webSearch = false;

  bool get webSearch =>
      _webSearch;

  // =============================================================
  // Error
  // =============================================================

  String? _errorMessage;

  String? get errorMessage =>
      _errorMessage;

  // =============================================================
  // Polling
  // =============================================================

  Timer? _pollingTimer;

  int _aiMessagesBeforeSend = 0;

  // =============================================================
  // Token
  // =============================================================

  Future<String> _getToken() async {
    final prefs =
    await SharedPreferences
        .getInstance();

    final token =
    prefs.getString(
      "auth_token",
    );

    if (token == null ||
        token.isEmpty) {
      throw Exception(
        "Authentication token not found",
      );
    }

    return token;
  }

  // =============================================================
  // Initialize
  // =============================================================
  //
  // لا يعمل View.
  // الـView صار معمول قبل فتح الصفحة.
  //
  // هنا فقط:
  // videoId
  // chatId
  // initialChat
  //
  // وبنعرض الرسائل الموجودة مباشرة.
  // =============================================================

  void initialize({
    required int videoId,
    required int chatId,
    required ViewChatModel initialChat,
  }) {
    stopPolling();

    _videoId =
        videoId;

    _chatId =
        chatId;

    _chat =
        initialChat;

    _messages.clear();

    // قراءة التاريخ الموجود
    _readChatMessages(
      initialChat,
    );

    _isSending = false;

    _isWaitingForAi = false;

    _isPolling = false;

    _isCheckingPoll = false;

    _errorMessage = null;

    _webSearch = false;

    _aiMessagesBeforeSend = 0;

    debugPrint(
      '========== CHAT INITIALIZED ==========',
    );

    debugPrint(
      'videoId = $_videoId',
    );

    debugPrint(
      'chatId = $_chatId',
    );

    debugPrint(
      'messages count = ${_messages.length}',
    );

    debugPrint(
      '======================================',
    );

    notifyListeners();
  }

  // =============================================================
  // Web Search
  // =============================================================

  void toggleWebSearch() {
    if (_isSending ||
        _isWaitingForAi) {
      return;
    }

    _webSearch =
    !_webSearch;

    notifyListeners();
  }

  void setWebSearch(
      bool value,
      ) {
    if (_isSending ||
        _isWaitingForAi) {
      return;
    }

    _webSearch =
        value;

    notifyListeners();
  }

  // =============================================================
  // Send
  // =============================================================

  Future<void> sendMessage({
    required String text,
  }) async {
    final cleanText =
    text.trim();

    if (cleanText.isEmpty) {
      return;
    }

    if (_isSending ||
        _isWaitingForAi) {
      return;
    }

    if (_chatId == null) {
      _errorMessage =
      'Chat ID غير موجود';

      notifyListeners();

      return;
    }

    if (_videoId == null) {
      _errorMessage =
      'Video ID غير موجود';

      notifyListeners();

      return;
    }

    _errorMessage = null;

    if (_webSearch) {
      await _sendWebMessage(
        cleanText,
      );
    } else {
      await _sendRagMessage(
        cleanText,
      );
    }
  }

  // =============================================================
  // RAG
  // =============================================================

  Future<void> _sendRagMessage(
      String text,
      ) async {
    _isSending = true;

    _errorMessage = null;

    // عدد AI قبل إرسال السؤال
    _aiMessagesBeforeSend =
        _messages
            .where(
              (message) =>
          message.isAi,
        )
            .length;

    // نعرض المستخدم مباشرة
    _messages.add(
      ChatLogicMessage(
        type: 'user',
        text: text,
      ),
    );

    notifyListeners();

    try {
      final token =
      await _getToken();

      debugPrint(
        '========== SEND RAG ==========',
      );

      debugPrint(
        'chatId = $_chatId',
      );

      debugPrint(
        'text = $text',
      );

      await _ragService.sendRag(
        token: token,
        text: text,
        chatId: _chatId!,
      );

      _isSending = false;

      _isWaitingForAi = true;

      notifyListeners();

      _startPolling();
    } catch (e) {
      _isSending = false;

      _isWaitingForAi = false;

      _errorMessage =
          e.toString();

      notifyListeners();
    }
  }

  // =============================================================
  // WEB
  // =============================================================

  Future<void> _sendWebMessage(
      String text,
      ) async {
    _isSending = true;

    _errorMessage = null;

    _messages.add(
      ChatLogicMessage(
        type: 'user',
        text: text,
      ),
    );

    notifyListeners();

    try {
      final token =
      await _getToken();

      debugPrint(
        '========== SEND WEB ==========',
      );

      debugPrint(
        'chatId = $_chatId',
      );

      debugPrint(
        'text = $text',
      );

      final SendWebSearchModel
      response =
      await _webService.sendWeb(
        token: token,
        text: text,
        chatId: _chatId!,
      );

      final aiText =
      _extractWebResponse(
        response,
      );

      if (aiText != null &&
          aiText
              .trim()
              .isNotEmpty) {
        _messages.add(
          ChatLogicMessage(
            type: 'ai',
            text:
            aiText.trim(),
          ),
        );
      }
    } catch (e) {
      _errorMessage =
          e.toString();
    } finally {
      _isSending = false;

      notifyListeners();
    }
  }

  // =============================================================
  // Polling
  // =============================================================

  void _startPolling() {
    stopPolling(
      keepWaitingState: true,
    );

    _isPolling = true;

    _isWaitingForAi = true;

    notifyListeners();

    debugPrint(
      'RAG POLLING STARTED',
    );

    _pollingTimer =
        Timer.periodic(
          const Duration(
            seconds: 3,
          ),
              (_) async {
            await _checkForNewAiMessage();
          },
        );
  }

  // =============================================================
  // Check New AI Message
  // =============================================================

  Future<void>
  _checkForNewAiMessage() async {
    if (!_isPolling) {
      return;
    }

    if (_isCheckingPoll) {
      return;
    }

    _isCheckingPoll = true;

    try {
      debugPrint(
        'POLLING => VIEW CHAT',
      );

      await _loadChatFromView(
        notify: false,
      );

      final currentAiCount =
          _messages
              .where(
                (message) =>
            message.isAi,
          )
              .length;

      debugPrint(
        'AI BEFORE = $_aiMessagesBeforeSend',
      );

      debugPrint(
        'AI CURRENT = $currentAiCount',
      );

      if (currentAiCount >
          _aiMessagesBeforeSend) {
        debugPrint(
          'NEW AI MESSAGE FOUND',
        );

        stopPolling();

        _isWaitingForAi = false;

        notifyListeners();

        return;
      }

      notifyListeners();
    } catch (e) {
      debugPrint(
        'POLLING ERROR = $e',
      );
    } finally {
      _isCheckingPoll = false;
    }
  }

  // =============================================================
  // Load View
  // =============================================================

  Future<void> _loadChatFromView({
    bool notify = true,
  }) async {
    if (_videoId == null) {
      throw Exception(
        'Video id not found',
      );
    }

    final token =
    await _getToken();

    final result =
    await _viewChatService
        .getChat(
      token: token,
      videoId: _videoId!,
    );

    _chat =
        result;

    _readChatMessages(
      result,
    );

    if (notify) {
      notifyListeners();
    }
  }

  // =============================================================
  // Read Messages
  // =============================================================

  void _readChatMessages(
      ViewChatModel model,
      ) {
    try {
      final dynamic
      dynamicModel =
          model;

      final dynamic json =
      dynamicModel.toJson();

      if (json is! Map) {
        return;
      }

      final rawMessages =
      _findMessages(
        json,
      );

      if (rawMessages == null) {
        return;
      }

      final List<ChatLogicMessage>
      newMessages = [];

      for (final item
      in rawMessages) {
        if (item is! Map) {
          continue;
        }

        final text =
        _findMessageText(
          item,
        );

        if (text == null ||
            text
                .trim()
                .isEmpty) {
          continue;
        }

        final sender =
        _findSender(
          item,
        );

        newMessages.add(
          ChatLogicMessage(
            type:
            _normalizeSender(
              sender,
            ),
            text:
            text.trim(),
          ),
        );
      }

      _messages
        ..clear()
        ..addAll(
          newMessages,
        );

      debugPrint(
        'MESSAGES LOADED = ${_messages.length}',
      );
    } catch (e) {
      debugPrint(
        'READ CHAT ERROR = $e',
      );
    }
  }

  // =============================================================
  // Find Messages
  // =============================================================

  List<dynamic>? _findMessages(
      Map<dynamic, dynamic> json,
      ) {
    final messages =
    json['messages'];

    if (messages is List) {
      return messages;
    }

    final chat =
    json['chat'];

    if (chat is Map) {
      final chatMessages =
      chat['messages'];

      if (chatMessages is List) {
        return chatMessages;
      }
    }

    final data =
    json['data'];

    if (data is Map) {
      return _findMessages(
        data,
      );
    }

    return null;
  }

  // =============================================================
  // Message Text
  // =============================================================

  String? _findMessageText(
      Map<dynamic, dynamic> json,
      ) {
    final value =
        json['text'] ??
            json['content'] ??
            json['message'];

    return value?.toString();
  }

  // =============================================================
  // Sender
  // =============================================================

  String? _findSender(
      Map<dynamic, dynamic> json,
      ) {
    final value =
        json['sender'] ??
            json['role'] ??
            json['type'] ??
            json['message_type'];

    if (value is Map) {
      return (
          value['type'] ??
              value['role'] ??
              value['name']
      )
          ?.toString();
    }

    return value?.toString();
  }

  // =============================================================
  // Normalize Sender
  // =============================================================

  String _normalizeSender(
      String? sender,
      ) {
    final value =
    sender
        ?.toLowerCase()
        .trim();

    if (value == 'user' ||
        value == 'student' ||
        value == 'human') {
      return 'user';
    }

    return 'ai';
  }

  // =============================================================
  // Web response
  // =============================================================

  String? _extractWebResponse(
      SendWebSearchModel response,
      ) {
    try {
      final dynamic
      dynamicResponse =
          response;

      final dynamic json =
      dynamicResponse.toJson();

      if (json is! Map) {
        return null;
      }

      return _findWebAnswer(
        json,
      );
    } catch (e) {
      debugPrint(
        'WEB RESPONSE ERROR = $e',
      );

      return null;
    }
  }

  String? _findWebAnswer(
      Map<dynamic, dynamic> json,
      ) {
    final direct =
        json['answer'] ??
            json['response'] ??
            json['ai_response'] ??
            json['aiResponse'] ??
            json['result'] ??
            json['content'];

    if (direct is String &&
        direct
            .trim()
            .isNotEmpty) {
      return direct;
    }

    if (direct is Map) {
      final nested =
      _findWebAnswer(
        direct,
      );

      if (nested != null) {
        return nested;
      }
    }

    final data =
    json['data'];

    if (data is Map) {
      final nested =
      _findWebAnswer(
        data,
      );

      if (nested != null) {
        return nested;
      }
    }

    final text =
    json['text'];

    if (text is String &&
        text
            .trim()
            .isNotEmpty) {
      return text;
    }

    return null;
  }

  // =============================================================
  // Error
  // =============================================================

  void clearError() {
    _errorMessage = null;

    notifyListeners();
  }

  // =============================================================
  // Stop Polling
  // =============================================================

  void stopPolling({
    bool keepWaitingState = false,
  }) {
    _pollingTimer?.cancel();

    _pollingTimer = null;

    _isPolling = false;

    _isCheckingPoll = false;

    if (!keepWaitingState) {
      _isWaitingForAi = false;
    }
  }

  // =============================================================
  // Reset
  // =============================================================

  void reset() {
    stopPolling();

    _chat = null;

    _chatId = null;

    _videoId = null;

    _messages.clear();

    _isSending = false;

    _isWaitingForAi = false;

    _isPolling = false;

    _isCheckingPoll = false;

    _errorMessage = null;

    _webSearch = false;

    _aiMessagesBeforeSend = 0;

    notifyListeners();
  }

  @override
  void dispose() {
    stopPolling();

    super.dispose();
  }
}