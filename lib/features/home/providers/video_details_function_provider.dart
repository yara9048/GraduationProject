import 'package:flutter/material.dart';

class VideoDetailsProvider with ChangeNotifier {
  double _watchProgress = 0.0;

  double get watchProgress => _watchProgress;

  bool get isCompleted => _watchProgress >= 1.0;

  void updateProgress(double progress) {
    if (progress != _watchProgress) {
      _watchProgress = progress;
      notifyListeners();
    }
  }

  bool canAccessFeatures() {
    return isCompleted;
  }

  void reset() {
    _watchProgress = 0.0;
    notifyListeners();
  }
}