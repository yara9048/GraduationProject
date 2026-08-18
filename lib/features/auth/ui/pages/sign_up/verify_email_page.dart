import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/resend_otp_provider.dart';
import 'package:graduationprojct/features/auth/providers/send_otp_provider.dart';
import 'package:graduationprojct/features/auth/ui/pages/sign_in/sign_in_page.dart';
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
  State<VerifyEmailPage> createState() =>
      _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  bool _otpError = false;
  String _otpValue = '';

  @override
  Widget build(BuildContext context) {
    final double keyboardHeight =
        MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: AuthPagesTemplate(
        text1: 'أدخل الرمز المرسل إلى بريدك الالكتروني',
        size1: 17,
        size2: 17,
        text2: '. لمتابعة إنشاء الحساب',
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                physics:
                const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  bottom: keyboardHeight > 0 ? 24 : 0,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const Spacer(
                            flex: 3,
                          ),
                          OtpInputTemplate(
                            numberOfFields: 4,
                            fieldWidth: 60,
                            fieldHeight: 60,
                            borderRadius:
                            BorderRadius.circular(15),
                            fillColor:
                            const Color(0xffD1D9D9)
                                .withOpacity(0.2),
                            borderColor: Colors.black38,
                            focusedBorderColor:
                            const Color(0xff2A9D8F),
                            hasError: _otpError,
                            errorText:
                            'يرجى إدخال رمز مكوّن من 4 أرقام',
                            onChanged: (code) {
                              _otpValue = code;

                              if (_otpError &&
                                  code.length == 4) {
                                setState(() {
                                  _otpError = false;
                                });
                              }
                            },
                            onSubmit: (code) {
                              _otpValue = code;
                            },
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Consumer<ResendOtpProvider>(
                            builder: (
                                context,
                                authProvider,
                                child,
                                ) {
                              if (authProvider.isLoading) {
                                return const CircularProgressIndicator(
                                  color:
                                  Color(0xff2A9D8F),
                                );
                              }

                              return RichText(
                                textAlign:
                                TextAlign.center,
                                text: TextSpan(
                                  style:
                                  const TextStyle(
                                    fontSize: 15,
                                    fontFamily:
                                    'Tajawal',
                                  ),
                                  children: [
                                    const TextSpan(
                                      text:
                                      'لم يصلك الرمز؟',
                                      style:
                                      TextStyle(
                                        color:
                                        Colors.black38,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                      ' إعادة ارسال الرمز',
                                      style:
                                      const TextStyle(
                                        color:
                                        Color(
                                          0xffE9C46A,
                                        ),
                                        fontWeight:
                                        FontWeight.bold,
                                      ),
                                      recognizer:
                                      TapGestureRecognizer()
                                        ..onTap =
                                            () async {
                                          await authProvider
                                              .resendotp(
                                            widget
                                                .email,
                                          );

                                          if (!context
                                              .mounted) {
                                            return;
                                          }

                                          if (authProvider
                                              .isSuccess) {
                                            MySnackBar
                                                .show(
                                              context,
                                              message:
                                              'تم إرسال الرمز مرة أخرى',
                                            );
                                          } else {
                                            MySnackBar
                                                .show(
                                              context,
                                              message:
                                              authProvider.errorMessage ??
                                                  'حدث خطأ، حاول مرة أخرى',
                                            );
                                          }
                                        },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const Spacer(
                            flex: 2,
                          ),
                          Consumer<SendOtpProvider>(
                            builder: (
                                context,
                                authProvider,
                                child,
                                ) {
                              if (authProvider.isLoading) {
                                return const CircularProgressIndicator(
                                  color:
                                  Color(0xff2A9D8F),
                                );
                              }

                              return ButtonTemplate(
                                text: 'تأكيد حساب',
                                onPressed: () async {
                                  FocusScope.of(context)
                                      .unfocus();

                                  if (_otpValue.length !=
                                      4) {
                                    setState(() {
                                      _otpError = true;
                                    });

                                    return;
                                  }

                                  setState(() {
                                    _otpError = false;
                                  });

                                  await authProvider
                                      .sendotp(
                                    email: widget.email,
                                    code: _otpValue,
                                  );

                                  if (!mounted) {
                                    return;
                                  }

                                  if (authProvider
                                      .isSuccess) {
                                    Navigator
                                        .pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                        const SignInPage(),
                                      ),
                                    );
                                  } else {
                                    MySnackBar.show(
                                      context,
                                      message:
                                      authProvider.errorMessage ??
                                          'حدث خطأ، حاول مرة أخرى',
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          const Spacer(),
                          SizedBox(
                            height:
                            keyboardHeight > 0
                                ? 20
                                : 60,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}