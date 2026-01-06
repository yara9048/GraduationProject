import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/ui/pages/sign_up/sign_up_page.dart';

import '../../widgets/auth_pages_template.dart';
import '../../widgets/button_template.dart';
import '../../widgets/otp_input_template.dart';


class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final _formKey = GlobalKey<FormState>();

  bool _otpError = false;
  String _otpValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthPagesTemplate(
        text1: "أدخل الرمز المرسل إلى بريدك الالكتروني",
        size1: 17,
        size2: 17,
        text2: ". لمتابعة إنشاء الحساب",
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OtpInputTemplate(
                  numberOfFields: 4,
                  fieldWidth: 75,
                  fieldHeight: 80,
                  borderRadius: BorderRadius.circular(15),
                  fillColor: const Color(0xffD1D9D9).withOpacity(0.2),
                  borderColor: Colors.black38,
                  focusedBorderColor: const Color(0xff2A9D8F),
                  hasError: _otpError,
                  errorText: "يرجى إدخال رمز مكوّن من 4 أرقام",
                  onChanged: (code) {
                    _otpValue = code;
                  },
                  onSubmit: (code) {
                    _otpValue = code;
                  },
                ),

                const SizedBox(height: 35),

                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 17, fontFamily: "Tajawal"),
                    children: [
                      const TextSpan(
                        text: "لم يصلك الرمز؟",
                        style: TextStyle(
                            color: Colors.black38,
                            fontFamily: "Tajawal",
                            fontSize: 15),
                      ),
                      TextSpan(
                        text: " إعادة ارسال الرمز",
                        style: const TextStyle(
                            color: Color(0xffE9C46A),
                            fontFamily: "Tajawal",
                            fontSize: 15),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const VerifyEmailPage()),
                            );
                          },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 90),

                ButtonTemplate(
                  text: "تأكيد حساب",
                  onPressed: () {
                    if (_otpValue.length != 4) {
                      setState(() => _otpError = true);
                      return;
                    }
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return const SignUpPage();
                        }));
                  },
                ),

                const SizedBox(height: 110),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
