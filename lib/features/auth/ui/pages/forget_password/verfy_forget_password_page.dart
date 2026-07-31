import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/password_send_otp_prvider.dart';
import 'package:provider/provider.dart';

import '../../../providers/send_otp_provider.dart';
import '../../widgets/auth_pages_template.dart';
import '../../widgets/button_template.dart';
import '../../widgets/otp_input_template.dart';
import '../../widgets/snack_bar.dart';
import '../sign_up/verify_email_page.dart';
import 'new_password_page.dart';

class VerifyForgetPasswordPage extends StatefulWidget {
  final String email;

  const VerifyForgetPasswordPage({super.key, required this.email});

  @override
  State<VerifyForgetPasswordPage> createState() => _VerifyForgetPasswordPageState();
}

class _VerifyForgetPasswordPageState extends State<VerifyForgetPasswordPage> {
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
        text2: ". لتعديل كلمة المرور",
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 200,),
                OtpInputTemplate(
                  numberOfFields: 4,
                  fieldWidth: 60,
                  fieldHeight: 65,
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

                const SizedBox(height: 10),

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
                                  builder: (_) => const VerifyEmailPage(email: '',)),
                            );
                          },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                Consumer<PasswordSendOtpPrvider>(
                  builder: (context, authProvider, child) {
                    return authProvider.isLoading
                        ? const CircularProgressIndicator(color: Color(0xff2A9D8F))
                        : ButtonTemplate(
                      text: "متابعة",
                      onPressed: () async {
                        print(_otpValue);

                        if (_otpValue.length != 4) {
                          setState(() => _otpError = true);
                          return;
                        }

                        setState(() => _otpError = false);

                        await authProvider.sendotp(
                          email: widget.email,
                          code: _otpValue,
                        );

                        if (authProvider.isSuccess) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => NewPasswordPage(email: widget.email)),
                          );
                        } else {
                          MySnackBar.show(
                            context,
                            message: authProvider.errorMessage ?? "حدث خطأ، حاول مرة أخرى",
                          );
                        }
                      },
                    );
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
