import 'package:flutter/cupertino.dart';

Widget SummarizationSection(String title, String body) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 5,
              height: 26,
              decoration: BoxDecoration(
                color: Color(0xff0F9D8A),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF181C1F),
                fontFamily: "Tajawal",
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          body,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: "Tajawal",
            color: Color(0xff181C1F),
            height: 1.7,
          ),
        ),
      ],
    ),
  );
}
