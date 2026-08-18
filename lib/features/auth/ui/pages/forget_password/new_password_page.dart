import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/new_password_provider.dart';
import 'package:graduationprojct/features/auth/ui/pages/sign_in/sign_in_page.dart';
import 'package:provider/provider.dart';

import '../../widgets/auth_pages_template.dart';
import '../../widgets/button_template.dart';
import '../../widgets/snack_bar.dart';

class NewPasswordPage extends StatefulWidget {
  final String email;

  const NewPasswordPage({
    super.key,
    required this.email,
  });

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController passwordVerifyingController =
  TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    passwordController.dispose();
    passwordVerifyingController.dispose();
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
        text1: 'قم بإدخال كلمة المرور الجديدة',
        text2: ' ',
        size1: 17,
        size2: 17,
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 230,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 228,
                      ),
                      child: Text(
                        'كلمة المرور',
                        style: TextStyle(
                          color: Color(0xff1A2429),
                          fontSize: 13,
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: 280,
                      child: TextFormField(
                        cursorColor:  Color(0xff2A9D8F),
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Color(0xff1A2429),
                          fontSize: 16,
                          fontFamily: 'Tajawal',
                        ),
                        decoration: InputDecoration(
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
                    const SizedBox(
                      height: 18,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 190,
                      ),
                      child: Text(
                        'تأكيد كلمة المرور',
                        style: TextStyle(
                          color: Color(0xff1A2429),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: 280,
                      child: TextFormField(
                        cursorColor:  Color(0xff2A9D8F),
                        controller: passwordVerifyingController,
                        obscureText: _obscureConfirmPassword,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Color(0xff1A2429),
                          fontSize: 16,
                          fontFamily: 'Tajawal',
                        ),
                        decoration:InputDecoration(
                          hintText: 'تأكيد كلمة المرور',
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
                                _obscureConfirmPassword = !_obscureConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _obscureConfirmPassword
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

                          if (value != passwordController.text) {
                            return 'كلمات المرور غير متطابقة';
                          }

                          return null;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Consumer<NewPasswordProvider>(
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
                          text: 'تعديل كلمة المرور',
                          onPressed: () async {
                            FocusScope.of(context).unfocus();

                            if (!_formKey.currentState!.validate()) {
                              return;
                            }

                            await authProvider.newPassword(
                              email: widget.email,
                              password1: passwordController.text,
                              password2:
                              passwordVerifyingController.text,
                            );

                            if (!mounted) {
                              return;
                            }

                            if (authProvider.isSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignInPage(),
                                ),
                              );
                            } else if (authProvider.errorMessage != null) {
                              MySnackBar.show(
                                context,
                                message: authProvider.errorMessage!,
                              );
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(
                      height: 70,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}