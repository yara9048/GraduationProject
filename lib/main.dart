import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/new_password_provider.dart';
import 'package:graduationprojct/features/auth/providers/password_send_otp_prvider.dart';
import 'package:graduationprojct/features/auth/providers/resend_otp_provider.dart';
import 'package:graduationprojct/features/auth/providers/reset_password_request_provider.dart';
import 'package:graduationprojct/features/auth/providers/sign_up_provider.dart';
import 'package:graduationprojct/features/auth/ui/pages/sign_up/splash_page.dart';
import 'package:graduationprojct/features/home/ui/pages/home_page.dart';
import 'package:provider/provider.dart';

import 'features/auth/providers/send_otp_provider.dart';
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
        ),     ChangeNotifierProvider(
          create: (_) => PasswordSendOtpPrvider(),
        ),
      ],

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
  }
}
