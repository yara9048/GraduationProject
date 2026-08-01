import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FirebaseMessagingService {
  FirebaseMessagingService._();

  static final FirebaseMessagingService instance =
  FirebaseMessagingService._();

  final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  StreamSubscription<String>? _tokenSubscription;
  StreamSubscription<RemoteMessage>? _messageSubscription;
  StreamSubscription<RemoteMessage>? _openedSubscription;

  Future<void> initialize() async {
    final NotificationSettings settings =
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    debugPrint(
      'Notification permission: '
          '${settings.authorizationStatus}',
    );

    if (settings.authorizationStatus ==
        AuthorizationStatus.denied ||
        settings.authorizationStatus ==
            AuthorizationStatus.notDetermined) {
      debugPrint(
        'Notification permission was not granted.',
      );
      return;
    }

    final String? token =
    await _messaging.getToken();

    debugPrint('FCM Token: $token');

    if (token != null && token.isNotEmpty) {
      await _sendTokenToBackend(token);
    }

    _tokenSubscription =
        _messaging.onTokenRefresh.listen(
              (String newToken) async {
            debugPrint('New FCM Token: $newToken');

            await _sendTokenToBackend(newToken);
          },
          onError: (Object error) {
            debugPrint(
              'FCM token refresh error: $error',
            );
          },
        );

    _messageSubscription =
        FirebaseMessaging.onMessage.listen(
              (RemoteMessage message) {
            debugPrint(
              'Foreground message: '
                  '${message.messageId}',
            );

            debugPrint(
              'Title: '
                  '${message.notification?.title}',
            );

            debugPrint(
              'Body: '
                  '${message.notification?.body}',
            );

            debugPrint(
              'Data: ${message.data}',
            );

            // هون لاحقًا منعرض local notification
            // إذا بدك يظهر إشعار والتطبيق مفتوح.
          },
        );

    _openedSubscription =
        FirebaseMessaging.onMessageOpenedApp.listen(
          _handleNotificationOpened,
        );

    final RemoteMessage? initialMessage =
    await _messaging.getInitialMessage();

    if (initialMessage != null) {
      _handleNotificationOpened(
        initialMessage,
      );
    }
  }

  void _handleNotificationOpened(
      RemoteMessage message,
      ) {
    debugPrint(
      'Notification opened: '
          '${message.data}',
    );

    // مثال:
    // final String? type = message.data['type'];
    // final String? id = message.data['id'];
    //
    // هون منعمل navigation حسب type و id.
  }

  Future<void> _sendTokenToBackend(
      String token,
      ) async {
    debugPrint(
      'Send token to backend: $token',
    );
  }

  Future<void> dispose() async {
    await _tokenSubscription?.cancel();
    await _messageSubscription?.cancel();
    await _openedSubscription?.cancel();
  }
}