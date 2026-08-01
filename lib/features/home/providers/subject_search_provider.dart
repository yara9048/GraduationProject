import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/services/display_subjects_service.dart';
import 'package:graduationprojct/features/home/data/services/now_showing_playlists_service.dart';
import 'package:graduationprojct/features/home/data/services/subject_search_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/display_subjects_model.dart';
import '../data/models/now_showing_playlist_model.dart';

class SubjectSearchProvider with ChangeNotifier {
  final SubjectSearchService _service =
  SubjectSearchService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  List<DisplaySubjectsModel> _subjects = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  List<DisplaySubjectsModel> get subjects => _subjects;

  bool get hasSubjects => _subjects.isNotEmpty;

  Future<void> subjectSearch({required String query}) async {
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

      _subjects = await _service.subjectSearch(token, query);

      _isSuccess = true;
    } catch (e) {
      _subjects = [];
      _errorMessage = e.toString();
      _isSuccess = false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetSearch() {
    _subjects.clear();
    _errorMessage = null;
    _isLoading = false;
    _isSuccess = false;
    notifyListeners();
  }
}