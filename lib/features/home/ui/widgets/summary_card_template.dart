import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String data;
  const SummaryCard({super.key, required this.data});


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
            child: Text(data,style: TextStyle(
              fontSize: 16,
                height: 1.8,
              fontWeight: FontWeight.bold,
              color: Color(0xff181C1F),
              fontFamily: "Tajawal",),
          ),
        ),
      ),
    ));
  }
}