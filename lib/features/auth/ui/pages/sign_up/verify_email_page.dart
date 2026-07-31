import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/resend_otp_provider.dart';
import 'package:graduationprojct/features/auth/providers/send_otp_provider.dart';
import 'package:graduationprojct/features/auth/ui/pages/sign_in/sign_in_page.dart';
import 'package:graduationprojct/features/auth/ui/pages/sign_up/sign_up_page.dart';
import 'package:provider/provider.dart';

import '../../widgets/auth_pages_template.dart';
import '../../widgets/button_template.dart';
import '../../widgets/otp_input_template.dart';
import '../../widgets/snack_bar.dart';


  class VerifyEmailPage extends StatefulWidget {
  final String email;

  const VerifyEmailPage({
  super.key,
  required this.email,
  });
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
                SizedBox(height:200),
                OtpInputTemplate(
                  numberOfFields: 4,
                  fieldWidth: 60,
                  fieldHeight: 60,
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

                Consumer<ResendOtpProvider>(
                  builder: (context, authProvider, child) {
                    return authProvider.isLoading
                        ? const CircularProgressIndicator(
                      color: Color(0xff2A9D8F),
                    )
                        : RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15,
                          fontFamily: "Tajawal",
                        ),
                        children: [
                          const TextSpan(
                            text: "لم يصلك الرمز؟",
                            style: TextStyle(color: Colors.black38),
                          ),
                          TextSpan(
                            text: " إعادة ارسال الرمز",
                            style: const TextStyle(
                              color: Color(0xffE9C46A),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                final success =
                                await authProvider.resendotp(widget.email);
                                if (authProvider.isSuccess) {
                                  MySnackBar.show(
                                    context,
                                    message: "تم إرسال الرمز مرة أخرى",
                                  );
                                } else {
                                  MySnackBar.show(
                                    context,
                                    message: authProvider.errorMessage ??
                                        "حدث خطأ، حاول مرة أخرى",
                                  );
                                }
                              },
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 90),

                Consumer<SendOtpProvider>(
                  builder: (context, authProvider, child) {
                    return authProvider.isLoading
                        ? const CircularProgressIndicator(color: Color(0xff2A9D8F))
                        : ButtonTemplate(
                      text: "تأكيد حساب",
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
                            MaterialPageRoute(builder: (_) => const SignInPage()),
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
