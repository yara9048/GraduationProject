import 'package:flutter/material.dart';
import 'package:graduationprojct/ui/pages/auth/sign_up/splash_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashPage(),
    );
  }
}
