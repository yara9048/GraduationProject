import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../home/ui/pages/main_navigation_page.dart';
import '../../../providers/sign_in_provider.dart';
import '../../widgets/auth_pages_template.dart';
import '../../widgets/button_template.dart';
import '../../widgets/snack_bar.dart';
import '../../widgets/text_field_template.dart';
import '../forget_password/forget_password_page.dart';
import '../sign_up/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool _obscurePassword = true;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {});
    });
  }


  @override
  Widget build(BuildContext context) {
    final bool isFocused = _focusNode.hasFocus;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: AuthPagesTemplate(
        text1: 'مرحبا بعودتك',
        text2: 'يرجى ادخال بياناتك لتسجيل الدخول',
        size1: 17,
        size2: 17,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 20,
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
                          const SizedBox(
                            height: 200,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              right: 20,
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'البريد الالكتروني',
                                style: TextStyle(
                                  color: Color(0xff1A2429),
                                  fontSize: 17,
                                  fontFamily: 'Tajawal',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFieldTemplate(
                            controller: emailController,
                            size2: 17,
                            size: 16,
                            hint: 'بريدك الالكتروني',
                            icon: Icons.email_outlined,
                            validator: (value) {
                              if (value == null ||
                                  value.trim().isEmpty) {
                                return 'الحقل فارغ';
                              }

                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value.trim())) {
                                return 'ادخل بريد الكتروني صالح';
                              }

                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(
                              right: 20,
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'كلمة المرور',
                                style: TextStyle(
                                  color: Color(0xff1A2429),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          SizedBox(
                            width: 300,
                            child: TextFormField(
                              cursorColor: Color(0xff2A9D8F),
                              controller: passwordController,
                              obscureText: _obscurePassword,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 16,
                                color: Color(0xff1A2429),
                              ),
                              decoration:InputDecoration(
                                hintText: 'كلمة المرور',
                                hintTextDirection: TextDirection.rtl,
                                hintStyle: const TextStyle(
                                  color: Color(0xffD1D9D9),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  fontFamily: 'Tajawal',
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 16,
                                ),
                                suffixIcon: Icon(
                                  Icons.lock,
                                  color: isFocused
                                      ? const Color(0xff2A9D8F)
                                      : Colors.black26,
                                  size:16,
                                ),
                                prefixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: const Color(0xff2A9D8F),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(22),
                                  borderSide: const BorderSide(
                                    color: Colors.black26,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(22),
                                  borderSide: const BorderSide(
                                    color: Colors.black26,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(22),
                                  borderSide: const BorderSide(
                                    color: Color(0xff2A9D8F),
                                    width: 1.5,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(22),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(22),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الحقل فارغ';
                                }

                                if (value.length < 6) {
                                  return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                }

                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 20,
                              top: 10,
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                      const ForgetPasswordPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'هل نسيت كلمة المرور؟',
                                  style: TextStyle(
                                    color: Color(0xff2A9D8F),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 70,
                          ),
                          Consumer<SignInProvider>(
                            builder: (
                                context,
                                authProvider,
                                child,
                                ) {
                              if (authProvider.isLoading) {
                                return const CircularProgressIndicator(
                                  color: Color(0xff2A9D8F),
                                );
                              }

                              return ButtonTemplate(
                                text: 'تسجيل الدخول',
                                onPressed: () async {
                                  FocusScope.of(context).unfocus();

                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  final bool success =
                                  await authProvider.login(
                                    emailController.text.trim(),
                                    passwordController.text,
                                  );

                                  if (!context.mounted) {
                                    return;
                                  }

                                  if (success) {
                                    Navigator.of(context)
                                        .pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                        const MainNavigationPage(),
                                      ),
                                          (route) => false,
                                    );
                                  } else if (authProvider.errorMessage !=
                                      null) {
                                    MySnackBar.show(
                                      context,
                                      message:
                                      authProvider.errorMessage!,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 17,
                                fontFamily: 'Tajawal',
                              ),
                              children: [
                                const TextSpan(
                                  text: 'ليس لديك حساب؟ ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Tajawal',
                                    fontSize: 13,
                                  ),
                                ),
                                TextSpan(
                                  text: 'انشاء حساب جديد',
                                  style: const TextStyle(
                                    color: Color(0xffE9C46A),
                                    fontFamily: 'Tajawal',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                          const SignUpPage(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
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