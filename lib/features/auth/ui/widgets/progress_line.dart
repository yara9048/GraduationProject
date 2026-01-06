import 'package:flutter/material.dart';

class CustomProgressLine extends StatelessWidget {
  final double progress;

  const CustomProgressLine({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerRight,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffE76F51),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
