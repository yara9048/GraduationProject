import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/auth/data/models/new_password_model.dart';
import 'package:graduationprojct/features/auth/data/models/password_send_otp_model.dart';
import 'package:graduationprojct/features/auth/data/models/resend_otp_model.dart';
import 'package:graduationprojct/features/auth/data/services/new_password_service.dart';
import 'package:graduationprojct/features/auth/data/services/password_send_otp_service.dart';
import 'package:graduationprojct/features/auth/data/services/resend_otp_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/send_otp_model.dart';
import '../data/models/sign_in_model.dart';
import '../data/services/send_otp_service.dart';
import '../data/services/sign_in_service.dart';

class NewPasswordProvider with ChangeNotifier {
  final NewPasswordService _service = NewPasswordService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<void> newPassword({ required String email,  required String password1, required String password2}) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      NewPasswordModel user = await _service.newPassword(
        email: email, password1:password1,password2: password2
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
