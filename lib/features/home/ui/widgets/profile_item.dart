import 'package:flutter/material.dart';

Widget profileItem(IconData icon, String title) {
  return Container(
    height: 60,
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          offset: const Offset(0, 6), // الظل للأسفل
          blurRadius: 10,
          spreadRadius: 0,
        ),
      ],
    ),
    child: ListTile(
      leading: Icon(
        icon,
        color: const Color(0xff2A9D8F),
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: () {},
    ),
  );
}