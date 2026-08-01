import 'package:flutter/material.dart';

class SafeNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final String placeholderPath;
  final BoxFit fit;
  final double? width;
  final double? height;

  const SafeNetworkImage({
    super.key,
    required this.imageUrl,
    this.placeholderPath =
    'assets/Images/Gemini_Generated_Image_hy81hehy81hehy81 1.png',
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final String? cleanedUrl = imageUrl?.trim();

    if (!_isValidUrl(cleanedUrl)) {
      return _buildPlaceholder();
    }

    return Image.network(
      cleanedUrl!,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (
          context,
          error,
          stackTrace,
          ) {
        return _buildPlaceholder();
      },
      loadingBuilder: (
          context,
          child,
          loadingProgress,
          ) {
        if (loadingProgress == null) {
          return child;
        }

        return SizedBox(
          width: width,
          height: height,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }

  bool _isValidUrl(String? value) {
    if (value == null ||
        value.isEmpty ||
        value.toLowerCase() == 'null') {
      return false;
    }

    final Uri? uri = Uri.tryParse(value);

    if (uri == null) {
      return false;
    }

    return uri.hasScheme &&
        uri.hasAuthority &&
        (uri.scheme == 'http' ||
            uri.scheme == 'https');
  }

  Widget _buildPlaceholder() {
    return Image.asset(
      placeholderPath,
      width: width,
      height: height,
      fit: fit,
    );
  }
}