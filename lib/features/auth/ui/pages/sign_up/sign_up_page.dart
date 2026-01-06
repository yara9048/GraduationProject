import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/sign_up_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/auth_pages_template.dart';
import '../../widgets/button_template.dart';
import '../../widgets/snack_bar.dart';
import '../../widgets/text_field_template.dart';
import '../sign_in/sign_in_page.dart';
import 'verify_email_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController secondNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordVerifyingController = TextEditingController();
  bool isValidationActive = false;

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
            padding: EdgeInsets.only(top: 90, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: isValidationActive? 100: 110),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "الاسم",
                              style: TextStyle(
                                color: Color(0xff1A2429),
                                fontSize: 17,
                                fontFamily: "Tajawal",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: isValidationActive? 0:5,),
                            TextFieldTemplate(
                              controller: firstNameController,
                              size2: 17,
                              size: 16,
                              hint: "اسمك",
                              icon: Icons.person,
                              validator: (value) {
                                if (!isValidationActive) return null;
                                if (value == null || value.isEmpty) return "الحقل فارغ";
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "الكنية",
                              style: TextStyle(
                                color: Color(0xff1A2429),
                                fontSize: 17,
                                fontFamily: "Tajawal",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: isValidationActive? 0:5,),
                            TextFieldTemplate(
                              controller: secondNameController,
                              size2: 17,
                              size: 16,
                              hint: "كنيتك",
                              icon: Icons.person_outline,
                              validator: (value) {
                                if (!isValidationActive) return null;
                                if (value == null || value.isEmpty) return "الحقل فارغ";
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isValidationActive? 15: 20),
                  Align(
                    alignment: Alignment.centerRight,
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
                  SizedBox(height: 5),
                  TextFieldTemplate(
                    controller: emailController,
                    size2: 17,
                    size: 16,
                    hint: "بريدك الالكتروني",
                    icon: Icons.email_outlined,
                    validator: (value) {
                      if (!isValidationActive) return null;
                      if (value == null || value.isEmpty) return "الحقل فارغ";
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return "ادخل بريد الكتروني صالح";
                      return null;
                    },
                  ),
                  SizedBox(height: isValidationActive? 10: 20),
                  Align(
                    alignment: Alignment.centerRight,
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
                  SizedBox(height: 5),
                  TextFieldTemplate(
                    controller: passwordController,
                    size2: 17,
                    size: 16,
                    hint: "كلمة المرور",
                    icon: Icons.remove_red_eye,
                    validator: (value) {
                      if (!isValidationActive) return null;
                      if (value == null || value.isEmpty) return "الحقل فارغ";
                      if (value.length < 6) return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                      return null;
                    },
                  ),
                  SizedBox(height: isValidationActive? 10: 20),
                  Align(
                    alignment: Alignment.centerRight,
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
                  SizedBox(height: 5),
                  TextFieldTemplate(
                    controller: passwordVerifyingController,
                    size2: 17,
                    size: 16,
                    hint: "تأكيد كلمة المرور",
                    icon: Icons.remove_red_eye,
                    validator: (value) {
                      if (!isValidationActive) return null;
                      if (value == null || value.isEmpty) return "الحقل فارغ";
                     // if (value != passwordController.text) return "كلمات المرور غير متطابقة";
                      return null;
                    },
                  ),
                  SizedBox(height: isValidationActive?20: 40),
                  Consumer<SignUpProvider>(
                    builder: (context, authProvider, child) {
                      return authProvider.isLoading
                          ? const CircularProgressIndicator(color: Color(0xff2A9D8F))
                          : ButtonTemplate(
                        text: "انشاء حساب",
                        onPressed: () async {
                          setState(() {
                            isValidationActive = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            await authProvider.register(
                              email: emailController.text,
                              password1: passwordController.text,
                              password2:passwordVerifyingController.text,
                              firstName: firstNameController.text,
                              lastName: secondNameController.text,
                            );
                            if (authProvider.isSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => VerifyEmailPage(email: emailController.text,)),
                              );
                            } else if (authProvider.errorMessage != null) {
                              MySnackBar.show(context, message: authProvider.errorMessage!);
                            }
                          }
                        },
                      );
                    },
                  ),

                  SizedBox(height: 15),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(fontSize: 17, fontFamily: "Tajawal"),
                      children: [
                        TextSpan(
                          text: "لديك حساب مسبقاً؟ ",
                          style: TextStyle(color: Colors.black38, fontFamily: "Tajawal", fontSize: 17),
                        ),
                        TextSpan(
                          text: "تسجيل الدخول",
                          style: TextStyle(color: Color(0xffE9C46A), fontFamily: "Tajawal", fontSize: 17),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => SignInPage()));
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
