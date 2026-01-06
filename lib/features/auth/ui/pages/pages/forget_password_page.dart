import 'package:flutter/material.dart';


import '../../widgets/auth_pages_template.dart';
import '../../widgets/button_template.dart';
import '../../widgets/text_field_template.dart';
import 'verfy_forget_password_page.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthPagesTemplate(
        text1: "هل نسيت كلمة المرور؟",
        text2: " ",
        size1:17,
        size2:17,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(),
            child: Form(
              key:_formKey,
              child: Column(
                children: [
                  SizedBox(height: 240),
                  TextFieldTemplate(
                    controller: emailController,
                    size: 40,
                    size2:25,
                    hint: " بريدك الالكتروني",
                    icon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الحقل فارغ";
                      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return "ادخل بريد الكتروني صالح";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40),
                  ButtonTemplate(
                    text: "متابعة",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print("✅ Validation Passed");
                        print("Email: ${emailController.text}");
                        Navigator.push(context, MaterialPageRoute(builder: (context){return VerifyForgetPasswordPage();}));
                      }
                    },
                  ),

                  SizedBox(height: 70),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
