import 'dart:math' as math;

import 'package:flutter/material.dart';

class MindMapCard extends StatefulWidget {
  final String svgUrl;

  /// true  = المستخدم يتفاعل مع الخريطة
  /// false = انتهى التفاعل
  ///
  /// استخدمها بالصفحة الأب لإيقاف Scroll الصفحة.
  final ValueChanged<bool>? onInteractionChanged;

  const MindMapCard({
    super.key,
    required this.svgUrl,
    this.onInteractionChanged,
  });

  @override
  State<MindMapCard> createState() => _MindMapCardState();
}

class _MindMapCardState extends State<MindMapCard>
    with SingleTickerProviderStateMixin {
  late final TransformationController
  _transformationController;

  late final AnimationController
  _animationController;

  Animation<Matrix4>? _matrixAnimation;

  Size? _imageSize;
  Size? _lastViewportSize;

  bool _isLoading = true;
  bool _hasError = false;
  bool _initialTransformApplied = false;

  double _initialScale = 1.0;

  Offset? _doubleTapPosition;

  /// عدد الأصابع الموجودة حاليًا فوق الخريطة.
  /// مهم جدًا حتى لا نعيد Scroll الصفحة
  /// عند رفع إصبع واحد أثناء pinch zoom.
  int _activePointers = 0;

  static const double _minScale = 0.1;
  static const double _maxScale = 6.0;

  String get _imageUrl {
    return widget.svgUrl
        .trim()
        .replaceFirst(
      '/svg/',
      '/png/',
    );
  }

  bool get _isValidUrl {
    final uri = Uri.tryParse(
      _imageUrl,
    );

    return uri != null &&
        uri.hasScheme &&
        (
            uri.scheme == 'http' ||
                uri.scheme == 'https'
        );
  }

  @override
  void initState() {
    super.initState();

    _transformationController =
        TransformationController();

    _animationController =
        AnimationController(
          vsync: this,
          duration:
          const Duration(
            milliseconds: 220,
          ),
        );

    _animationController.addListener(
          () {
        final animation =
            _matrixAnimation;

        if (animation != null) {
          _transformationController
              .value =
              animation.value;
        }
      },
    );

    _loadImageInfo();
  }

  @override
  void didUpdateWidget(
      covariant MindMapCard oldWidget,
      ) {
    super.didUpdateWidget(
      oldWidget,
    );

    if (oldWidget.svgUrl !=
        widget.svgUrl) {
      _imageSize = null;

      _lastViewportSize = null;

      _initialTransformApplied =
      false;

      _isLoading = true;

      _hasError = false;

      _activePointers = 0;

      _transformationController
          .value =
          Matrix4.identity();

      _loadImageInfo();
    }
  }

  // ============================================================
  // تحميل معلومات الصورة
  // ============================================================

  void _loadImageInfo() {
    if (!_isValidUrl) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }

      return;
    }

    final requestedUrl =
        _imageUrl;

    final provider =
    NetworkImage(
      requestedUrl,
    );

    final stream =
    provider.resolve(
      const ImageConfiguration(),
    );

    late final ImageStreamListener
    listener;

    listener =
        ImageStreamListener(
              (
              ImageInfo info,
              bool _,
              ) {
            stream.removeListener(
              listener,
            );

            if (!mounted ||
                requestedUrl !=
                    _imageUrl) {
              return;
            }

            setState(() {
              _imageSize = Size(
                info.image.width
                    .toDouble(),
                info.image.height
                    .toDouble(),
              );

              _isLoading = false;

              _hasError = false;

              _initialTransformApplied =
              false;
            });
          },

          onError: (
              Object error,
              StackTrace? stackTrace,
              ) {
            stream.removeListener(
              listener,
            );

            if (!mounted ||
                requestedUrl !=
                    _imageUrl) {
              return;
            }

            debugPrint(
              'Mind map image error: $error',
            );

            setState(() {
              _isLoading = false;
              _hasError = true;
            });
          },
        );

    stream.addListener(
      listener,
    );
  }

  // ============================================================
  // Pointer Interaction
  // إيقاف Scroll الصفحة أثناء لمس الخريطة
  // ============================================================

  void _handlePointerDown(
      PointerDownEvent event,
      ) {
    _activePointers++;

    if (_activePointers == 1) {
      widget
          .onInteractionChanged
          ?.call(true);
    }
  }

  void _handlePointerUp(
      PointerUpEvent event,
      ) {
    _activePointers =
        math.max(
          0,
          _activePointers - 1,
        );

    if (_activePointers == 0) {
      widget
          .onInteractionChanged
          ?.call(false);
    }
  }

  void _handlePointerCancel(
      PointerCancelEvent event,
      ) {
    _activePointers =
        math.max(
          0,
          _activePointers - 1,
        );

    if (_activePointers == 0) {
      widget
          .onInteractionChanged
          ?.call(false);
    }
  }

  // ============================================================
  // Initial Fit
  // ============================================================

  void _scheduleInitialTransform(
      Size viewportSize,
      ) {
    if (_imageSize == null) {
      return;
    }

    final viewportChanged =
        _lastViewportSize !=
            viewportSize;

    if (_initialTransformApplied &&
        !viewportChanged) {
      return;
    }

    _initialTransformApplied =
    true;

    _lastViewportSize =
        viewportSize;

    WidgetsBinding.instance
        .addPostFrameCallback(
          (_) {
        if (!mounted ||
            _imageSize == null) {
          return;
        }

        final matrix =
        _createFitMatrix(
          viewportSize,
        );

        _transformationController
            .value =
            matrix;
      },
    );
  }

  Matrix4 _createFitMatrix(
      Size viewportSize,
      ) {
    final imageSize =
    _imageSize!;

    const padding = 28.0;

    final availableWidth =
    math.max(
      viewportSize.width -
          (padding * 2),
      1.0,
    );

    final availableHeight =
    math.max(
      viewportSize.height -
          (padding * 2),
      1.0,
    );

    final scaleX =
        availableWidth /
            imageSize.width;

    final scaleY =
        availableHeight /
            imageSize.height;

    double scale =
    math.min(
      scaleX,
      scaleY,
    );

    scale =
        scale.clamp(
          _minScale,
          1.5,
        );

    _initialScale =
        scale;

    final scaledWidth =
        imageSize.width *
            scale;

    final scaledHeight =
        imageSize.height *
            scale;

    final dx =
        (
            viewportSize.width -
                scaledWidth
        ) /
            2;

    final dy =
        (
            viewportSize.height -
                scaledHeight
        ) /
            2;

    return Matrix4.identity()
      ..translate(
        dx,
        dy,
      )
      ..scale(
        scale,
      );
  }

  // ============================================================
  // Animation
  // ============================================================

  void _animateTo(
      Matrix4 target,
      ) {
    _animationController.stop();

    _matrixAnimation =
        Matrix4Tween(
          begin:
          _transformationController
              .value
              .clone(),

          end: target,
        ).animate(
          CurvedAnimation(
            parent:
            _animationController,

            curve:
            Curves.easeOutCubic,
          ),
        );

    _animationController
        .forward(
      from: 0,
    );
  }

  // ============================================================
  // Reset
  // ============================================================

  void _resetView(
      Size viewportSize,
      ) {
    if (_imageSize == null) {
      return;
    }

    _animateTo(
      _createFitMatrix(
        viewportSize,
      ),
    );
  }

  // ============================================================
  // Zoom Buttons
  // ============================================================

  void _zoomBy(
      double factor,
      Size viewportSize,
      ) {
    final currentMatrix =
        _transformationController
            .value;

    final currentScale =
    currentMatrix
        .getMaxScaleOnAxis();

    final targetScale =
    (
        currentScale *
            factor
    )
        .clamp(
      _minScale,
      _maxScale,
    )
        .toDouble();

    final center =
    Offset(
      viewportSize.width /
          2,
      viewportSize.height /
          2,
    );

    _zoomAroundPoint(
      center,
      targetScale,
    );
  }

  void _zoomAroundPoint(
      Offset point,
      double targetScale,
      ) {
    final scenePoint =
    _transformationController
        .toScene(
      point,
    );

    final dx =
        point.dx -
            (
                scenePoint.dx *
                    targetScale
            );

    final dy =
        point.dy -
            (
                scenePoint.dy *
                    targetScale
            );

    final matrix =
    Matrix4.identity()
      ..translate(
        dx,
        dy,
      )
      ..scale(
        targetScale,
      );

    _animateTo(
      matrix,
    );
  }

  // ============================================================
  // Double Tap
  // ============================================================

  void _handleDoubleTap() {
    final position =
        _doubleTapPosition;

    if (position == null) {
      return;
    }

    final currentScale =
    _transformationController
        .value
        .getMaxScaleOnAxis();

    // إذا الخريطة مكبرة بشكل واضح
    // رجعها للوضع الكامل
    if (currentScale >
        _initialScale * 1.7) {
      if (_lastViewportSize !=
          null) {
        _resetView(
          _lastViewportSize!,
        );
      }

      return;
    }

    // غير ذلك:
    // Zoom على المكان الذي ضغط عليه المستخدم
    final targetScale =
    math.min(
      _initialScale * 2.5,
      _maxScale,
    );

    _zoomAroundPoint(
      position,
      targetScale,
    );
  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {
    // احتياط:
    // إذا خرج المستخدم من الصفحة أثناء لمس الخريطة
    if (_activePointers > 0) {
      widget
          .onInteractionChanged
          ?.call(false);
    }

    _animationController
        .dispose();

    _transformationController
        .dispose();

    super.dispose();
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    if (!_isValidUrl) {
      return const Center(
        child: Text(
          'رابط الخريطة الذهنية غير صالح',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 16,
            color: Colors.red,
            fontWeight:
            FontWeight.bold,
          ),
        ),
      );
    }

    final screenSize =
    MediaQuery.sizeOf(
      context,
    );

    return Padding(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 10,
      ),

      child: Card(
        color:
        const Color(
          0xffFAFCFC,
        ),

        elevation: 3,

        clipBehavior:
        Clip.antiAlias,

        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(
            22,
          ),
        ),

        child: SizedBox(
          width:
          double.infinity,

          height:
          screenSize.height *
              0.65,

          child:
          _buildContent(),
        ),
      ),
    );
  }

  // ============================================================
  // Content
  // ============================================================

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize:
          MainAxisSize.min,

          children: [
            CircularProgressIndicator(
              strokeWidth: 3,
              color:
              Color(
                0xff2A9D8F,
              ),
            ),

            SizedBox(
              height: 14,
            ),

            Text(
              'جاري تحميل الخريطة الذهنية...',
              style: TextStyle(
                fontFamily:
                'Tajawal',

                fontSize: 14,

                color:
                Color(
                  0xff6C7A7A,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_hasError ||
        _imageSize == null) {
      return const Center(
        child: Column(
          mainAxisSize:
          MainAxisSize.min,

          children: [
            Icon(
              Icons
                  .broken_image_outlined,

              size: 55,

              color:
              Colors.grey,
            ),

            SizedBox(
              height: 10,
            ),

            Text(
              'تعذر تحميل الخريطة الذهنية',

              style: TextStyle(
                fontFamily:
                'Tajawal',

                fontWeight:
                FontWeight.bold,

                color:
                Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (
          context,
          constraints,
          ) {
        final viewportSize =
        Size(
          constraints.maxWidth,
          constraints.maxHeight,
        );

        _scheduleInitialTransform(
          viewportSize,
        );

        return Stack(
          children: [
            // ==================================================
            // MindMap Interactive Area
            // ==================================================

            Positioned.fill(
              child: Listener(
                behavior:
                HitTestBehavior
                    .opaque,

                onPointerDown:
                _handlePointerDown,

                onPointerUp:
                _handlePointerUp,

                onPointerCancel:
                _handlePointerCancel,

                child:
                GestureDetector(
                  behavior:
                  HitTestBehavior
                      .opaque,

                  onDoubleTapDown:
                      (
                      details,
                      ) {
                    _doubleTapPosition =
                        details
                            .localPosition;
                  },

                  onDoubleTap:
                  _handleDoubleTap,

                  child:
                  InteractiveViewer(
                    transformationController:
                    _transformationController,

                    constrained:
                    false,

                    minScale:
                    _minScale,

                    maxScale:
                    _maxScale,

                    panEnabled:
                    true,

                    scaleEnabled:
                    true,

                    panAxis:
                    PanAxis.free,

                    boundaryMargin:
                    EdgeInsets
                        .all(
                      math.max(
                        viewportSize
                            .width,

                        viewportSize
                            .height,
                      ) *
                          1.5,
                    ),

                    interactionEndFrictionCoefficient:
                    0.0000135,

                    trackpadScrollCausesScale:
                    true,

                    scaleFactor:
                    180,

                    child:
                    SizedBox(
                      width:
                      _imageSize!
                          .width,

                      height:
                      _imageSize!
                          .height,

                      child:
                      Image.network(
                        _imageUrl,

                        fit:
                        BoxFit
                            .fill,

                        filterQuality:
                        FilterQuality
                            .high,

                        errorBuilder:
                            (
                            context,
                            error,
                            stackTrace,
                            ) {
                          return const Center(
                            child:
                            Column(
                              mainAxisSize:
                              MainAxisSize
                                  .min,

                              children: [
                                Icon(
                                  Icons
                                      .broken_image_outlined,

                                  size:
                                  50,

                                  color:
                                  Colors
                                      .grey,
                                ),

                                SizedBox(
                                  height:
                                  8,
                                ),

                                Text(
                                  'تعذر عرض الخريطة',

                                  style:
                                  TextStyle(
                                    fontFamily:
                                    'Tajawal',

                                    color:
                                    Colors.grey,
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
            ),

            // ==================================================
            // Zoom Controls
            // ==================================================

            Positioned(
              top: 12,
              left: 12,

              child:
              _ZoomControls(
                onZoomIn: () {
                  _zoomBy(
                    1.35,
                    viewportSize,
                  );
                },

                onZoomOut: () {
                  _zoomBy(
                    0.75,
                    viewportSize,
                  );
                },

                onReset: () {
                  _resetView(
                    viewportSize,
                  );
                },
              ),
            ),

            // ==================================================
            // Hint
            // ==================================================

            Positioned(
              bottom: 12,
              left: 20,
              right: 20,

              child:
              IgnorePointer(
                child: Center(
                  child:
                  Container(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal:
                      14,

                      vertical:
                      7,
                    ),

                    decoration:
                    BoxDecoration(
                      color:
                      Colors.white
                          .withOpacity(
                        0.92,
                      ),

                      borderRadius:
                      BorderRadius
                          .circular(
                        20,
                      ),

                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors
                              .black
                              .withOpacity(
                            0.06,
                          ),

                          blurRadius:
                          8,
                        ),
                      ],
                    ),

                    child:
                    const Text(
                      'اسحب للتحريك • قرّب بإصبعين • اضغط مرتين للتكبير',

                      textAlign:
                      TextAlign
                          .center,

                      style:
                      TextStyle(
                        fontFamily:
                        'Tajawal',

                        fontSize:
                        11,

                        color:
                        Color(
                          0xff6C7A7A,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ============================================================
// Zoom Controls
// ============================================================

class _ZoomControls
    extends StatelessWidget {
  final VoidCallback
  onZoomIn;

  final VoidCallback
  onZoomOut;

  final VoidCallback
  onReset;

  const _ZoomControls({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onReset,
  });

  @override
  Widget build(
      BuildContext context,
      ) {
    return Container(
      padding:
      const EdgeInsets.all(
        5,
      ),

      decoration:
      BoxDecoration(
        color:
        Colors.white
            .withOpacity(
          0.95,
        ),

        borderRadius:
        BorderRadius.circular(
          16,
        ),

        border:
        Border.all(
          color:
          const Color(
            0xffDCEBE8,
          ),
        ),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black
                .withOpacity(
              0.08,
            ),

            blurRadius: 10,

            offset:
            const Offset(
              0,
              3,
            ),
          ),
        ],
      ),

      child: Row(
        mainAxisSize:
        MainAxisSize.min,

        children: [
          _button(
            icon:
            Icons.add_rounded,

            tooltip:
            'تكبير',

            onPressed:
            onZoomIn,
          ),

          _divider(),

          _button(
            icon:
            Icons
                .remove_rounded,

            tooltip:
            'تصغير',

            onPressed:
            onZoomOut,
          ),

          _divider(),

          _button(
            icon:
            Icons
                .center_focus_strong_rounded,

            tooltip:
            'إعادة ضبط',

            onPressed:
            onReset,
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,

      height: 22,

      margin:
      const EdgeInsets
          .symmetric(
        horizontal: 2,
      ),

      color:
      const Color(
        0xffE4EFED,
      ),
    );
  }

  Widget _button({
    required IconData icon,
    required String tooltip,
    required VoidCallback
    onPressed,
  }) {
    return Tooltip(
      message: tooltip,

      child: InkWell(
        borderRadius:
        BorderRadius.circular(
          12,
        ),

        onTap:
        onPressed,

        child:
        SizedBox(
          width: 38,
          height: 38,

          child:
          Icon(
            icon,

            size: 21,

            color:
            const Color(
              0xff2A9D8F,
            ),
          ),
        ),
      ),
    );
  }
}