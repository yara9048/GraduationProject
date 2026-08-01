import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/sign_up_provider.dart';
import 'package:provider/provider.dart';

class SignUpImagePicker extends StatelessWidget {
  const SignUpImagePicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProvider>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: provider.isPickingImage
              ? null
              : provider.pickImage,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            width: 280,
            height: 60,
            constraints: const BoxConstraints(
              minHeight: 52,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                width: 2,
                color: Colors.black26
            ),),
            child: provider.isPickingImage
                ? const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xff2A9D8F),
                ),
              ),
            )
                : Row(
              textDirection: TextDirection.rtl,
              children: [
                const Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Color(0xff2A9D8F),
                  size: 23,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    provider.selectedImageName ??
                        'اضغط لاختيار صورة',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 13,
                      color:
                      provider.selectedImage == null
                          ? Colors.grey
                          : const Color(0xff1A2429),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}