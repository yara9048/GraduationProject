import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/auth/data/models/resend_otp_model.dart';
import 'package:graduationprojct/features/auth/data/models/reset_password_request_model.dart';
import 'package:graduationprojct/features/auth/data/services/resend_otp_service.dart';
import 'package:graduationprojct/features/auth/data/services/reset_password_request_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/sign_in_model.dart';
import '../data/services/sign_in_service.dart';

class ResetPasswordRequestProvider with ChangeNotifier {
  final ResetPasswordRequestService _service = ResetPasswordRequestService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<void> resetPasswordRequest({required String email}) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      ResetPasswordRequestModel user = await _service.resetPasswordRequest(
        email: email,
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();

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
