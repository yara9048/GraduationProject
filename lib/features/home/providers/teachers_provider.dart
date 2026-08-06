import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/teacher_model.dart';
import 'package:graduationprojct/features/home/data/services/display_subjects_service.dart';
import 'package:graduationprojct/features/home/data/services/now_showing_playlists_service.dart';
import 'package:graduationprojct/features/home/data/services/teachers_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/display_subjects_model.dart';
import '../data/models/now_showing_playlist_model.dart';

class TeachersProvider with ChangeNotifier {
  final TeachersServices _service =
  TeachersServices();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  List<TeacherModel> _teachers = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  List<TeacherModel> get teachers => _teachers;

  bool get hasTeachers => _teachers.isNotEmpty;

  Future<void> getTeachers({required int subjectId}) async {
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

      _teachers = await _service.getTeachers(token: token, id: subjectId);

      _isSuccess = true;
    } catch (e) {
      _teachers = [];
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
    _teachers = [];

    notifyListeners();
  }
}