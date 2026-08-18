import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/ui/pages/sign_in/sign_in_page.dart';
import 'package:graduationprojct/features/home/ui/pages/watching_history_page.dart';
import 'package:provider/provider.dart';

import '../../../providers/log_out_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../widgets/edit_major_dialog.dart';
import '../../widgets/edit_name_dialog.dart';
import '../../widgets/profile_dialogs.dart';
import '../../widgets/profile_image_picker.dart';
import '../../widgets/profile_item.dart';
import '../../widgets/snack_bar.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onFavouritePressed;
  final VoidCallback? onCoursesPressed;

  const ProfilePage({
    super.key,
    this.onBack,
    this.onFavouritePressed,
    this.onCoursesPressed,
  });

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback(
          (_) {
        if (!mounted) {
          return;
        }

        context
            .read<ProfileProvider>()
            .getProfile();
      },
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final ProfileProvider
    profileProvider =
    context.watch<
        ProfileProvider>();

    final LogoutProvider
    logoutProvider =
    context.watch<
        LogoutProvider>();

    final profile =
        profileProvider.profile;
    if (profileProvider.isLoading &&
        profile == null) {
      return const Directionality(
        textDirection:
        TextDirection.rtl,
        child: Scaffold(
          backgroundColor:
          Colors.white,
          body: Center(
            child:
            CircularProgressIndicator(
              color: Color(
                0xff2A9D8F,
              ),
            ),
          ),
        ),
      );
    }

    if (profile == null) {
      return Directionality(
        textDirection:
        TextDirection.rtl,
        child: Scaffold(
          backgroundColor:
          Colors.white,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/Images/Ellipse 4.png',
                ),
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  'assets/Images/Ellipse 7.png',
                ),
              ),
              Center(
                child: Padding(
                  padding:
                  const EdgeInsets
                      .symmetric(
                    horizontal: 24,
                  ),
                  child: Column(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons
                            .person_off_outlined,
                        color:
                        Color(
                          0xffE76F51,
                        ),
                        size: 55,
                      ),

                      const SizedBox(
                        height: 15,
                      ),

                      Text(
                        profileProvider
                            .errorMessage ??
                            'تعذر تحميل بيانات الحساب',
                        textAlign:
                        TextAlign.center,
                        style:
                        const TextStyle(
                          fontFamily:
                          'Tajawal',
                          fontSize: 17,
                          color:
                          Color(
                            0xff264653,
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      ElevatedButton.icon(
                        onPressed:
                        profileProvider
                            .isLoading
                            ? null
                            : () {
                          profileProvider
                              .refreshProfile();
                        },
                        style:
                        ElevatedButton
                            .styleFrom(
                          backgroundColor:
                          const Color(
                            0xff2A9D8F,
                          ),
                          foregroundColor:
                          Colors.white,
                          padding:
                          const EdgeInsets
                              .symmetric(
                            horizontal:
                            24,
                            vertical: 12,
                          ),
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius
                                .circular(
                              12,
                            ),
                          ),
                        ),
                        icon:
                        profileProvider
                            .isLoading
                            ? const SizedBox(
                          width: 18,
                          height:
                          18,
                          child:
                          CircularProgressIndicator(
                            strokeWidth:
                            2,
                            color:
                            Colors.white,
                          ),
                        )
                            : const Icon(
                          Icons
                              .refresh_rounded,
                        ),
                        label:
                        const Text(
                          'إعادة المحاولة',
                          style:
                          TextStyle(
                            fontFamily:
                            'Tajawal',
                            fontWeight:
                            FontWeight
                                .bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Directionality(
      textDirection:
      TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
        Colors.white,

        body: RefreshIndicator(
          color: const Color(
            0xff2A9D8F,
          ),

          onRefresh: () {
            return context
                .read<
                ProfileProvider>()
                .refreshProfile();
          },

          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/Images/Ellipse 4.png',
                ),
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  'assets/Images/Ellipse 7.png',
                ),
              ),
              SafeArea(
                child:
                SingleChildScrollView(
                  physics:
                  const AlwaysScrollableScrollPhysics(),
                  padding:
                  const EdgeInsets
                      .fromLTRB(
                    20,
                    70,
                    20,
                    30,
                  ),
                  child: Column(
                    children: [
                      ProfileImagePicker(
                        serverImageUrl:
                        profile.image,
                      ),

                      const SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                        children: [
                          Flexible(
                            child:
                            Padding(
                              padding:
                              const EdgeInsets
                                  .only(
                                right:
                                50.0,
                              ),
                              child: Text(
                                '${profile.firstName} '
                                    '${profile.lastName}',
                                textAlign:
                                TextAlign
                                    .center,
                                overflow:
                                TextOverflow
                                    .ellipsis,
                                style:
                                const TextStyle(
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  fontFamily:
                                  'Tajawal',
                                  fontSize:
                                  25,
                                  color:
                                  Color(
                                    0xff264653,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(
                            width: 5,
                          ),

                          IconButton(
                            onPressed: () {
                              ProfileDialogs.showEditName(
                                context,
                              );
                            },
                            icon:
                            const Icon(
                              Icons.edit,
                              color:
                              Color(
                                0xff2A9D8F,
                              ),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        profile.major,
                        textAlign:
                        TextAlign.center,
                        style:
                        const TextStyle(
                          fontSize: 20,
                          color: Color(
                            0xff264653,
                          ),
                          fontFamily:
                          'Tajawal',
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width:
                        double.infinity,
                        margin:
                        const EdgeInsets
                            .only(
                          bottom: 12,
                        ),
                        padding:
                        const EdgeInsets
                            .all(
                          18,
                        ),
                        decoration:
                        BoxDecoration(
                          color:
                          Colors.white,
                          borderRadius:
                          BorderRadius
                              .circular(
                            18,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withValues(
                                alpha:
                                0.12,
                              ),
                              offset:
                              const Offset(
                                0,
                                6,
                              ),
                              blurRadius:
                              12,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons
                                      .email_outlined,
                                  color:
                                  Color(
                                    0xff2A9D8F,
                                  ),
                                  size: 20,
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child: Text(
                                    profile
                                        .email,
                                    overflow:
                                    TextOverflow
                                        .ellipsis,
                                    style:
                                    const TextStyle(
                                      fontSize:
                                      16,
                                      fontFamily:
                                      'Tajawal',
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const Divider(
                              height: 30,
                            ),

                            Row(
                              children: [
                                const Icon(
                                  Icons
                                      .badge_outlined,
                                  color:
                                  Color(
                                    0xff2A9D8F,
                                  ),
                                  size: 20,
                                ),

                                const SizedBox(
                                  width: 12,
                                ),

                                Expanded(
                                  child: Text(
                                    '${profile.role} / '
                                        '${profile.major}',
                                    overflow:
                                    TextOverflow
                                        .ellipsis,
                                    style:
                                    const TextStyle(
                                      fontSize:
                                      16,
                                      fontFamily:
                                      'Tajawal',
                                    ),
                                  ),
                                ),

                                IconButton(
                                  onPressed: () {
                                    ProfileDialogs.showEditMajor(
                                      context,
                                    );
                                  },
                                  icon:
                                  const Icon(
                                    Icons.edit,
                                    color:
                                    Color(
                                      0xff2A9D8F,
                                    ),
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      profileItem(
                        Icons
                            .school_outlined,
                        'الدورات المسجلة',
                        onTap: () {
                          widget
                              .onCoursesPressed
                              ?.call();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                              const WatchingHistoryPage(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 240,
                        height: 52,
                        child:
                        ElevatedButton(
                          onPressed:
                          logoutProvider
                              .isLoading
                              ? null
                              : () async {
                            await logoutProvider
                                .logout();

                            if (!mounted) {
                              return;
                            }

                            if (logoutProvider
                                .isSuccess) {
                              Navigator
                                  .pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                  const SignInPage(),
                                ),
                                    (
                                    route,
                                    ) =>
                                false,
                              );

                              return;
                            }

                            if (logoutProvider
                                .errorMessage !=
                                null) {
                              MySnackBar
                                  .show(
                                context,
                                message:
                                logoutProvider
                                    .errorMessage!,
                              );
                            }
                          },
                          style:
                          ElevatedButton
                              .styleFrom(
                            backgroundColor:
                            const Color(
                              0xff2A9D8F,
                            ),
                            foregroundColor:
                            Colors.white,
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(
                                12,
                              ),
                            ),
                          ),
                          child:
                          logoutProvider
                              .isLoading
                              ? const SizedBox(
                            width: 22,
                            height:
                            22,
                            child:
                            CircularProgressIndicator(
                              strokeWidth:
                              2,
                              color:
                              Colors.white,
                            ),
                          )
                              : const Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                            children: [
                              Icon(
                                Icons
                                    .logout,
                              ),
                              SizedBox(
                                width:
                                8,
                              ),
                              Text(
                                'تسجيل الخروج',
                                style:
                                TextStyle(
                                  fontFamily:
                                  'Tajawal',
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                  fontSize:
                                  16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 95,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}