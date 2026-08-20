import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth/providers/profile_provider.dart';
import '../../../auth/ui/pages/profile/profile_page.dart';
import '../../providers/display_facourite_provider.dart';
import '../../providers/display_playlists_provider.dart';
import '../../providers/display_subjects_provider.dart';
import '../../providers/main_navigation_provider.dart';
import '../../providers/now_showing_playlist_provider.dart';
import '../../providers/playlist_by_class_provider.dart';
import '../../providers/wallet_provider.dart';
import '../../providers/wallet_transactions_provider.dart';
import 'display_playlists_page.dart';
import 'favourite_page.dart';
import 'home_page.dart';
import 'payment_page.dart';

class MainNavigationPage extends StatefulWidget {
  final int initialIndex;

  const MainNavigationPage({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationPage> createState() =>
      _MainNavigationPageState();
}

class _MainNavigationPageState
    extends State<MainNavigationPage> {
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = const [
      HomePage(),
      DisplayPlaylistsPage(),
      FavouritePage(),
      PaymentPage(),
      ProfilePage(),
    ];

    WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
        if (!mounted) return;

        final safeInitialIndex =
        widget.initialIndex >= 0 &&
            widget.initialIndex < _pages.length
            ? widget.initialIndex
            : 0;

        await _changeTab(
          safeInitialIndex,
        );
      },
    );
  }

  Future<void> _changeTab(
      int index,
      ) async {
    if (index < 0 ||
        index >= _pages.length) {
      return;
    }

    final navigationProvider =
    context.read<MainNavigationProvider>();

    await navigationProvider.changeTab(
      index: index,

      displayPlaylistsProvider:
      context.read<
          DisplayPlaylistsProvider>(),

      playlistByClassProvider:
      context.read<
          PlaylistByClassProvider>(),

      displayFavouriteProvider:
      context.read<
          DisplayFavouriteProvider>(),

      profileProvider:
      context.read<ProfileProvider>(),

      nowShowingPlaylistProvider:
      context.read<
          NowShowingPlaylistProvider>(),

      displaySubjectsProvider:
      context.read<
          DisplaySubjectsProvider>(),

      walletProvider:
      context.read<WalletProvider>(),

      walletTransactionsProvider:
      context.read<
          WalletTransactionsProvider>(),
    );
  }

  Future<void> _onTabPressed(
      int index,
      ) async {
    await _changeTab(index);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.select<
        MainNavigationProvider,
        int>(
          (provider) =>
      provider.currentIndex,
    );

    final safeCurrentIndex =
    currentIndex >= 0 &&
        currentIndex < _pages.length
        ? currentIndex
        : 0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: false,

        body: IndexedStack(
          index: safeCurrentIndex,
          children: _pages,
        ),

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color:
                const Color(
                  0xff2A9D8F,
                ).withValues(
                  alpha: 0.12,
                ),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color:
                Colors.black.withValues(
                  alpha: 0.07,
                ),
                blurRadius: 12,
                offset:
                const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: CustomNavigationBar(
              currentIndex:
              safeCurrentIndex,
              onTap: _onTabPressed,
              iconSize: 28,
              isFloating: false,
              elevation: 0,
              backgroundColor:
              Colors.white,
              selectedColor:
              const Color(
                0xff2A9D8F,
              ),
              unSelectedColor:
              const Color(
                0xff9AB5B1,
              ),
              strokeColor:
              const Color(
                0xffE9C46A,
              ),
              scaleFactor: 0.15,
              items: [
                CustomNavigationBarItem(
                  icon: const Icon(
                    Icons.home_outlined,
                  ),
                  selectedIcon:
                  const Icon(
                    Icons.home_rounded,
                  ),
                ),
                CustomNavigationBarItem(
                  icon: const Icon(
                    Icons
                        .playlist_play_outlined,
                  ),
                  selectedIcon:
                  const Icon(
                    Icons.playlist_play,
                  ),
                ),
                CustomNavigationBarItem(
                  icon: const Icon(
                    Icons
                        .favorite_border_rounded,
                  ),
                  selectedIcon:
                  const Icon(
                    Icons.favorite_rounded,
                  ),
                ),
                CustomNavigationBarItem(
                  icon: const Icon(
                    Icons
                        .monetization_on_outlined,
                  ),
                  selectedIcon:
                  const Icon(
                    Icons.monetization_on,
                  ),
                ),
                CustomNavigationBarItem(
                  icon: const Icon(
                    Icons
                        .person_outline_rounded,
                  ),
                  selectedIcon:
                  const Icon(
                    Icons.person_rounded,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}