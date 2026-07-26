import 'package:flutter/material.dart';
import '../../auth/providers/profile_provider.dart';
import 'display_facourite_provider.dart';
import 'display_playlists_provider.dart';
import 'filtered_playlist_provider.dart';

class MainNavigationProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  Future<void> changeTab({
    required int index,
    required DisplayPlaylistsProvider displayPlaylistsProvider,
    required FilteredPlaylistProvider filteredPlaylistProvider,
    required DisplayFavouriteProvider displayFavouriteProvider,
    required ProfileProvider profileProvider,
  }) async {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }

    await refreshSelectedPage(
      index: index,
      displayPlaylistsProvider: displayPlaylistsProvider,
      filteredPlaylistProvider: filteredPlaylistProvider,
      displayFavouriteProvider: displayFavouriteProvider,
      profileProvider: profileProvider,
    );
  }

  Future<void> refreshSelectedPage({
    required int index,
    required DisplayPlaylistsProvider displayPlaylistsProvider,
    required FilteredPlaylistProvider filteredPlaylistProvider,
    required DisplayFavouriteProvider displayFavouriteProvider,
    required ProfileProvider profileProvider,
  }) async {
    switch (index) {
      case 0:
        await Future.wait([
          displayPlaylistsProvider.getPlayLists(),
          filteredPlaylistProvider.getFilteredPlaylists(),
        ]);
        break;

      case 1:
        await displayPlaylistsProvider.getPlayLists();
        break;

      case 2:
        await displayFavouriteProvider.getFavourites();
        break;

      case 3:
        break;

      case 4:
        await profileProvider.getProfile();
        break;
    }
  }

  void setCurrentIndex(int index) {
    if (_currentIndex == index) return;

    _currentIndex = index;
    notifyListeners();
  }

  void reset() {
    _currentIndex = 0;
    notifyListeners();
  }
}