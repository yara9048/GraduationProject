import 'package:flutter/material.dart';

import '../../auth/providers/profile_provider.dart';
import 'display_facourite_provider.dart';
import 'display_playlists_provider.dart';
import 'display_subjects_provider.dart';
import 'now_showing_playlist_provider.dart';
import 'playlist_by_class_provider.dart';
import 'wallet_provider.dart';
import 'wallet_transactions_provider.dart';

class MainNavigationProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  Future<void> changeTab({
    required int index,
    required DisplayPlaylistsProvider displayPlaylistsProvider,
    required PlaylistByClassProvider playlistByClassProvider,
    required DisplayFavouriteProvider displayFavouriteProvider,
    required ProfileProvider profileProvider,
    required NowShowingPlaylistProvider nowShowingPlaylistProvider,
    required DisplaySubjectsProvider displaySubjectsProvider,
    required WalletProvider walletProvider,
    required WalletTransactionsProvider walletTransactionsProvider,
  }) async {
    if (_currentIndex != index) {
      _currentIndex = index;
      notifyListeners();
    }

    await refreshSelectedPage(
      index: index,
      displayPlaylistsProvider: displayPlaylistsProvider,
      playlistByClassProvider: playlistByClassProvider,
      displayFavouriteProvider: displayFavouriteProvider,
      profileProvider: profileProvider,
      nowShowingPlaylistProvider: nowShowingPlaylistProvider,
      displaySubjectsProvider: displaySubjectsProvider,
      walletProvider: walletProvider,
      walletTransactionsProvider: walletTransactionsProvider,
    );
  }

  Future<void> refreshSelectedPage({
    required int index,
    required DisplayPlaylistsProvider displayPlaylistsProvider,
    required PlaylistByClassProvider playlistByClassProvider,
    required DisplayFavouriteProvider displayFavouriteProvider,
    required ProfileProvider profileProvider,
    required NowShowingPlaylistProvider nowShowingPlaylistProvider,
    required DisplaySubjectsProvider displaySubjectsProvider,
    required WalletProvider walletProvider,
    required WalletTransactionsProvider walletTransactionsProvider,
  }) async {
    switch (index) {
      case 0:
        playlistByClassProvider.reset();

        await Future.wait([
          playlistByClassProvider.getPlaylists(),
          nowShowingPlaylistProvider.getPlaylists(),
          displaySubjectsProvider.getSubjects(),
          displayPlaylistsProvider.getPlayLists(),
        ]);

        break;

      case 1:
        await displayPlaylistsProvider.getPlayLists();
        break;

      case 2:
        await displayFavouriteProvider.getFavourites();
        break;

      case 3:
        await Future.wait([
          walletProvider.getWallet(),
          walletTransactionsProvider.getTransactions(),
        ]);
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