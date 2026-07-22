import 'package:flutter/material.dart';

class DisplayVideosPage extends StatefulWidget {
  const DisplayVideosPage({super.key});

  @override
  State<DisplayVideosPage> createState() => _DisplayVideosPageState();
}

class _DisplayVideosPageState extends State<DisplayVideosPage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset('assets/Images/Ellipse 4.png'),
              ),
               Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset('assets/Images/Ellipse 7.png'),
              ),
              Positioned(
                top: 55,
                right: 16,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        textDirection: TextDirection.rtl,
                        color: Color(0xff2A9D8F),
                        size: 30,
                      ),
                      SizedBox(width: 20,),

                      Text("فيديوهات قائمة التشفيل",style: TextStyle(fontWeight: FontWeight.bold,
                          color: Color(0xff2A9D8F),
                          fontFamily: "Tajawal",fontSize: 22),),


                    ],
                  ),
                ),
              ),

            ],
          )),
    );
  }
}
