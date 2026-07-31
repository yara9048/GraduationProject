import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/sign_up_provider.dart';
import 'package:graduationprojct/features/auth/ui/widgets/sign_up_image_picker.dart';
import 'package:provider/provider.dart';

import '../../widgets/auth_pages_template.dart';
import '../../widgets/button_template.dart';
import '../../widgets/snack_bar.dart';
import '../../widgets/text_field_template.dart';
import '../sign_in/sign_in_page.dart';
import 'verify_email_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController firstNameController =
  TextEditingController();

  final TextEditingController secondNameController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController passwordVerifyingController =
  TextEditingController();

  final TextEditingController majorController =
  TextEditingController();

  bool isValidationActive = false;

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    secondNameController.dispose();
    passwordController.dispose();
    passwordVerifyingController.dispose();
    majorController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AuthPagesTemplate(
        text1: '!أهلاً بك ',
        size1: 13,
        size2: 13,
        text2:
        '.قم بإنشاء حسابك الآن لتبدأ رحلتك التعليمية معنا',
        child: SafeArea(
          child: SingleChildScrollView(
            keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 20,
                left: 0,
                top: 175,
                bottom: 30,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildNameFields(),
                    SizedBox(
                      height: isValidationActive ? 10 : 15,
                    ),
                    _buildEmailField(),
                    SizedBox(
                      height: isValidationActive ? 10 : 15,
                    ),
                    _buildMajorField(),
                    SizedBox(
                      height: isValidationActive ? 10 : 15,
                    ),
                    const SignUpImagePicker(),
                    SizedBox(
                      height: isValidationActive ? 10 : 15,
                    ),
                    _buildPasswordField(),
                    SizedBox(
                      height: isValidationActive ? 10 : 15,
                    ),
                    _buildPasswordConfirmationField(),
                    SizedBox(
                      height: isValidationActive ? 10 : 20,
                    ),
                    _buildRegisterButton(),
                    const SizedBox(height: 10),
                    _buildSignInLink(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNameFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'الكنية',
                style: TextStyle(
                  color: Color(0xff1A2429),
                  fontSize: 13,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: isValidationActive ? 0 : 5,
              ),
              TextFieldTemplate(
                controller: secondNameController,
                size2: 13,
                size: 13,
                hint: 'كنيتك',
                icon: Icons.person_outline,
                validator: (value) {
                  if (!isValidationActive) {
                    return null;
                  }

                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'الحقل فارغ';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'الاسم',
                style: TextStyle(
                  color: Color(0xff1A2429),
                  fontSize: 13,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: isValidationActive ? 0 : 5,
              ),
              TextFieldTemplate(
                controller: firstNameController,
                size2: 13,
                size: 13,
                hint: 'اسمك',
                icon: Icons.person,
                validator: (value) {
                  if (!isValidationActive) {
                    return null;
                  }

                  if (value == null ||
                      value.trim().isEmpty) {
                    return 'الحقل فارغ';
                  }

                  return null;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'البريد الالكتروني',
          style: TextStyle(
            color: Color(0xff1A2429),
            fontSize: 13,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        TextFieldTemplate(
          controller: emailController,
          size2: 17,
          size: 16,
          hint: 'بريدك الالكتروني',
          icon: Icons.email_outlined,
          validator: (value) {
            if (!isValidationActive) {
              return null;
            }

            if (value == null || value.trim().isEmpty) {
              return 'الحقل فارغ';
            }

            final RegExp emailRegex = RegExp(
              r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
            );

            if (!emailRegex.hasMatch(value.trim())) {
              return 'ادخل بريد الكتروني صالح';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMajorField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'الاختصاص',
          style: TextStyle(
            color: Color(0xff1A2429),
            fontSize: 13,
            fontFamily: 'Tajawal',
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        TextFieldTemplate(
          controller: majorController,
          size2: 17,
          size: 16,
          hint: 'تخصصك الأكاديمي',
          icon: Icons.school_outlined,
          validator: (value) {
            if (!isValidationActive) {
              return null;
            }

            if (value == null || value.trim().isEmpty) {
              return 'الحقل فارغ';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'كلمة المرور',
          style: TextStyle(
            color: Color(0xff1A2429),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 5),
        TextFieldTemplate(
          controller: passwordController,
          size2: 17,
          size: 16,
          hint: 'كلمة المرور',
          icon: Icons.remove_red_eye,
          validator: (value) {
            if (!isValidationActive) {
              return null;
            }

            if (value == null || value.isEmpty) {
              return 'الحقل فارغ';
            }

            if (value.length < 6) {
              return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordConfirmationField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text(
          'تأكيد كلمة المرور',
          style: TextStyle(
            color: Color(0xff1A2429),
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontFamily: 'Tajawal',
          ),
        ),
        const SizedBox(height: 5),
        TextFieldTemplate(
          controller: passwordVerifyingController,
          size2: 17,
          size: 16,
          hint: 'تأكيد كلمة المرور',
          icon: Icons.remove_red_eye,
          validator: (value) {
            if (!isValidationActive) {
              return null;
            }

            if (value == null || value.isEmpty) {
              return 'الحقل فارغ';
            }

            if (value != passwordController.text) {
              return 'كلمات المرور غير متطابقة';
            }

            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Consumer<SignUpProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const CircularProgressIndicator(
            color: Color(0xff2A9D8F),
          );
        }

        return ButtonTemplate(
          text: 'انشاء حساب',
          onPressed: () async {
            FocusScope.of(context).unfocus();

            setState(() {
              isValidationActive = true;
            });

            final bool isFormValid =
                _formKey.currentState?.validate() ?? false;

            if (!isFormValid) {
              return;
            }

            if (authProvider.selectedImage == null) {
              MySnackBar.show(
                context,
                message: 'يرجى اختيار صورة شخصية',
              );
              return;
            }

            await authProvider.register(
              email: emailController.text,
              password1: passwordController.text,
              password2:
              passwordVerifyingController.text,
              firstName: firstNameController.text,
              lastName: secondNameController.text,
              major: majorController.text,
            );

            if (!mounted) {
              return;
            }

            if (authProvider.isSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => VerifyEmailPage(
                    email: emailController.text.trim(),
                  ),
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
    );
  }

  Widget _buildSignInLink() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13,
          fontFamily: 'Tajawal',
        ),
        children: [
          const TextSpan(
            text: 'لديك حساب مسبقاً؟ ',
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Tajawal',
              fontSize: 13,
            ),
          ),
          TextSpan(
            text: 'تسجيل الدخول',
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
                    builder: (_) => const SignInPage(),
                  ),
                );
              },
          ),
        ],
      ),
    );
  }
}