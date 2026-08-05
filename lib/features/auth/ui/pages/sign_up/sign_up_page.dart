import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/sign_up_provider.dart';
import 'package:graduationprojct/features/auth/ui/widgets/sign_up_image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../home/providers/display_subjects_provider.dart';
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
  String? selectedMajor;
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

  bool isValidationActive = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context
          .read<DisplaySubjectsProvider>()
          .getSubjects();
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    firstNameController.dispose();
    secondNameController.dispose();
    passwordController.dispose();
    passwordVerifyingController.dispose();
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
                top: 140,
                bottom: 30,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                  Row(
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
                ),
                    SizedBox(
                      height: isValidationActive ? 10 : 15,
                    ),
                   Padding(
                     padding: const EdgeInsets.only(left: 250.0),
                     child: Text(
                            'البريد الالكتروني',
                            style: TextStyle(
                              color: Color(0xff1A2429),
                              fontSize: 13,
                              fontFamily: 'Tajawal',
                              fontWeight: FontWeight.w600,
                            ),
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
                    SizedBox(
                      height: isValidationActive ? 10 : 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 275.0),
                      child: Text(
                        'الاختصاص',
                        style: TextStyle(
                          color: Color(0xff1A2429),
                          fontSize: 13,
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Consumer<DisplaySubjectsProvider>(
                      builder: (
                          context,
                          subjectsProvider,
                          child,
                          ) {
                        final subjects =
                            subjectsProvider.subjects;

                        if (subjectsProvider.isLoading) {
                          return const SizedBox(
                            width: 280,
                            height: 60,
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: Color(0xff2A9D8F),
                              ),
                            ),
                          );
                        }

                        if (subjectsProvider.errorMessage != null) {
                          return SizedBox(
                            width: 280,
                            child: Column(
                              children: [
                                Text(
                                  subjectsProvider.errorMessage ??
                                      'تعذر تحميل الاختصاصات',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontFamily: 'Tajawal',
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                TextButton.icon(
                                  onPressed: () {
                                    context
                                        .read<DisplaySubjectsProvider>()
                                        .getSubjects();
                                  },
                                  icon: const Icon(
                                    Icons.refresh_rounded,
                                    color: Color(0xff2A9D8F),
                                  ),
                                  label: const Text(
                                    'إعادة المحاولة',
                                    style: TextStyle(
                                      color: Color(0xff2A9D8F),
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return SizedBox(
                          width: 280,
                          child: DropdownButtonFormField<String>(
                            value: selectedMajor,
                            dropdownColor: Colors.white,
                            alignment:
                            AlignmentDirectional.centerEnd,
                            isExpanded: true,
                            decoration: InputDecoration(
                              hintText: 'تخصصك الأكاديمي',
                              hintStyle: const TextStyle(
                                color: Color(0xffD1D9D9),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                fontFamily: 'Tajawal',
                              ),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(22),
                                borderSide: const BorderSide(
                                  color: Colors.black26,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(22),
                                borderSide: const BorderSide(
                                  color: Colors.black26,
                                  width: 2,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(22),
                                borderSide: const BorderSide(
                                  color: Color(0xff2A9D8F),
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(22),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder:
                              OutlineInputBorder(
                                borderRadius:
                                BorderRadius.circular(22),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                              ),
                            ),
                            icon: const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 22,
                              color: Colors.black26,
                            ),
                            style: const TextStyle(
                              color: Color(0xff1A2429),
                              fontSize: 15,
                              fontFamily: 'Tajawal',
                            ),

                            /*
         * نعرض category_detail.name
         * ونحفظ category_detail.slug.
         */
                            items: subjects.map((subject) {
                              return DropdownMenuItem<String>(
                                value: subject.categoryDetail.slug,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    subject.categoryDetail.name,
                                    textDirection: TextDirection.ltr,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),

                            onChanged: (value) {
                              setState(() {
                                selectedMajor = value;
                              });
                            },
                            validator: (value) {
                              if (!isValidationActive) {
                                return null;
                              }

                              if (value == null ||
                                  value.isEmpty) {
                                return 'يرجى اختيار الاختصاص';
                              }

                              return null;
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: isValidationActive ? 10 : 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 239),
                      child: const Text(
                        'الصورة الشخصية',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color(0xff1A2429),
                          fontSize: 13,
                          fontFamily: 'Tajawal',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const SignUpImagePicker(),
                    SizedBox(
                      height: isValidationActive ? 10 : 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 275.0),
                      child: Text(
                            'كلمة المرور',
                            style: TextStyle(
                              color: Color(0xff1A2429),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Tajawal',
                            ),
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
                    SizedBox(
                      height: isValidationActive ? 10 : 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 240.0),
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
                    SizedBox(
                      height: isValidationActive ? 10 : 20,
                    ),
                    Consumer<SignUpProvider>(
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
                              major: selectedMajor!,
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
                    ),
                    const SizedBox(height: 10),
                    RichText(
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
                    ),
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




}