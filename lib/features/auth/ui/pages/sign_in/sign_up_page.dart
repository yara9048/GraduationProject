import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../Widgets/auth_pages_template.dart';
import '../../../Widgets/button_template.dart';
import '../../../Widgets/text_field_template.dart';
import '../../home/home_page.dart';
import '../forget_password/forget_password_page.dart';
import '../sign_up/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthPagesTemplate(
        text1: "مرحبا بعودتك",
        text2: "يرجى ادخال بياناتك لتسجيل الدخول",
        size1: 17,
        size2: 17,
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                const SizedBox(height: 230),

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

                const SizedBox(height: 12),

                TextFieldTemplate(
                  controller: emailController,
                  size2: 17,
                  size: 16,
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
                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.only(left: 280),
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

                const SizedBox(height: 12),

                TextFieldTemplate(
                  controller: passwordController,
                  size: 16,
                  size2: 17,
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

                Padding(
                  padding: const EdgeInsets.only(right: 200, top: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                            return ForgetPasswordPage();
                          }));
                    },
                    child: Text(
                      "هل نسيت كلمة المرور؟",
                      style: TextStyle(
                        color: Color(0xff2A9D8F),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Tajawal",
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                ButtonTemplate(
                  text: "تسجيل الدخول",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => HomePage()),
                      );
                    }
                  },
                ),

                const SizedBox(height: 50),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(fontSize: 17, fontFamily: "Tajawal"),
                    children: [
                      const TextSpan(
                        text: "ليس لديك حساب؟ ",
                        style: TextStyle(
                          color: Colors.black38,
                          fontFamily: "Tajawal",
                          fontSize: 17,
                        ),
                      ),
                      TextSpan(
                        text: "انشاء حساب جديد",
                        style: const TextStyle(
                          color: Color(0xffE9C46A),
                          fontFamily: "Tajawal",
                          fontSize: 17,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => SignUpPage()),
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
    );
  }
}
