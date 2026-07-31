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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'الصورة الشخصية',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Color(0xff1A2429),
                fontSize: 13,
                fontFamily: 'Tajawal',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            InkWell(
              onTap: provider.isPickingImage
                  ? null
                  : provider.pickImage,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(
                  minHeight: 52,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: provider.selectedImage == null
                        ? const Color(0xffD9D9D9)
                        : const Color(0xff2A9D8F),
                  ),
                ),
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
            ),
            if (provider.selectedImage != null) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: provider.removeSelectedImage,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xffFDECEC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.delete_outline,
                        size: 19,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(45),
                    child: Image.file(
                      provider.selectedImage!,
                      width: 75,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: const Icon(
                            Icons.broken_image_outlined,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}