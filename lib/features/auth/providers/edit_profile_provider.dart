import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/auth/data/models/edit_profile_model.dart';
import 'package:graduationprojct/features/auth/data/services/edit_profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileProvider with ChangeNotifier {
  final EditProfileService _service = EditProfileService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<void> editProfile({String? firstName, String? secondName, String? major}) async {
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

      EditProfileModel user = await _service.editProfile(
        firstName: firstName,secondName: secondName, major: major,token:  token
      );


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
    notifyListeners();
  }
}
