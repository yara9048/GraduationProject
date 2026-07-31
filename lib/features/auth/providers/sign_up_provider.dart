import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/auth/data/models/sign_up_model.dart';
import 'package:graduationprojct/features/auth/data/services/sign_up_service.dart';

class SignUpProvider with ChangeNotifier {
  final SignUpService _service = SignUpService();

  bool _isLoading = false;
  bool _isSuccess = false;
  bool _isPickingImage = false;

  String? _errorMessage;
  String? _selectedImageName;

  File? _selectedImage;
  SignUpModel? _registeredUser;

  bool get isLoading => _isLoading;

  bool get isSuccess => _isSuccess;

  bool get isPickingImage => _isPickingImage;

  String? get errorMessage => _errorMessage;

  String? get selectedImageName => _selectedImageName;

  File? get selectedImage => _selectedImage;

  SignUpModel? get registeredUser => _registeredUser;

  Future<void> pickImage() async {
    _isPickingImage = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final FilePickerResult? result =
      await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: false,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final PlatformFile pickedFile = result.files.single;

      if (pickedFile.path == null) {
        _errorMessage = 'تعذر قراءة مسار الصورة';
        return;
      }

      final File imageFile = File(pickedFile.path!);

      final bool exists = await imageFile.exists();

      if (!exists) {
        _errorMessage = 'ملف الصورة غير موجود';
        return;
      }

      final int imageSize = await imageFile.length();

      const int maximumImageSize = 5 * 1024 * 1024;

      if (imageSize > maximumImageSize) {
        _errorMessage = 'حجم الصورة يجب ألا يتجاوز 5 ميغابايت';
        return;
      }

      _selectedImage = imageFile;
      _selectedImageName = pickedFile.name;
    } catch (e) {
      _errorMessage = 'حدث خطأ أثناء اختيار الصورة';
    } finally {
      _isPickingImage = false;
      notifyListeners();
    }
  }

  void removeSelectedImage() {
    _selectedImage = null;
    _selectedImageName = null;
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> register({
    required String email,
    required String password1,
    required String password2,
    required String firstName,
    required String lastName,
    required String major,
  }) async {
    if (_selectedImage == null) {
      _errorMessage = 'يرجى اختيار صورة شخصية';
      _isSuccess = false;
      notifyListeners();
      return;
    }

    if (password1 != password2) {
      _errorMessage = 'كلمات المرور غير متطابقة';
      _isSuccess = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    _registeredUser = null;
    notifyListeners();

    try {
      final SignUpModel user = await _service.signUp(
        email: email.trim(),
        password1: password1,
        password2: password2,
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        major: major.trim(),
        image: _selectedImage!,
      );

      _registeredUser = user;
      _isSuccess = true;
    } catch (e) {
      _isSuccess = false;
      _errorMessage = _cleanErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _cleanErrorMessage(dynamic error) {
    String message = error.toString();

    if (message.startsWith('Exception: ')) {
      message = message.replaceFirst('Exception: ', '');
    }

    return message;
  }

  void resetRegistrationStatus() {
    _isLoading = false;
    _errorMessage = null;
    _isSuccess = false;
    _registeredUser = null;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _isSuccess = false;
    _isPickingImage = false;
    _errorMessage = null;
    _selectedImageName = null;
    _selectedImage = null;
    _registeredUser = null;
    notifyListeners();
  }
}