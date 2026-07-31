import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/reset_password_request_provider.dart';
import 'package:provider/provider.dart';


import '../../widgets/auth_pages_template.dart';
import '../../widgets/button_template.dart';
import '../../widgets/snack_bar.dart';
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100,),
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
                  SizedBox(height: 20),
                  Consumer<ResetPasswordRequestProvider>(
                    builder: (context, authProvider, child) {
                      return authProvider.isLoading
                          ? const CircularProgressIndicator(color: Color(0xff2A9D8F))
                          : ButtonTemplate(
                        text: "متابعة",
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await authProvider.resetPasswordRequest(
                              email: emailController.text,
                            );
                            if (authProvider.isSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => VerifyForgetPasswordPage(email: emailController.text,)),
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
