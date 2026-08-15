import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/funding_request_model.dart';
import 'package:graduationprojct/features/home/data/models/rating_playlist_model.dart';
import 'package:graduationprojct/features/home/data/models/refund_request_model.dart';
import 'package:graduationprojct/features/home/data/models/web_search_model.dart';
import 'package:graduationprojct/features/home/data/services/funding_request_service.dart';
import 'package:graduationprojct/features/home/data/services/rating_playlist_service.dart';
import 'package:graduationprojct/features/home/data/services/refund_request_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/add_video_to_fav_model.dart';
import '../data/services/add_video_to_fav_service.dart';
import '../data/services/web_search_service.dart';

class WebSearchProvider with ChangeNotifier {
  final WebSearchService _service = WebSearchService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  WebSearchModel? _answer;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;
  WebSearchModel? get answer => _answer;

  Future<void> webSearch({
    required String question,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    _answer = null;
    notifyListeners();

    try {
      _answer = await _service.webSearch(
        question: question,

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
    _answer = null;
    notifyListeners();
  }
}