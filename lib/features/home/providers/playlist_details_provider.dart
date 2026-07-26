import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:graduationprojct/features/home/data/models/playlist_details_model.dart';
import 'package:graduationprojct/features/home/data/models/video_details_model.dart';
import 'package:graduationprojct/features/home/data/services/play_list_details_service.dart';
import 'package:graduationprojct/features/home/data/services/video_details_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PlaylistDetailsProvider with ChangeNotifier {
  final PlayListDetailsService _service = PlayListDetailsService();

  bool _isLoading = false;
  String? _errorMessage;
  bool _isSuccess = false;

  PlayListDetailsModel? _playListDetails;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isSuccess => _isSuccess;

  PlayListDetailsModel? get playListDetails => _playListDetails;

  Future<void> getDetails({
    required int id,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {
      debugPrint('Getting playlist details for ID: $id');

      _playListDetails = await _service.getDetails(
        id: id,
      );

      debugPrint(
        'Playlist loaded: ${_playListDetails?.name}',
      );

      _isSuccess = true;
    } catch (e, stackTrace) {
      _errorMessage = e.toString();

      debugPrint(
        'Playlist details error: $e',
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _isLoading = false;
    _errorMessage = null;
    _isSuccess = false;
    _playListDetails = null;
    notifyListeners();
  }
}