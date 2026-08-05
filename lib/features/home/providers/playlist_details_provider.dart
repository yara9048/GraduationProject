import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/data/models/playlist_details_model.dart';
import 'package:graduationprojct/features/home/data/services/playlist_details_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlaylistDetailsProvider with ChangeNotifier {
  final PlayListDetailsService _service =
  PlayListDetailsService();

  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;

  PlayListDetailsModel? _playListDetails;
  int? _loadedPlaylistId;

  bool _isSubscribed = false;
  double? _selectedRating;

  bool get isLoading => _isLoading;

  bool get isSuccess => _isSuccess;

  String? get errorMessage => _errorMessage;

  PlayListDetailsModel? get playListDetails =>
      _playListDetails;

  int? get loadedPlaylistId => _loadedPlaylistId;

  bool get isSubscribed => _isSubscribed;

  double? get selectedRating => _selectedRating;

  bool get alreadyRated =>
      _selectedRating != null &&
          _selectedRating! > 0;

  bool get canRate =>
      _isSubscribed && !alreadyRated;

  bool get canOpenVideos => _isSubscribed;

  Future<void> getDetails({
    required int id,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh &&
        _loadedPlaylistId == id &&
        _playListDetails != null) {
      return;
    }

    _isLoading = true;
    _isSuccess = false;
    _errorMessage = null;

    if (_loadedPlaylistId != id) {
      _playListDetails = null;
      _loadedPlaylistId = null;
      _isSubscribed = false;
      _selectedRating = null;
    }

    notifyListeners();

    try {
      final prefs =
      await SharedPreferences.getInstance();

      final token =
      prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        throw Exception(
          'Authentication token not found',
        );
      }

      final response =
      await _service.getDetails(
        token: token,
        id: id,
      );

      _playListDetails = response;
      _loadedPlaylistId = id;

      _syncLocalValues(response);

      _isSuccess = true;
      _errorMessage = null;

      debugPrint(
        'Playlist details loaded: ${response.name}',
      );

      debugPrint(
        'Subscription: $_isSubscribed',
      );

      debugPrint(
        'User rating: $_selectedRating',
      );
    } catch (e, stackTrace) {
      _errorMessage =
          _cleanErrorMessage(e.toString());

      _isSuccess = false;
      _playListDetails = null;
      _loadedPlaylistId = null;
      _isSubscribed = false;
      _selectedRating = null;

      debugPrint(
        'Playlist details error for ID $id: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshDetails({
    required int id,
  }) async {
    await getDetails(
      id: id,
      forceRefresh: true,
    );
  }

  void markAsSubscribed() {
    _isSubscribed = true;
    notifyListeners();
  }

  void setUserRating(
      dynamic value,
      ) {
    _selectedRating =
        parseUserRating(value);

    notifyListeners();
  }

  void _syncLocalValues(
      PlayListDetailsModel course,
      ) {
    _isSubscribed =
        course.hasSubscription ||
            course.hasActiveSubscription ||
            course.canAccessContent;

    _selectedRating =
        parseUserRating(course.rating);
  }

  bool hasDetailsFor(
      int id,
      ) {
    return _loadedPlaylistId == id &&
        _playListDetails != null;
  }

  double? parseUserRating(
      dynamic value,
      ) {
    if (value == null) {
      return null;
    }

    double? rating;

    if (value is num) {
      rating = value.toDouble();
    } else {
      final text =
      value.toString().trim();

      if (text.isEmpty ||
          text.toUpperCase() == 'N/A' ||
          text.toLowerCase() == 'null') {
        return null;
      }

      rating =
          double.tryParse(text);
    }

    if (rating == null ||
        rating <= 0 ||
        rating > 5) {
      return null;
    }

    return rating;
  }

  String formatNumber(
      dynamic value,
      ) {
    if (value == null) {
      return '0';
    }

    final number = value is num
        ? value.toDouble()
        : double.tryParse(
      value.toString(),
    ) ??
        0.0;

    if (number ==
        number.roundToDouble()) {
      return number.toInt().toString();
    }

    return number.toStringAsFixed(1);
  }

  String formatDuration(
      dynamic value,
      ) {
    if (value == null) {
      return 'غير محددة';
    }

    final duration = value is num
        ? value.toDouble()
        : double.tryParse(
      value.toString(),
    );

    if (duration == null) {
      return 'غير محددة';
    }

    return '${formatNumber(duration)} دقيقة';
  }

  String formatPrice(
      dynamic value,
      ) {
    if (value == null) {
      return '0';
    }

    final price = value is num
        ? value.toDouble()
        : double.tryParse(
      value.toString(),
    );

    if (price == null) {
      return value.toString();
    }

    if (price ==
        price.roundToDouble()) {
      return price.toInt().toString();
    }

    return price.toStringAsFixed(2);
  }

  String get formattedRating {
    if (_selectedRating == null) {
      return 'لم تقيّم';
    }

    return '${formatNumber(_selectedRating)}/5';
  }

  void reset() {
    _isLoading = false;
    _isSuccess = false;
    _errorMessage = null;
    _playListDetails = null;
    _loadedPlaylistId = null;
    _isSubscribed = false;
    _selectedRating = null;

    notifyListeners();
  }

  String _cleanErrorMessage(
      String error,
      ) {
    return error
        .replaceFirst(
      'Exception:',
      '',
    )
        .replaceFirst(
      'DioException:',
      '',
    )
        .replaceAll(
      RegExp(r'\s+'),
      ' ',
    )
        .trim();
  }
}