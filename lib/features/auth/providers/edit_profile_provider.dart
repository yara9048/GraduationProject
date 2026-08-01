import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/auth/data/models/edit_profile_model.dart';
import 'package:graduationprojct/features/auth/data/services/edit_profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileProvider with ChangeNotifier {
  final EditProfileService _service = EditProfileService();

  bool _isLoading = false;
  bool _isSuccess = false;
  bool _isPickingImage = false;

  String? _errorMessage;
  String? _selectedImageName;

  File? _selectedImage;
  EditProfileModel? _updatedProfile;

  bool get isLoading => _isLoading;

  bool get isSuccess => _isSuccess;

  bool get isPickingImage => _isPickingImage;

  String? get errorMessage => _errorMessage;

  String? get selectedImageName => _selectedImageName;

  File? get selectedImage => _selectedImage;

  EditProfileModel? get updatedProfile => _updatedProfile;

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

      final File imageFile = File(
        pickedFile.path!,
      );

      final bool exists = await imageFile.exists();

      if (!exists) {
        _errorMessage = 'ملف الصورة غير موجود';
        return;
      }

      final int imageSize = await imageFile.length();

      const int maximumImageSize =
          5 * 1024 * 1024;

      if (imageSize > maximumImageSize) {
        _errorMessage =
        'حجم الصورة يجب ألا يتجاوز 5 ميغابايت';
        return;
      }

      _selectedImage = imageFile;
      _selectedImageName = pickedFile.name;
    } catch (e) {
      _errorMessage =
      'حدث خطأ أثناء اختيار الصورة';
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

  Future<void> editProfile({
    String? firstName,
    String? secondName,
    String? major,
    bool sendSelectedImage = false,
  }) async {
    if (firstName == null &&
        secondName == null &&
        major == null &&
        !sendSelectedImage) {
      _errorMessage = 'لا توجد بيانات لتعديلها';
      _isSuccess = false;
      notifyListeners();
      return;
    }

    if (sendSelectedImage &&
        _selectedImage == null) {
      _errorMessage = 'يرجى اختيار صورة شخصية';
      _isSuccess = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    _updatedProfile = null;
    notifyListeners();

    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final String? token =
      prefs.getString('auth_token');

      if (token == null ||
          token.trim().isEmpty) {
        throw Exception(
          'Authentication token not found',
        );
      }

      final EditProfileModel user =
      await _service.editProfile(
        firstName: _cleanNullableValue(firstName),
        secondName:
        _cleanNullableValue(secondName),
        major: _cleanNullableValue(major),
        image: sendSelectedImage
            ? _selectedImage
            : null,
        token: token,
      );

      _updatedProfile = user;
      _isSuccess = true;

      if (sendSelectedImage) {
        _selectedImage = null;
        _selectedImageName = null;
      }
    } catch (e) {
      _isSuccess = false;
      _errorMessage = _cleanErrorMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editName({
    required String firstName,
    required String secondName,
  }) async {
    if (firstName.trim().isEmpty) {
      _errorMessage = 'الاسم مطلوب';
      _isSuccess = false;
      notifyListeners();
      return;
    }

    if (secondName.trim().isEmpty) {
      _errorMessage = 'الكنية مطلوبة';
      _isSuccess = false;
      notifyListeners();
      return;
    }

    await editProfile(
      firstName: firstName,
      secondName: secondName,
    );
  }

  Future<void> editMajor({
    required String major,
  }) async {
    if (major.trim().isEmpty) {
      _errorMessage = 'الاختصاص مطلوب';
      _isSuccess = false;
      notifyListeners();
      return;
    }

    await editProfile(
      major: major,
    );
  }

  Future<void> editImage() async {
    if (_selectedImage == null) {
      _errorMessage = 'يرجى اختيار صورة شخصية';
      _isSuccess = false;
      notifyListeners();
      return;
    }

    await editProfile(
      sendSelectedImage: true,
    );
  }

  String? _cleanNullableValue(
      String? value,
      ) {
    if (value == null) {
      return null;
    }

    final String cleanedValue = value.trim();

    if (cleanedValue.isEmpty) {
      return null;
    }

    return cleanedValue;
  }

  String _cleanErrorMessage(
      dynamic error,
      ) {
    String message = error.toString();

    if (message.startsWith('Exception: ')) {
      message = message.replaceFirst(
        'Exception: ',
        '',
      );
    }

    return message;
  }

  void resetEditStatus() {
    _isLoading = false;
    _errorMessage = null;
    _isSuccess = false;
    _updatedProfile = null;

    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _isSuccess = false;
    _isPickingImage = false;

    _errorMessage = null;
    _selectedImageName = null;

    _selectedImage = null;
    _updatedProfile = null;

    notifyListeners();
  }
}