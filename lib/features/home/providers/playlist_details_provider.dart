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

  Future<void> getDetails({required int id}) async {
    _isLoading = true;
    _errorMessage = null;
    _isSuccess = false;
    notifyListeners();

    try {

      _playListDetails = await _service.getDetails(id: id);

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
    _playListDetails = null;
    notifyListeners();
  }
}