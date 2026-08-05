import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/edit_profile_provider.dart';
import 'package:graduationprojct/features/auth/providers/new_password_provider.dart';
import 'package:graduationprojct/features/auth/providers/password_send_otp_prvider.dart';
import 'package:graduationprojct/features/auth/providers/profile_provider.dart';
import 'package:graduationprojct/features/auth/providers/resend_otp_provider.dart';
import 'package:graduationprojct/features/auth/providers/reset_password_request_provider.dart';
import 'package:graduationprojct/features/auth/providers/sign_up_provider.dart';
import 'package:graduationprojct/features/home/providers/add_playlist_to_fav_provider.dart';
import 'package:graduationprojct/features/home/providers/add_video_to_fav_provider.dart';
import 'package:graduationprojct/features/home/providers/ai_features_provider.dart';
import 'package:graduationprojct/features/home/providers/display_facourite_provider.dart';
import 'package:graduationprojct/features/home/providers/display_playlist_by_subject_provider.dart';
import 'package:graduationprojct/features/home/providers/display_playlists_provider.dart';
import 'package:graduationprojct/features/home/providers/display_subjects_provider.dart';
import 'package:graduationprojct/features/home/providers/display_videos_provider.dart';
import 'package:graduationprojct/features/home/providers/filtered_playlist_provider.dart';
import 'package:graduationprojct/features/home/providers/funding_request_provider.dart';
import 'package:graduationprojct/features/home/providers/get_video_progress_provider.dart';
import 'package:graduationprojct/features/home/providers/main_navigation_provider.dart';
import 'package:graduationprojct/features/home/providers/now_showing_playlist_provider.dart';
import 'package:graduationprojct/features/home/providers/playlist_details_provider.dart';
import 'package:graduationprojct/features/home/providers/playlist_search_provider.dart';
import 'package:graduationprojct/features/home/providers/rating_playlist_provider.dart';
import 'package:graduationprojct/features/home/providers/subject_search_provider.dart';
import 'package:graduationprojct/features/home/providers/subscribe_provider.dart';
import 'package:graduationprojct/features/home/providers/video_details_function_provider.dart';
import 'package:graduationprojct/features/home/providers/video_details_provider.dart';
import 'package:graduationprojct/features/home/providers/wallet_provider.dart';
import 'package:graduationprojct/features/home/providers/watching_history_provider.dart';
import 'package:graduationprojct/features/home/ui/pages/playlist_search_page.dart';
import 'package:provider/provider.dart';

import 'features/auth/data/services/firebase_messaging_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/providers/log_out_provider.dart';
import 'features/auth/providers/send_otp_provider.dart';
import 'features/auth/providers/sign_in_provider.dart';
import 'features/auth/ui/pages/sign_in/sign_in_page.dart';
import 'features/home/providers/video_progress_provider.dart';
import 'features/home/ui/pages/main_navigation_page.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
    ) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  debugPrint(
    'Background message: ${message.messageId}',
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  await FirebaseMessagingService.instance.initialize();

  final authProvider = AuthProvider();
  await authProvider.checkLogin();

  runApp(
    MyApp(
      authProvider: authProvider,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthProvider authProvider;

  const MyApp({
    super.key,
    required this.authProvider,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(
          value: authProvider,
        ),

        ChangeNotifierProvider(
          create: (_) => SignInProvider(authProvider: authProvider,),
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
          create: (_) => GetVideoProgressProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PasswordSendOtpPrvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => NewPasswordProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => VideoDetailsFunctionProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              VideoProgressProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => VideoDetailsProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => AiFeaturesProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => ProfileProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => LogoutProvider(authProvider: authProvider,),
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

        ChangeNotifierProvider(
          create: (_) => NowShowingPlaylistProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => DisplaySubjectsProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => SubscribeProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => RatingPlaylistProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => WalletProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => WatchingHistoryProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => FundingRequestProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => DisplayPlaylistBySubjectProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PlaylistSearchProvider(),
        ),ChangeNotifierProvider(
          create: (_) => SubjectSearchProvider(),
        ),
      ],
      child: const AppRoot(),
    );
  }
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: authProvider.isLoggedIn
          ? const MainNavigationPage()
          : const SignInPage(),
    );
  }
}