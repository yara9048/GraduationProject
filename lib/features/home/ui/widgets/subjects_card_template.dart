import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/data/services/display_playlist_by_subject_service.dart';

import '../pages/display_playlist_by_subject_page.dart';

class SubjectsCard extends StatelessWidget {
  final int id;
  final String title;
  final String imagePath;
  final double width;
  final BoxFit fit;
  final Color textColor;
  final double width2;
  final double top;
  final double size;


  const SubjectsCard({
    required this.id,
    this.fit = BoxFit.none,
    super.key,
    this.top=35,
    this.size=18,
    this.width2=160,
    required this.title,
    required this.imagePath,
    this.width = 230,
    this.textColor = const Color(0xffB88900),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context){return DisplayPlaylistBySubjectPage(id: id,);}));},
      child: Container(
        width: width,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 3),
              blurRadius: 8,
            ),
          ]),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: 0,
              bottom: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                ),
                child: Image.asset(
                  imagePath,
                  width: width2,
                  fit: fit,
                ),
              ),
            ),
            Positioned(
              right: 10,
              top: top,
              child: SizedBox(
                width: 170,
                child:  Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: size,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Tajawal",
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
