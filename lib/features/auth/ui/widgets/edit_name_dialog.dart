import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/ui/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

import '../../providers/edit_profile_provider.dart';
import 'button_template.dart';


class EditNameDialog extends StatefulWidget {
  final String firstName;
  final String lastName;
  final Future<void> Function() onUpdated;

  const EditNameDialog({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.onUpdated,
  });

  @override
  State<EditNameDialog> createState() =>
      _EditNameDialogState();
}

class _EditNameDialogState
    extends State<EditNameDialog> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  late final TextEditingController
  _firstNameController;

  late final TextEditingController
  _lastNameController;

  @override
  void initState() {
    super.initState();

    _firstNameController =
        TextEditingController(
          text: widget.firstName,
        );

    _lastNameController =
        TextEditingController(
          text: widget.lastName,
        );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();

    super.dispose();
  }

  InputDecoration _inputDecoration({
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
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

    if (!isValid) {
      return;
    }

    final editProvider =
    context.read<
        EditProfileProvider>();

    await editProvider.editProfile(
      firstName:
      _firstNameController.text.trim(),
      secondName:
      _lastNameController.text.trim(),
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
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(20),
        ),
        title: const Center(
          child: Text(
            'تعديل الاسم',
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
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller:
                  _firstNameController,
                  cursorColor:
                  const Color(
                    0xff2A9D8F,
                  ),
                  textInputAction:
                  TextInputAction.next,
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'الاسم مطلوب';
                    }

                    return null;
                  },
                  decoration:
                  _inputDecoration(
                    hintText: 'الاسم',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller:
                  _lastNameController,
                  cursorColor:
                  const Color(
                    0xff2A9D8F,
                  ),
                  validator: (value) {
                    if (value == null ||
                        value.trim().isEmpty) {
                      return 'الكنية مطلوبة';
                    }

                    return null;
                  },
                  decoration:
                  _inputDecoration(
                    hintText: 'الكنية',
                  ),
                ),
              ),
            ],
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