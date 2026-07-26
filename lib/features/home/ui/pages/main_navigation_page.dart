import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:graduationprojct/features/home/ui/pages/display_playlists_page.dart';
import 'package:graduationprojct/features/home/ui/pages/payment_page.dart';

import '../../../auth/providers/profile_provider.dart';
import '../../../auth/ui/pages/profile/profile_page.dart';
import '../../providers/display_facourite_provider.dart';
import '../../providers/display_playlists_provider.dart';
import '../../providers/filtered_playlist_provider.dart';
import '../../providers/main_navigation_provider.dart';
import 'favourite_page.dart';
import 'home_page.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({
    super.key,
  });

  @override
  State<MainNavigationPage> createState() =>
      _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
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
  }

  Future<void> _onTabPressed(int index) async {
    final navigationProvider =
    context.read<MainNavigationProvider>();

    await navigationProvider.changeTab(
      index: index,
      displayPlaylistsProvider:
      context.read<DisplayPlaylistsProvider>(),
      filteredPlaylistProvider:
      context.read<FilteredPlaylistProvider>(),
      displayFavouriteProvider:
      context.read<DisplayFavouriteProvider>(),
      profileProvider:
      context.read<ProfileProvider>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.select<
        MainNavigationProvider,
        int>(
          (provider) => provider.currentIndex,
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        extendBody: false,
        body: IndexedStack(
          index: currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: const Color(0xff2A9D8F)
                    .withValues(alpha: 0.12),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.07,
                ),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: CustomNavigationBar(
              currentIndex: currentIndex,
              onTap: _onTabPressed,
              iconSize: 35,
              isFloating: false,
              elevation: 0,
              backgroundColor: Colors.white,
              selectedColor: const Color(0xff2A9D8F),
              unSelectedColor: const Color(0xff9AB5B1),
              strokeColor: const Color(0xffE9C46A),
              scaleFactor: 0.15,
              items: [
                CustomNavigationBarItem(
                  icon: const Icon(
                    Icons.home_outlined,
                  ),
                  selectedIcon: const Icon(
                    Icons.home_rounded,
                  ),
                ),
                CustomNavigationBarItem(
                  icon: const Icon(
                    Icons.playlist_play_outlined,
                  ),
                  selectedIcon: const Icon(
                    Icons.playlist_play,
                  ),
                ),
                CustomNavigationBarItem(
                  icon: const Icon(
                    Icons.favorite_border_rounded,
                  ),
                  selectedIcon: const Icon(
                    Icons.favorite_rounded,
                  ),
                ),
                CustomNavigationBarItem(
                  icon: const Icon(
                    Icons.monetization_on_outlined,
                  ),
                  selectedIcon: const Icon(
                    Icons.monetization_on,
                  ),
                ),
                CustomNavigationBarItem(
                  icon: const Icon(
                    Icons.person_outline_rounded,
                  ),
                  selectedIcon: const Icon(
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