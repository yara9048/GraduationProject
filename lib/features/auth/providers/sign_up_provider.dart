import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/auth/data/models/sign_up_model.dart';
import 'package:graduationprojct/features/auth/data/services/sign_up_service.dart';

class SignUpProvider with ChangeNotifier {
  final SignUpService _service = SignUpService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  Future<void> register({required String email, required String password1, required String password2,required String firstName ,required String lastName}) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      SignUpModel user = await _service.signUp(
        email: email,
        password1: password1, firstName: firstName, lastName: lastName, password2: password2,

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
