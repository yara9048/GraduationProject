import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  const StatisticCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor =
    const Color(0xff2A9D8F),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color:
          const Color(0xffE0ECEA),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(
              alpha: 0.04,
            ),
            blurRadius: 10,
            offset:
            const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 30,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            textAlign:
            TextAlign.center,
            maxLines: 1,
            overflow:
            TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 16,
              fontWeight:
              FontWeight.bold,
              color:
              Color(0xff264653),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign:
            TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14,
              color:
              Color(0xff264653),
            ),
          ),
        ],
      ),
    );
  }
}