import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  Widget section(String title, String body) {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16,right: 16),
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                section(
                  "المفاهيم الأساسية",
                  "يتناول هذا القسم تعريف النيابة وأطرافها واختصاصاتها في الدعوى الجزائية.",
                ),
                section(
                  "دور النيابة العامة",
                  "يتلخص دور النيابة العامة في تمثيل المجتمع، وتحريك الدعوى العمومية، والإشراف على تنفيذ القانون وحماية النظام العام.",
                ),
                section(
                  "الخلاصة",
                  "النيابة العامة ركن أساسي في العدالة الجزائية، وتسهم في حماية الحقوق وضمان حسن سير العدالة.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}