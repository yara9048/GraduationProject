import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/display_playlists_model.dart';
import 'package:graduationprojct/features/home/data/models/subscriptions_model.dart';
import 'package:graduationprojct/features/home/data/services/subscriptions_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/data/models/profile_model.dart';
import '../data/services/display_playlists_service.dart';
import '../../auth/data/services/profile_service.dart';

class SubscriptionsProvider with ChangeNotifier {
  final SubscriptionsService _service = SubscriptionsService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;


  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  List<SubscriptionModel> _subscriptions = [];
  List<SubscriptionModel> get subscriptions => _subscriptions;


  Future<void> getSubscriptions() async {
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
      _subscriptions = await _service.getSubscription(token: token);

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
    _subscriptions = [];
    notifyListeners();
  }
}