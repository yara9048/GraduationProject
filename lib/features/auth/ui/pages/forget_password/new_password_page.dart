import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/new_password_provider.dart';
import 'package:graduationprojct/features/auth/ui/pages/sign_in/sign_in_page.dart';
import 'package:provider/provider.dart';

import '../../widgets/auth_pages_template.dart';
import '../../widgets/button_template.dart';
import '../../widgets/snack_bar.dart';
import '../../widgets/text_field_template.dart';
import '../sign_up/sign_up_page.dart';

class NewPasswordPage extends StatefulWidget {
  final String email;
  const NewPasswordPage({super.key, required this.email});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController passwordVerifyingController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthPagesTemplate(
        text1: "قم بإدخال كلمة المرور الجديدة",
        text2: " ",
        size1:17,
        size2:17,
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 230),
                  Padding(
                    padding: const EdgeInsets.only(left: 228),
                    child: Text(
                      "كلمة المرور",
                      style: TextStyle(
                        color: Color(0xff1A2429),
                        fontSize: 13,
                        fontFamily: "Tajawal",
                        fontWeight: FontWeight.w600,

                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFieldTemplate(
                    controller: passwordController,
                    size: 16,
                    size2: 17,
                    hint: "كلمة المرور",
                    icon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "الحقل فارغ";
                      } else if (value.length < 6) {
                        return "كلمة المرور يجب أن تكون 6 أحرف على الأقل";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.only(left: 190),
                    child: Text(
                      "تأكيد كلمة المرور",
                      style: TextStyle(
                        color: Color(0xff1A2429),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Tajawal",
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextFieldTemplate(
                    controller: passwordVerifyingController,
                    size: 16,
                    size2: 17,
                    hint: " تأكيد كلمة المرور",
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
                  SizedBox(height: 40),
                  Consumer<NewPasswordProvider>(
                    builder: (context, authProvider, child) {
                      return authProvider.isLoading
                          ? const CircularProgressIndicator(color: Color(0xff2A9D8F))
                          : ButtonTemplate(
                        text: "تعديل كلمة المرور",
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await authProvider.newPassword(
                              email:widget.email,
                              password1: passwordController.text,
                              password2:passwordVerifyingController.text,
                            );
                            if (authProvider.isSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => SignInPage()),
                              );
                            } else if (authProvider.errorMessage != null) {
                              MySnackBar.show(context, message: authProvider.errorMessage!);
                            }
                          }
                        },
                      );
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
