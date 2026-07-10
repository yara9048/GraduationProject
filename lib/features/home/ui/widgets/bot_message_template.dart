import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BotMessage extends StatelessWidget {
  final String text;

  const BotMessage({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xffE8E8E8),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: "Tajawal",
            fontSize: 18,
            height: 1.8,
            color: Color(0xff181C1F),
          ),
        ),
      ),
    );
  }
}
