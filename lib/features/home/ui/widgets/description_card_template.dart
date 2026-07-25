import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DescriptionCard extends StatelessWidget {
  final String description;

  const DescriptionCard({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xffE9C46A).withOpacity(.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.description_outlined,
                color: Color(0xffE9C46A),
                size: 22,
              ),
              SizedBox(width: 8),
              Text(
                "الوصف",
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xff264653),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: "Tajawal",
              fontSize: 14,
              height: 1.6,
              color: Color(0xff264653),
            ),
          ),
        ],
      ),
    );
  }
}