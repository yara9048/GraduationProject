import 'package:flutter/material.dart';

class LockedDialog {
  static void show(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "",
      barrierColor: Colors.black.withOpacity(.35),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Container(
                width: 320,
                height: 180,
                margin: const EdgeInsets.only(top: 60),
                padding: const EdgeInsets.fromLTRB(24, 80, 24, 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Text(
                  "يجب مشاهدة الفيديو بالكامل للتمكن\nمن الوصول إلى المزايا الإضافية",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    decoration: TextDecoration.none,
                    fontSize: 16,
                    height: 1.5,
                    color: Color(0xffA7A7A7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Color(0xffD9D9D9),
                      width: 2,
                    ),
                  ),
                  child: Image.asset("assets/Images/Frame.png"),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: .9, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutBack,
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}