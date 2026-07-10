import 'package:flutter/material.dart';

class UserMessage extends StatelessWidget {
  final String text;

  const UserMessage({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: const BoxDecoration(
          color: Color(0xff2A9D8F),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: "Tajawal",
            fontSize: 18,
            height: 1.8,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}