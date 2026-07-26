import 'package:flutter/material.dart';

class MindMapCard extends StatefulWidget {
  final String svgUrl;

  const MindMapCard({
    super.key,
    required this.svgUrl,
  });

  @override
  State<MindMapCard> createState() => _MindMapCardState();
}

class _MindMapCardState extends State<MindMapCard> {
  late final TransformationController _transformationController;

  bool _initialScaleApplied = false;

  @override
  void initState() {
    super.initState();

    _transformationController = TransformationController();
  }

  void _applyInitialScale() {
    if (_initialScaleApplied || !mounted) {
      return;
    }

    _initialScaleApplied = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _transformationController.value = Matrix4.identity()
        ..translate(-300.0, -300.0)
        ..scale(2.5);
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String imageUrl = widget.svgUrl
        .trim()
        .replaceFirst('/svg/', '/png/');

    final Uri? uri = Uri.tryParse(imageUrl);

    final bool isValidUrl =
        uri != null &&
            uri.hasScheme &&
            (uri.scheme == 'http' || uri.scheme == 'https');

    if (!isValidUrl) {
      return const Center(
        child: Text(
          'رابط الخريطة الذهنية غير صالح',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 16,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final Size screenSize = MediaQuery.sizeOf(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Card(
        color: Colors.white,
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: SizedBox(
          width: double.infinity,
          height: screenSize.height * 0.65,
          child: InteractiveViewer(
            transformationController: _transformationController,

            constrained: false,

            minScale: 0.3,
            maxScale: 10,

            panEnabled: true,
            scaleEnabled: true,

            boundaryMargin: const EdgeInsets.all(1000),

            child: SizedBox(
              width: screenSize.width * 0.8,
              height: screenSize.height * 0.8,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                alignment: Alignment.center,

                frameBuilder: (
                    context,
                    child,
                    frame,
                    wasSynchronouslyLoaded,
                    ) {
                  if (wasSynchronouslyLoaded || frame != null) {
                    _applyInitialScale();
                  }

                  return child;
                },

                loadingBuilder: (
                    context,
                    child,
                    loadingProgress,
                    ) {
                  if (loadingProgress == null) {
                    return child;
                  }

                  return const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color(0xff2A9D8F),
                    ),
                  );
                },

                errorBuilder: (
                    context,
                    error,
                    stackTrace,
                    ) {
                  debugPrint('Mind map image error: $error');

                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.broken_image_outlined,
                          size: 55,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'تعذر تحميل الخريطة الذهنية',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}