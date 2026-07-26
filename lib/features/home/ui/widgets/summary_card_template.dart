import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SummaryCard extends StatelessWidget {
  final String data;

  const SummaryCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: MarkdownBody(
              data: data,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                textAlign: WrapAlignment.start,

                p: const TextStyle(
                  fontSize: 16,
                  height: 1.8,
                  color: Color(0xff181C1F),
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.w500,
                ),

                h1: const TextStyle(
                  fontSize: 24,
                  height: 1.6,
                  color: Color(0xff2A9D8F),
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.bold,
                ),

                h2: const TextStyle(
                  fontSize: 21,
                  height: 1.6,
                  color: Color(0xff2A9D8F),
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.bold,
                ),

                h3: const TextStyle(
                  fontSize: 19,
                  height: 1.6,
                  color: Color(0xff181C1F),
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.bold,
                ),

                strong: const TextStyle(
                  fontSize: 16,
                  color: Color(0xff181C1F),
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.bold,
                ),

                listBullet: const TextStyle(
                  fontSize: 18,
                  height: 1.8,
                  color: Color(0xff2A9D8F),
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.bold,
                ),

                listIndent: 24,
                blockSpacing: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}