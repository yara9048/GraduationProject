import 'package:flutter/material.dart';

class AuthPagesTemplate extends StatelessWidget {
  final Widget child;
  final String text1;
  final String text2;
  final double? size1;
  final double? size2;


  const AuthPagesTemplate({super.key, required this.child, required this.text1,required this.text2, required this.size1,required this.size2});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          child: Image.asset('assets/Images/Ellipse 4.png'),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Image.asset('assets/Images/Ellipse 7.png'),
        ),
        child,
        Positioned(
          right: 30,
          top: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "لمّاح ",
                style: TextStyle(
                  fontSize: 43,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2A9D8F),
                  fontFamily: "Tajawal",
                  shadows: [
                    Shadow(
                      offset: Offset(-1, 4),
                      blurRadius: 16,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 7,
              ),
              Text( text1,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size1,
                  fontFamily: "Tajawal",
                ),
              ),
              Text( text2,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: size2,
                  fontFamily: "Tajawal",
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
