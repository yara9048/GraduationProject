import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/services/display_subjects_service.dart';
import 'package:graduationprojct/features/home/data/services/now_showing_playlists_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/display_subjects_model.dart';
import '../data/models/now_showing_playlist_model.dart';

class DisplaySubjectsProvider with ChangeNotifier {
  final DisplaySubjectsService _service =
  DisplaySubjectsService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  List<DisplaySubjectsModel> _subjects = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  List<DisplaySubjectsModel> get subjects => _subjects;

  bool get hasSubjects => _subjects.isNotEmpty;

  Future<void> getSubjects() async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;

    notifyListeners();

    try {
      final prefs =
      await SharedPreferences.getInstance();

      final token =
      prefs.getString("auth_token");

      final classId =
      prefs.getInt("class_id");

      if (token == null ||
          token.isEmpty ||
          classId == null) {
        throw Exception(
          "Authentication token or class id not found",
        );
      }
      _subjects = await _service.getSubjects(token: token, classId: classId);

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

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _isSuccess = false;
    _subjects = [];

    notifyListeners();
  }
}