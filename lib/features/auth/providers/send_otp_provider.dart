import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/auth/data/models/resend_otp_model.dart';
import 'package:graduationprojct/features/auth/data/services/resend_otp_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/send_otp_model.dart';
import '../data/models/sign_in_model.dart';
import '../data/services/send_otp_service.dart';
import '../data/services/sign_in_service.dart';

class SendOtpProvider with ChangeNotifier {
  final SendOtpService _service = SendOtpService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<void> sendotp({ required String email,  required String code}) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      SendOtpModel user = await _service.sendOtp(
        email: email, code: code,
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
