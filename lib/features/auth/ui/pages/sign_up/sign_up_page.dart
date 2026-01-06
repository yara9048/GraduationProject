import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../widgets/auth_pages_template.dart';
import '../../widgets/button_template.dart';
import '../../widgets/text_field_template.dart';
import '../sign_in/sign_up_page.dart';
import 'verify_email_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordVerifyingController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthPagesTemplate(
        text1: "!أهلاً بك ",
        size1: 17,
        size2: 17,
        text2: ".قم بإنشاء حسابك الآن لتبدأ رحلتك التعليمية معنا",
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 210),
                  Padding(
                    padding: const EdgeInsets.only(left: 250),
                    child: Text(
                      "البريد الالكتروني",
                      style: TextStyle(
                        color: Color(0xff1A2429),
                        fontSize: 17,
                        fontFamily: "Tajawal",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFieldTemplate(
                    controller: emailController,
                    size2: 17,
                    size: 16,
                    hint: " بريدك الالكتروني",
                    icon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الحقل فارغ";
                      } else if (!RegExp(
                        r'^[^@]+@[^@]+\.[^@]+',
                      ).hasMatch(value)) {
                        return "ادخل بريد الكتروني صالح";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 285),
                    child: Text(
                      "كلمة المرور",
                      style: TextStyle(
                        color: Color(0xff1A2429),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Tajawal",
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFieldTemplate(
                    controller: passwordController,
                    size2: 17,
                    size: 16,
                    hint: " كلمة المرور",
                    icon: Icons.remove_red_eye,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الحقل فارغ";
                      } else if (value.length < 6) {
                        return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only(left: 240),
                    child: Text(
                      "تأكيد كلمة المرور",
                      style: TextStyle(
                        color: Color(0xff1A2429),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Tajawal",
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFieldTemplate(
                    size2: 17,
                    size: 16,
                    hint: "تأكيد كلمة المرور",

                    icon: Icons.remove_red_eye,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الحقل فارغ";
                      } else if (value != passwordController.text) {
                        return "كلمات المرور غير متطابقة";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 50),
                  ButtonTemplate(
                    text: "انشاء حساب",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print("✅ Validation Passed");
                        print("Email: ${emailController.text}");
                        print("Password: ${passwordController.text}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return VerifyEmailPage();
                            },
                          ),
                        );
                      }
                    },
                  ),

                  SizedBox(height: 50),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(fontSize: 17, fontFamily: "Tajawal"),
                      children: [
                        TextSpan(
                          text: "لديك حساب مسبقاً؟ ",
                          style: TextStyle(
                            color: Colors.black38,
                            fontFamily: "Tajawal",
                            fontSize: 17,
                          ),
                        ),
                        TextSpan(
                          text: "تسجيل الدخول",
                          style: TextStyle(
                            color: Color(0xffE9C46A),
                            fontFamily: "Tajawal",
                            fontSize: 17,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => SignInPage()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
