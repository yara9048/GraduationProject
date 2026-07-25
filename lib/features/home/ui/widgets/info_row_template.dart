import 'package:flutter/cupertino.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color valueColor;

  const InfoRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor = const Color(0xff264653),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xffE9C46A),
            size: 22,
          ),
          const SizedBox(width: 10),
          Text(
            "$title :",
            style: const TextStyle(
              fontFamily: "Tajawal",
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xff264653),
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: "Tajawal",
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}