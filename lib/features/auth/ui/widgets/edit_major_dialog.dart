import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/ui/widgets/snack_bar.dart';
import 'package:graduationprojct/features/home/providers/display_subjects_provider.dart';
import 'package:provider/provider.dart';

import '../../providers/edit_profile_provider.dart';
import 'button_template.dart';

class EditMajorDialog extends StatefulWidget {
  final String currentMajor;
  final Future<void> Function() onUpdated;

  const EditMajorDialog({
    super.key,
    required this.currentMajor,
    required this.onUpdated,
  });

  @override
  State<EditMajorDialog> createState() =>
      _EditMajorDialogState();
}

class _EditMajorDialogState
    extends State<EditMajorDialog> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  String? _selectedMajor;
  bool _initialMajorSet = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
        if (!mounted) return;

        final subjectsProvider =
        context.read<DisplaySubjectsProvider>();

        if (subjectsProvider.subjects.isEmpty) {
          await subjectsProvider.getSubjects();
        }

        if (!mounted) return;

        _setCurrentMajor(
          subjectsProvider,
        );
      },
    );
  }

  void _setCurrentMajor(
      DisplaySubjectsProvider subjectsProvider,
      ) {
    if (_initialMajorSet) {
      return;
    }

    final String normalizedCurrentMajor =
    widget.currentMajor
        .trim()
        .toLowerCase();

    String? matchedSlug;

    for (final subject
    in subjectsProvider.subjects) {
      final String slug =
      subject.categoryDetail.slug
          .trim()
          .toLowerCase();

      final String categoryName =
      subject.categoryDetail.name
          .trim()
          .toLowerCase();


      if (normalizedCurrentMajor == slug ||
          normalizedCurrentMajor ==
              categoryName) {
        matchedSlug =
            subject.categoryDetail.slug;

        break;
      }
    }

    if (!mounted) return;

    setState(() {
      _selectedMajor = matchedSlug;
      _initialMajorSet = true;
    });
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      hintText: 'الاختصاص',
      hintStyle: const TextStyle(
        fontFamily: 'Tajawal',
      ),
      contentPadding:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 15,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Colors.grey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xff2A9D8F),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xffE76F51),
        ),
      ),
      focusedErrorBorder:
      OutlineInputBorder(
        borderRadius:
        BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: Color(0xffE76F51),
          width: 2,
        ),
      ),
    );
  }

  Future<void> _submit(
      BuildContext dialogContext,
      ) async {
    final bool isValid =
        _formKey.currentState?.validate() ??
            false;

    if (!isValid ||
        _selectedMajor == null) {
      return;
    }

    final editProvider =
    context.read<EditProfileProvider>();

    await editProvider.editProfile(
      major: _selectedMajor,
    );

    if (!mounted) return;

    if (editProvider.isSuccess) {
      await widget.onUpdated();

      if (!mounted) return;

      Navigator.of(dialogContext).pop();
    } else if (editProvider.errorMessage !=
        null) {
      MySnackBar.show(
        context,
        message:
        editProvider.errorMessage!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final subjectsProvider =
    context.watch<
        DisplaySubjectsProvider>();

    /*
     * بعد انتهاء تحميل المواد نحدد
     * الاختصاص الحالي مرة واحدة.
     */
    if (!subjectsProvider.isLoading &&
        subjectsProvider
            .subjects.isNotEmpty &&
        !_initialMajorSet) {
      WidgetsBinding.instance
          .addPostFrameCallback(
            (_) {
          if (!mounted) return;

          _setCurrentMajor(
            subjectsProvider,
          );
        },
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20),
        ),
        title: const Center(
          child: Text(
            'تعديل الاختصاص',
            style: TextStyle(
              fontSize: 20,
              color: Color(0xff181C1F),
              fontFamily: 'Tajawal',
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ),
        content: Form(
          key: _formKey,
          child: _buildMajorField(
            subjectsProvider,
          ),
        ),
        actionsAlignment:
        MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: double.infinity,
            child:
            Consumer<EditProfileProvider>(
              builder: (
                  context,
                  editProvider,
                  child,
                  ) {
                if (editProvider.isLoading) {
                  return const Center(
                    child: SizedBox(
                      width: 28,
                      height: 28,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Color(
                          0xff2A9D8F,
                        ),
                      ),
                    ),
                  );
                }

                return ButtonTemplate(
                  text: 'تعديل',
                  onPressed:
                  subjectsProvider
                      .isLoading ||
                      subjectsProvider
                          .subjects
                          .isEmpty
                      ? null
                      : () {
                    _submit(
                      context,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMajorField(
      DisplaySubjectsProvider subjectsProvider,
      ) {
    if (subjectsProvider.isLoading) {
      return const SizedBox(
        height: 60,
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Color(0xff2A9D8F),
          ),
        ),
      );
    }

    if (subjectsProvider.errorMessage !=
        null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
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
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () async {
              await context
                  .read<
                  DisplaySubjectsProvider>()
                  .getSubjects();

              if (!mounted) return;

              _initialMajorSet = false;

              _setCurrentMajor(
                context.read<
                    DisplaySubjectsProvider>(),
              );
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
      );
    }

    if (subjectsProvider.subjects.isEmpty) {
      return const SizedBox(
        height: 60,
        child: Center(
          child: Text(
            'لا توجد اختصاصات متاحة',
            style: TextStyle(
              fontFamily: 'Tajawal',
              color: Colors.grey,
            ),
          ),
        ),
      );
    }
    final Map<String, dynamic>
    uniqueCategories = {};

    for (final subject
    in subjectsProvider.subjects) {
      final String slug =
      subject.categoryDetail.slug
          .trim();

      if (slug.isNotEmpty) {
        uniqueCategories[slug] =
            subject.categoryDetail;
      }
    }

    final categories =
    uniqueCategories.values.toList();

    final bool selectedValueExists =
        _selectedMajor != null &&
            uniqueCategories.containsKey(
              _selectedMajor,
            );

    return DropdownButtonFormField<String>(
      value: selectedValueExists
          ? _selectedMajor
          : null,
      dropdownColor: Colors.white,
      isExpanded: true,
      alignment:
      AlignmentDirectional.centerEnd,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: Colors.black45,
      ),
      decoration: _inputDecoration(),
      style: const TextStyle(
        color: Color(0xff1A2429),
        fontFamily: 'Tajawal',
        fontSize: 16,
      ),
      items: subjectsProvider.subjects.map(
            (subject) {
          final category =
              subject.categoryDetail;

          return DropdownMenuItem<String>(
            value: category.slug, // القيمة المرسلة للـ API
            child: Text(
              category.name, // الاسم الظاهر للمستخدم
              style: const TextStyle(
                fontFamily: 'Tajawal',
              ),
            ),
          );
        },
      ).toList(),
      onChanged: (value) {
        setState(() {
          _selectedMajor = value;
        });
      },
      validator: (value) {
        if (value == null ||
            value.isEmpty) {
          return 'الاختصاص مطلوب';
        }

        return null;
      },
    );
  }
}