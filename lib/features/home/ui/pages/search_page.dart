import 'package:flutter/material.dart';

import '../../../auth/ui/widgets/text_field_template.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              icon: Row(
                children: [

                  Text("البحث",style: TextStyle(fontWeight: FontWeight.bold,
                      color: Color(0xff2A9D8F),
                      fontFamily: "Tajawal",fontSize: 28),),
                  SizedBox(width: 20,),

                  Icon(
                    Icons.arrow_back_ios_new_rounded,
                    textDirection: TextDirection.rtl,
                    color: Color(0xff2A9D8F),
                    size: 30,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 140,
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 10,
              child: TextFieldTemplate(
                hint: 'ابحث هنا',
                size: 20,
                size2: 21,
                icon: Icons.search,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
