import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/profile_model.dart';
import '../data/services/profile_service.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileService _service = ProfileService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  ProfileModel? _profile;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get isSuccess => _isSuccess;

  ProfileModel? get profile => _profile;

  bool get hasProfile => _profile != null;


  Future<void> getProfile() async {
    if (_isLoading) {
      return;
    }

    _setLoading(true);

    try {
      final prefs =
      await SharedPreferences.getInstance();

      final String? token =
      prefs.getString(
        'auth_token',
      );

      if (token == null ||
          token.trim().isEmpty) {
        throw Exception(
          'Authentication token not found',
        );
      }

      final ProfileModel result =
      await _service.getProfile(
        token,
      );

      _profile = result;

      _isSuccess = true;
      _errorMessage = null;
    } catch (e) {
      _isSuccess = false;

      _errorMessage =
          _cleanError(
            e,
          );
    } finally {
      _setLoading(false);
    }
  }


  Future<void> refreshProfile() async {
    await getProfile();
  }

  void _setLoading(
      bool value,
      ) {
    _isLoading = value;

    if (value) {
      _errorMessage = null;
      _isSuccess = false;
    }

    notifyListeners();
  }


  String _cleanError(
      Object error,
      ) {
    return error
        .toString()
        .replaceFirst(
      'Exception: ',
      '',
    )
        .trim();
  }


  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _isSuccess = false;
    _profile = null;

    notifyListeners();
  }
}