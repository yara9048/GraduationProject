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

  bool get isUser => type == 'user';
  bool get isAi => !isUser;
}

class VideoSegment {
  final double startSeconds;
  final double endSeconds;
  final String startLabel;
  final String endLabel;

  const VideoSegment({
    required this.startSeconds,
    required this.endSeconds,
    required this.startLabel,
    required this.endLabel,
  });
}

class ParsedAiMessage {
  final String answer;
  final List<VideoSegment> segments;

  const ParsedAiMessage({
    required this.answer,
    required this.segments,
  });
}

class ChatLogicProvider extends ChangeNotifier {
  final ViewChatService _viewChatService = ViewChatService();
  final SendRagMessageService _ragService = SendRagMessageService();
  final SendWebSearchMessageService _webService =
  SendWebSearchMessageService();

  ViewChatModel? _chat;
  ViewChatModel? get chat => _chat;

  int? _chatId;
  int? get chatId => _chatId;

  int? _videoId;
  int? get videoId => _videoId;

  final List<ChatLogicMessage> _messages = [];
  List<ChatLogicMessage> get messages =>
      List.unmodifiable(_messages);

  bool get hasMessages => _messages.isNotEmpty;

  bool _isSending = false;
  bool get isSending => _isSending;

  bool _isWaitingForAi = false;
  bool get isWaitingForAi => _isWaitingForAi;

  bool _isPolling = false;
  bool get isPolling => _isPolling;

  bool _isCheckingPoll = false;

  bool get canSend =>
      !_isSending && !_isWaitingForAi;

  bool _webSearch = false;
  bool get webSearch => _webSearch;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Timer? _pollingTimer;
  int _aiMessagesBeforeSend = 0;

  Future<String> _getToken() async {
    final prefs =
    await SharedPreferences.getInstance();

    final token =
    prefs.getString('auth_token');

    if (token == null ||
        token.trim().isEmpty) {
      throw Exception(
        'Authentication token not found',
      );
    }

    return token;
  }

  void initialize({
    required int videoId,
    required int chatId,
    required ViewChatModel initialChat,
  }) {
    stopPolling();

    _videoId = videoId;
    _chatId = chatId;
    _chat = initialChat;

    _messages.clear();
    _readChatMessages(initialChat);

    _isSending = false;
    _isWaitingForAi = false;
    _isPolling = false;
    _isCheckingPoll = false;
    _errorMessage = null;
    _webSearch = false;
    _aiMessagesBeforeSend = 0;

    notifyListeners();
  }

  void toggleWebSearch() {
    if (!canSend) {
      return;
    }

    _webSearch = !_webSearch;
    notifyListeners();
  }

  void setWebSearch(bool value) {
    if (!canSend) {
      return;
    }

    _webSearch = value;
    notifyListeners();
  }

  Future<void> sendMessage({
    required String text,
  }) async {
    final cleanText = text.trim();

    if (cleanText.isEmpty ||
        !canSend) {
      return;
    }

    if (_chatId == null) {
      _setError('Chat ID غير موجود');
      return;
    }

    if (_videoId == null) {
      _setError('Video ID غير موجود');
      return;
    }

    _errorMessage = null;

    if (_webSearch) {
      await _sendWebMessage(cleanText);
    } else {
      await _sendRagMessage(cleanText);
    }
  }

  Future<void> _sendRagMessage(
      String text,
      ) async {
    _isSending = true;
    _errorMessage = null;

    _aiMessagesBeforeSend =
        _messages
            .where((message) => message.isAi)
            .length;

    _messages.add(
      ChatLogicMessage(
        type: 'user',
        text: text,
      ),
    );

    notifyListeners();

    try {
      final token = await _getToken();

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
      _setError(e.toString());
    }
  }

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
      final token = await _getToken();

      final SendWebSearchModel response =
      await _webService.sendWeb(
        token: token,
        text: text,
        chatId: _chatId!,
      );

      final aiText =
      _extractWebResponse(response);

      if (aiText != null &&
          aiText.trim().isNotEmpty) {
        _messages.add(
          ChatLogicMessage(
            type: 'ai',
            text: aiText.trim(),
          ),
        );
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }

