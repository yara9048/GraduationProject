import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/videos_page.dart';

class SubjectsCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final double width;
  final BoxFit fit;
  final Color textColor;
  final double width2;
  final double top;
  final double size;


  const SubjectsCard({
    this.fit = BoxFit.none,
    super.key,
    this.top=35,
    this.size=26,
    this.width2=180,
    required this.title,
    required this.imagePath,
    this.width = 240,
    this.textColor = const Color(0xffB88900),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: GestureDetector(
        onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context){return VideoPage();}));},
        child: Container(
          width: width,
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                offset: Offset(-3, 3),
              ),
            ],
          ),
          child: Stack(
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
      ),
    );
  }
}
