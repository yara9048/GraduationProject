import 'package:flutter/material.dart';

import 'playlist_details_provider.dart';
import 'rating_playlist_provider.dart';
import 'subscribe_provider.dart';

class FunctionsForPlaylistDetailsProvider with ChangeNotifier {
  bool _subscriptionChanged = false;

  bool get subscriptionChanged => _subscriptionChanged;

  void reset() {
    _subscriptionChanged = false;
    notifyListeners();
  }

  Future<void> loadDetails({
    required int id,
    required PlaylistDetailsProvider detailsProvider,
  }) async {
    await detailsProvider.getDetails(
      id: id,
      forceRefresh: true,
    );
  }

  Future<bool> subscribe({
    required int id,
    required SubscribeProvider subscribeProvider,
    required PlaylistDetailsProvider detailsProvider,
  }) async {
    await subscribeProvider.subscribe(id: id);

    if (!subscribeProvider.isSuccess) {
      return false;
    }

    detailsProvider.markAsSubscribed();
    _subscriptionChanged = true;
    notifyListeners();

    await detailsProvider.refreshDetails(id: id);

    return true;
  }

  Future<bool> submitRating({
    required int id,
    required int rating,
    required RatingPlaylistProvider ratingProvider,
    required PlaylistDetailsProvider detailsProvider,
  }) async {
    await ratingProvider.rate(
      id: id,
      review: '',
      rating: rating,
    );

    if (!ratingProvider.isSuccess) {
      return false;
    }

    detailsProvider.setUserRating(rating);

    await detailsProvider.refreshDetails(id: id);

    return true;
  }

  String? ratingValidationMessage(
      PlaylistDetailsProvider detailsProvider,
      ) {
    if (!detailsProvider.isSubscribed) {
      return 'يجب الاشتراك أولاً حتى تتمكن من التقييم';
    }

    if (detailsProvider.alreadyRated) {
      return 'لقد قمت بتقييم قائمة التشغيل مسبقاً';
    }

    return null;
  }
}
