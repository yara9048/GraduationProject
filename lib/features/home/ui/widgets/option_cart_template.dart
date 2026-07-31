import 'package:flutter/material.dart';

class OptionCart extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final Color color;
  final String image;
  final VoidCallback? onPressed;

  const OptionCart({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.color,
    required this.image,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.18),
            blurRadius: 18,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontFamily: "Tajawal",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Image.asset(
                image,
                width: 20,
                height: 20,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: "Tajawal",
              color: Color(0xff181C1F),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: color,
                elevation: 0,
                side: BorderSide(
                  color: color,
                  width: 1.8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}