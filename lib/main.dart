import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/resend_otp_provider.dart';
import 'package:graduationprojct/features/auth/providers/sign_up_provider.dart';
import 'package:graduationprojct/features/auth/ui/pages/sign_up/splash_page.dart';
import 'package:provider/provider.dart';

import 'features/auth/providers/sign_in_provider.dart';

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
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashPage(),
      ),
    );
  }
}
