import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/edit_profile_provider.dart';
import 'package:graduationprojct/features/auth/providers/new_password_provider.dart';
import 'package:graduationprojct/features/auth/providers/password_send_otp_prvider.dart';
import 'package:graduationprojct/features/auth/providers/profile_provider.dart';
import 'package:graduationprojct/features/auth/providers/resend_otp_provider.dart';
import 'package:graduationprojct/features/auth/providers/reset_password_request_provider.dart';
import 'package:graduationprojct/features/auth/providers/sign_up_provider.dart';
import 'package:graduationprojct/features/auth/ui/pages/sign_up/splash_page.dart';
import 'package:graduationprojct/features/home/providers/add_playlist_to_fav_provider.dart';
import 'package:graduationprojct/features/home/providers/add_video_to_fav_provider.dart';
import 'package:graduationprojct/features/home/providers/display_facourite_provider.dart';
import 'package:graduationprojct/features/home/providers/display_playlists_provider.dart';
import 'package:graduationprojct/features/home/providers/display_videos_provider.dart';
import 'package:graduationprojct/features/home/providers/filtered_playlist_provider.dart';
import 'package:graduationprojct/features/home/providers/ai_features_provider.dart';
import 'package:graduationprojct/features/home/providers/playlist_details_provider.dart';
import 'package:graduationprojct/features/home/ui/pages/home_page.dart';
import 'package:provider/provider.dart';

import 'features/auth/providers/log_out_provider.dart';
import 'features/auth/providers/send_otp_provider.dart';
import 'features/auth/providers/sign_in_provider.dart';
import 'features/auth/ui/pages/sign_in/sign_in_page.dart';
import 'features/home/providers/main_navigation_provider.dart';
import 'features/home/providers/video_details_function_provider.dart';
import 'features/home/providers/video_details_provider.dart';
import 'features/home/ui/pages/chat_page.dart';
import 'features/home/ui/pages/main_navigation_page.dart';
import 'features/home/ui/pages/mcq_page.dart';
import 'features/auth/ui/pages/profile/profile_page.dart';
import 'features/home/ui/pages/summary_page.dart';
import 'features/home/ui/pages/video_details_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SignInProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SignUpProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ResendOtpProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => SendOtpProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ResetPasswordRequestProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PasswordSendOtpPrvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => NewPasswordProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PasswordSendOtpPrvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => VideoDetailsFunctionProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => VideoDetailsProvider(),
        ), ChangeNotifierProvider(
          create: (_) => AiFeaturesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LogoutProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => EditProfileProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DisplayPlaylistsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddPlaylistToFavProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DisplayVideosProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FilteredPlaylistProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AddVideoToFavProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DisplayFavouriteProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PlaylistDetailsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => MainNavigationProvider(),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const MainNavigationPage(),
      ),
    );
  }
}
