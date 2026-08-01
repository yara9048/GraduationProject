import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/ui/widgets/snack_bar.dart';
import 'package:provider/provider.dart';
import '../../providers/edit_profile_provider.dart';
import 'button_template.dart';

class EditMajorDialog
    extends StatefulWidget {
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

  static const List<String>
  _allowedMajors = [
    'ai',
    'cs',
    'general',
    'it',
  ];

  @override
  void initState() {
    super.initState();

    final String normalizedMajor =
    widget.currentMajor
        .trim()
        .toLowerCase();

    /*
     * يجب أن تكون قيمة Dropdown
     * موجودة ضمن العناصر.
     */
    if (_allowedMajors.contains(
      normalizedMajor,
    )) {
      _selectedMajor =
          normalizedMajor;
    } else {
      _selectedMajor = null;
    }
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      hintText: 'الاختصاص',
      hintStyle: const TextStyle(
        fontFamily: 'Tajawal',
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
    context.read<
        EditProfileProvider>();

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
              fontSize: 26,
              color: Color(0xff181C1F),
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Form(
          key: _formKey,
          child:
          DropdownButtonFormField<
              String>(
            value: _selectedMajor,
            dropdownColor: Colors.white,
            isExpanded: true,
            alignment:
            AlignmentDirectional
                .centerEnd,
            icon: const Icon(
              Icons
                  .keyboard_arrow_down_rounded,
              color: Colors.black45,
            ),
            decoration:
            _inputDecoration(),
            style: const TextStyle(
              color: Color(0xff1A2429),
              fontFamily: 'Tajawal',
              fontSize: 16,
            ),
            items: const [
              DropdownMenuItem(
                value: 'ai',
                child: Text(
                  'AI',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'cs',
                child: Text(
                  'CS',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'general',
                child: Text(
                  'General',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
              DropdownMenuItem(
                value: 'it',
                child: Text(
                  'IT',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                  ),
                ),
              ),
            ],
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
                        color:
                        Color(0xff2A9D8F),
                      ),
                    ),
                  );
                }

                return ButtonTemplate(
                  text: 'تعديل',
                  onPressed: () {
                    _submit(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}