import 'dart:async';
import 'package:flutter/material.dart';

import '../sign_in/sign_in_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2A9D8F),
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              'assets/Images/Ellipse 41.png',
              colorBlendMode: BlendMode.multiply,
            ),
          ),
          Positioned(
            left: 0,
            bottom: 90,
            child: Image.asset(
              'assets/Images/Ellipse 3.png',
              colorBlendMode: BlendMode.multiply,
            ),
          ),
          Positioned(
            left: 0,
            bottom: 0,
            child: Image.asset(
              'assets/Images/Intersect.png',
              colorBlendMode: BlendMode.multiply,
            ),
          ),
          Positioned(
            left: 100,
            bottom: 100,
            right: 100,
            top: 100,
            child: Image.asset(
              'assets/Images/Asset 1.png',
            ),
          ),
        ],
      ),
    );
  }
}

