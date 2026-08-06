import 'package:flutter/material.dart';

import '../pages/teachers_playlist_page.dart';

class TeacherCard extends StatelessWidget {
  final String name;
  final String? image;
  final int id;
  final int subjectId;

  const TeacherCard({super.key, required this.name, this.image, required this.id, required this.subjectId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context){return TeachersPlaylistPage(id: id, subjectId: subjectId,);}));},
      child: SizedBox(
        width: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xffE8F4F2),
                border: Border.all(color: const Color(0xff2A9D8F), width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x18000000),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),

              child: image != null && image!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        image!,

                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                      ),
                    )
                  : const Icon(
                      Icons.person_rounded,

                      size: 38,

                      color: Color(0xff2A9D8F),
                    ),
            ),

            const SizedBox(height: 4),

            Text(
              name,

              maxLines: 1,

              overflow: TextOverflow.ellipsis,

              textAlign: TextAlign.center,

              style: const TextStyle(
                fontFamily: "Tajawal",

                fontSize: 13,

                fontWeight: FontWeight.bold,

                color: Color(0xff181C1F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
