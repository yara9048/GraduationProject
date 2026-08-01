import 'package:flutter/material.dart';
import 'package:graduationprojct/features/auth/providers/edit_profile_provider.dart';
import 'package:graduationprojct/features/auth/providers/profile_provider.dart';
import 'package:provider/provider.dart';

import 'snack_bar.dart';

class ProfileImagePicker extends StatelessWidget {
  final String? serverImageUrl;

  const ProfileImagePicker({
    super.key,
    this.serverImageUrl,
  });

  static const String _serverBaseUrl =
      'http://144.91.84.194:8459';

  @override
  Widget build(BuildContext context) {
    return Consumer<EditProfileProvider>(
      builder: (
          context,
          editProfileProvider,
          child,
          ) {
        final bool isImageLoading =
            editProfileProvider.isPickingImage ||
                editProfileProvider.isLoading;

        return Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xff2A9D8F),
                border: Border.all(
                  color: const Color(0xff2A9D8F),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: _buildProfileImage(
                  editProfileProvider:
                  editProfileProvider,
                ),
              ),
            ),
            InkWell(
              onTap: isImageLoading
                  ? null
                  : () async {
                /*
                       * 1. اختيار الصورة من الجهاز.
                       * ستظهر فورًا لأن Provider يعمل
                       * notifyListeners بعد اختيارها.
                       */
                await editProfileProvider.pickImage();

                if (!context.mounted) {
                  return;
                }

                /*
                       * المستخدم أغلق File Picker
                       * أو حدث خطأ أثناء الاختيار.
                       */
                if (editProfileProvider.selectedImage ==
                    null) {
                  if (editProfileProvider.errorMessage !=
                      null) {
                    MySnackBar.show(
                      context,
                      message: editProfileProvider
                          .errorMessage!,
                    );
                  }

                  return;
                }

                /*
                       * 2. رفع الصورة المحلية إلى API.
                       */
                await editProfileProvider.editImage();

                if (!context.mounted) {
                  return;
                }

                if (!editProfileProvider.isSuccess) {
                  if (editProfileProvider.errorMessage !=
                      null) {
                    MySnackBar.show(
                      context,
                      message: editProfileProvider
                          .errorMessage!,
                    );
                  }

                  /*
                         * عند فشل الرفع لا نحذف الصورة
                         * المحلية حتى تبقى ظاهرة ويمكن
                         * إعادة المحاولة.
                         */
                  return;
                }

                /*
                       * 3. إعادة جلب البروفايل من API
                       * للحصول على رابط الصورة الجديد.
                       */
                final ProfileProvider profileProvider =
                context.read<ProfileProvider>();

                await profileProvider.getProfile();

                if (!context.mounted) {
                  return;
                }

                /*
                       * إذا فشل جلب بيانات البروفايل،
                       * لا نحذف الصورة المحلية.
                       */
                if (!profileProvider.isSuccess ||
                    profileProvider.profile == null) {
                  MySnackBar.show(
                    context,
                    message:
                    profileProvider.errorMessage ??
                        'تم رفع الصورة، لكن تعذر تحديث بيانات البروفايل',
                  );

                  return;
                }

                /*
                       * 4. بعد التأكد أن البروفايل الجديد
                       * وصل من API، نحذف الصورة المحلية.
                       *
                       * بعدها يعيد Consumer البناء ويعرض
                       * serverImageUrl القادم من Profile API.
                       */
                editProfileProvider
                    .removeSelectedImage();

                if (!context.mounted) {
                  return;
                }

                MySnackBar.show(
                  context,
                  message:
                  'تم تعديل الصورة بنجاح',
                );
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xff2A9D8F),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2,
                  ),
                ),
                child: isImageLoading
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child:
                  CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                    : const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileImage({
    required EditProfileProvider
    editProfileProvider,
  }) {
    /*
     * طالما توجد صورة مختارة محليًا،
     * نعرضها فورًا أثناء الرفع.
     */
    if (editProfileProvider.selectedImage != null) {
      return Image.file(
        editProfileProvider.selectedImage!,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return _defaultProfileImage();
        },
      );
    }

    /*
     * بعد نجاح الرفع وجلب البروفايل وحذف
     * selectedImage، نعرض الصورة القادمة من API.
     */
    if (_hasValidServerImage(serverImageUrl)) {
      final String imageUrl =
      _getFullImageUrl(serverImageUrl!);

      /*
       * نضيف قيمة زمنية لمنع Image.network
       * من عرض الصورة القديمة من الـ cache.
       */
      final String cacheBustedUrl =
      _addCacheBuster(imageUrl);

      return Image.network(
        cacheBustedUrl,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        loadingBuilder: (
            context,
            child,
            loadingProgress,
            ) {
          if (loadingProgress == null) {
            return child;
          }

          return const ColoredBox(
            color: Color(0xff2A9D8F),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
        errorBuilder: (
            context,
            error,
            stackTrace,
            ) {
          return _defaultProfileImage();
        },
      );
    }

    return _defaultProfileImage();
  }

  bool _hasValidServerImage(
      String? imageUrl,
      ) {
    if (imageUrl == null) {
      return false;
    }

    final String cleanedUrl = imageUrl.trim();

    return cleanedUrl.isNotEmpty &&
        cleanedUrl.toLowerCase() != 'null';
  }

  Widget _defaultProfileImage() {
    return const ColoredBox(
      color: Color(0xff2A9D8F),
      child: Center(
        child: Icon(
          Icons.person,
          color: Colors.white,
          size: 50,
        ),
      ),
    );
  }

  String _getFullImageUrl(
      String imageUrl,
      ) {
    final String cleanedUrl = imageUrl.trim();

    if (cleanedUrl.startsWith('http://') ||
        cleanedUrl.startsWith('https://')) {
      return cleanedUrl;
    }

    if (cleanedUrl.startsWith('/')) {
      return '$_serverBaseUrl$cleanedUrl';
    }

    return '$_serverBaseUrl/$cleanedUrl';
  }

  String _addCacheBuster(
      String imageUrl,
      ) {
    final int timestamp =
        DateTime.now().millisecondsSinceEpoch;

    if (imageUrl.contains('?')) {
      return '$imageUrl&t=$timestamp';
    }

    return '$imageUrl?t=$timestamp';
  }
}