  ParsedAiMessage parseAiMessage(
      String text,
      ) {
    final cleanText = text.trim();

    if (!cleanText.contains('ANSWER:')) {
      return ParsedAiMessage(
        answer: cleanText,
        segments: const [],
      );
    }

    String answer = cleanText;

    final answerRegex = RegExp(
      r'ANSWER:\s*(.*?)(?=\s*QUESTION TYPE:|\s*PRECISE TIMESTAMPS:|\s*Context words:|$)',
      dotAll: true,
    );

    final answerMatch =
    answerRegex.firstMatch(cleanText);

    if (answerMatch != null) {
      answer =
          answerMatch.group(1)?.trim() ??
              cleanText;
    }

    final List<VideoSegment> segments = [];

    final timestampRegex = RegExp(
      r'\[(\d{1,3}):(\d{2}(?:\.\d+)?)\s*-->\s*(\d{1,3}):(\d{2}(?:\.\d+)?)\]',
    );

    for (final match
    in timestampRegex.allMatches(cleanText)) {
      final int startMinutes =
          int.tryParse(match.group(1) ?? '0') ??
              0;

      final double startSecondsPart =
          double.tryParse(match.group(2) ?? '0') ??
              0;

      final int endMinutes =
          int.tryParse(match.group(3) ?? '0') ??
              0;

      final double endSecondsPart =
          double.tryParse(match.group(4) ?? '0') ??
              0;

      final double startSeconds =
          (startMinutes * 60) +
              startSecondsPart;

      final double endSeconds =
          (endMinutes * 60) +
              endSecondsPart;

      segments.add(
        VideoSegment(
          startSeconds: startSeconds,
          endSeconds: endSeconds,
          startLabel:
          _formatTimestampLabel(
            startMinutes,
            startSecondsPart,
          ),
          endLabel:
          _formatTimestampLabel(
            endMinutes,
            endSecondsPart,
          ),
        ),
      );
    }

    return ParsedAiMessage(
      answer: answer,
      segments: segments,
    );
  }

  String _formatTimestampLabel(
      int minutes,
      double seconds,
      ) {
    final int secondValue =
    seconds.floor();

    return '${minutes.toString().padLeft(2, '0')}:'
        '${secondValue.toString().padLeft(2, '0')}';
  }

  void _startPolling() {
    stopPolling(
      keepWaitingState: true,
    );

    _isPolling = true;
    _isWaitingForAi = true;

    notifyListeners();

    _pollingTimer = Timer.periodic(
      const Duration(seconds: 3),
          (_) async {
        await _checkForNewAiMessage();
      },
    );
  }

  Future<void> _checkForNewAiMessage() async {
    if (!_isPolling ||
        _isCheckingPoll) {
      return;
    }

    _isCheckingPoll = true;

    try {
      await _loadChatFromView(
        notify: false,
      );

      final currentAiCount =
          _messages
              .where((message) => message.isAi)
              .length;

      if (currentAiCount >
          _aiMessagesBeforeSend) {
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

  Future<void> _loadChatFromView({
    bool notify = true,
  }) async {
    if (_videoId == null) {
      throw Exception(
        'Video id not found',
      );
    }

    final token = await _getToken();

    final result =
    await _viewChatService.getChat(
      token: token,
      videoId: _videoId!,
    );

    _chat = result;

    _readChatMessages(result);

    if (notify) {
      notifyListeners();
    }
  }

  void _readChatMessages(
      ViewChatModel model,
      ) {
    try {
      final dynamic dynamicModel = model;
      final dynamic json =
      dynamicModel.toJson();

      if (json is! Map) {
        return;
      }

      final rawMessages =
      _findMessages(json);

      if (rawMessages == null) {
        return;
      }

      final List<ChatLogicMessage>
      newMessages = [];

      for (final item in rawMessages) {
        if (item is! Map) {
          continue;
        }

        final text =
        _findMessageText(item);

        if (text == null ||
            text.trim().isEmpty) {
          continue;
        }

        final sender =
        _findSender(item);

        newMessages.add(
          ChatLogicMessage(
            type:
            _normalizeSender(sender),
            text: text.trim(),
          ),
        );
      }

      _messages
        ..clear()
        ..addAll(newMessages);
    } catch (e) {
      debugPrint(
        'READ CHAT ERROR = $e',
      );
    }
  }

  List<dynamic>? _findMessages(
      Map<dynamic, dynamic> json,
      ) {
    final messages = json['messages'];

    if (messages is List) {
      return messages;
    }

    final chat = json['chat'];

    if (chat is Map) {
      final chatMessages =
      chat['messages'];

      if (chatMessages is List) {
        return chatMessages;
      }
    }

    final data = json['data'];

    if (data is Map) {
      return _findMessages(data);
    }

    return null;
  }

  String? _findMessageText(
      Map<dynamic, dynamic> json,
      ) {
    final value =
        json['text'] ??
            json['content'] ??
            json['message'];

    return value?.toString();
  }

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

  String _normalizeSender(
      String? sender,
      ) {
    final value =
    sender?.toLowerCase().trim();

    if (value == 'user' ||
        value == 'student' ||
        value == 'human') {
      return 'user';
    }

    return 'ai';
  }

  String? _extractWebResponse(
      SendWebSearchModel response,
      ) {
    try {
      final dynamic dynamicResponse =
          response;

      final dynamic json =
      dynamicResponse.toJson();

      if (json is! Map) {
        return null;
      }

      return _findWebAnswer(json);
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
        direct.trim().isNotEmpty) {
      return direct;
    }

    if (direct is Map) {
      final nested =
      _findWebAnswer(direct);

      if (nested != null) {
        return nested;
      }
    }

    final data = json['data'];

    if (data is Map) {
      final nested =
      _findWebAnswer(data);

      if (nested != null) {
        return nested;
      }
    }

    final text = json['text'];

    if (text is String &&
        text.trim().isNotEmpty) {
      return text;
    }

    return null;
  }

  void _setError(
      String message,
      ) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

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
