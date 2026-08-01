import 'package:flutter/material.dart';

Widget profileItem(
    IconData icon,
    String title, {
      required VoidCallback onTap,
    }) {
  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(
            alpha: 0.12,
          ),
          offset: const Offset(0, 6),
          blurRadius: 10,
        ),
      ],
    ),
    child: Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 6,
        ),
        leading: Icon(
          icon,
          color: const Color(0xff2A9D8F),
          size: 20,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xff264653),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          color: Color(0xff2A9D8F),
          size: 18,
        ),
      ),
    ),
  );
}