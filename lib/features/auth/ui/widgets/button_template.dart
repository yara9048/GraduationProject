import 'package:flutter/material.dart';

class ButtonTemplate extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final VoidCallback? onPressed;

  const ButtonTemplate({
    super.key,
    required this.text,
    this.height = 55,
    this.width = 280,
    this.backgroundColor = const Color(0xff2A9D8F),
    this.textColor = Colors.white,
    this.fontSize = 17,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              fontFamily: "Tajawal",
            ),
          ),
        ),
      ),
    );
  }
}
