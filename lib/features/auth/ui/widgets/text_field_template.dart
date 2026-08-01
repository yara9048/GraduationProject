import 'package:flutter/material.dart';

class TextFieldTemplate extends StatefulWidget {
  final String hint;
  final IconData icon;
  final double size;
  final double size2;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final Function(String)? onSubmitted;

  const TextFieldTemplate({
    super.key,
    required this.hint,
    required this.size,
    required this.size2,
    required this.icon,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.onSubmitted,
  });

  @override
  _TextFieldTemplateState createState() => _TextFieldTemplateState();
}

class _TextFieldTemplateState extends State<TextFieldTemplate> {

  final FocusNode _focusNode = FocusNode();


  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {

    final bool isFocused = _focusNode.hasFocus;


    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Color(0xff2A9D8F).withOpacity(0.3),
          selectionHandleColor: Color(0xff2A9D8F),
          cursorColor: Color(0xff2A9D8F),
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:30),

        child: TextFormField(

          focusNode: _focusNode,

          controller: widget.controller,

          validator: widget.validator,

          keyboardType: widget.keyboardType,


          // أضف هذا
          onFieldSubmitted: widget.onSubmitted,


          textDirection: TextDirection.rtl,

          textAlign: TextAlign.right,

          cursorColor: Color(0xff2A9D8F),


          style: const TextStyle(
            color: Colors.black,
            fontFamily:"Tajawal",
          ),


          decoration: InputDecoration(

            filled:true,

            fillColor:Colors.white,


            suffixIcon: Icon(
              widget.icon,
              color: isFocused
                  ? const Color(0xff2A9D8F)
                  : Colors.black26,
              size:16,
            ),


            hintText:widget.hint,

            hintTextDirection:
            TextDirection.rtl,


            hintStyle:const TextStyle(
              color:Color(0xffD1D9D9),
              fontWeight:FontWeight.bold,
              fontSize:13,
              fontFamily:"Tajawal",
            ),


            contentPadding:
            EdgeInsets.symmetric(
              vertical:widget.size2,
              horizontal:widget.size,
            ),


            border:OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(2),
            ),


            enabledBorder:OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(22),
              borderSide:
              BorderSide(
                color:Colors.black26,
                width:2,
              ),
            ),


            focusedBorder:OutlineInputBorder(
              borderRadius:
              BorderRadius.circular(22),
              borderSide:
              BorderSide(
                color:Color(0xff2A9D8F),
                width:2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}