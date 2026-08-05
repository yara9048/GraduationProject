import 'package:flutter/material.dart';

class AuthPagesTemplate extends StatelessWidget {
  final Widget child;
  final String text1;
  final String text2;
  final double? size1;
  final double? size2;

  const AuthPagesTemplate({
    super.key,
    required this.child,
    required this.text1,
    required this.text2,
    required this.size1,
    required this.size2,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ClipRect(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/Images/Ellipse 4.png',
                ),
              ),
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/Images/Ellipse 7.png',
                ),
              ),
            ),

            // المحتوى القابل للتمرير
            Positioned.fill(
              child: child,
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 175,
              child: IgnorePointer(
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: IgnorePointer(
                child: Image.asset(
                  'assets/Images/Ellipse 4.png',
                ),
              ),
            ),
            Positioned(
              top: 50,
              right: 30,
              left: 20,
              child: IgnorePointer(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'لمّاح',
                      textDirection:
                      TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 43,
                        fontWeight:
                        FontWeight.bold,
                        color: Color(
                          0xff2A9D8F,
                        ),
                        fontFamily:
                        'Tajawal',
                        shadows: [
                          Shadow(
                            offset: Offset(-1, 4),
                            blurRadius: 16,
                            color: Colors.black26,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    Text(
                      text1,
                      textAlign: TextAlign.right,
                      textDirection:
                      TextDirection.rtl,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size1,
                        fontFamily: 'Tajawal',
                      ),
                    ),
                    Text(
                      text2,
                      textAlign: TextAlign.right,
                      textDirection:
                      TextDirection.rtl,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size2,
                        fontFamily: 'Tajawal',
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
}