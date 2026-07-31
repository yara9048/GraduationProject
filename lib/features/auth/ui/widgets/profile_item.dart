import 'package:flutter/material.dart';

Widget profileItem(
    IconData icon,
    String title, {
      required VoidCallback onTap,
    }) {
  return Container(
    height: 60,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          offset: const Offset(0, 6),
          blurRadius: 10,
        ),
      ],
    ),
    child: ListTile(
      leading: Icon(
        icon,
        color: const Color(0xff2A9D8F),
        size: 20,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: "Tajawal",
          fontWeight: FontWeight.w600,
          fontSize: 14
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 15,
      ),
      onTap: onTap,
    ),
  );
}