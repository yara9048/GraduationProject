import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CourseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة مع أيقونة التشغيل
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  'assets/Images/Gemini_Generated_Image_hy81hehy81hehy81 1.png',
                  width: double.infinity,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.orange,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان
                Text(
                  'مقدمة في قانون أصول المحاكمات الجزائية',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(height: 12),
                // صف الزر والوقت
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text('التفاصيل'),
                    ),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          '2 ساعة',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}