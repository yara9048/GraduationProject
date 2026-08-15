import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PdfViewerPage extends StatefulWidget {
  final String pdfUrl;
  final String title;
  final String? fileName;

  const PdfViewerPage({
    super.key,
    required this.pdfUrl,
    required this.title,
    this.fileName,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localPath;

  bool isLoading = true;
  String? errorMessage;

  int currentPage = 0;
  int totalPages = 0;

  PDFViewController? pdfController;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await http.get(
        Uri.parse(widget.pdfUrl),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'فشل تحميل الملف: ${response.statusCode}',
        );
      }

      final directory = await getTemporaryDirectory();

      final String fileName =
          widget.fileName ??
              widget.pdfUrl.split('/').last.split('?').first;

      final file = File(
        '${directory.path}/$fileName',
      );

      await file.writeAsBytes(
        response.bodyBytes,
        flush: true,
      );

      if (!mounted) return;

      setState(() {
        localPath = file.path;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = 'تعذر تحميل ملف المحاضرة';
      });

      debugPrint('PDF Error: $e');
    }
  }

  Future<void> _goToPreviousPage() async {
    if (currentPage <= 0) return;

    await pdfController?.setPage(
      currentPage - 1,
    );
  }

  Future<void> _goToNextPage() async {
    if (currentPage >= totalPages - 1) {
      return;
    }

    await pdfController?.setPage(
      currentPage + 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xffF4F7F6),
        body: SafeArea(
          child: Column(
            children: [
             Padding(
               padding: const EdgeInsets.only(left: 300.0),
               child: IconButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                            );
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            textDirection: TextDirection.rtl,
                            color: Color(0xff2A9D8F),
                            size: 20,
                          ),
                        ),
             ),

              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return _buildLoading();
    }

    if (errorMessage != null) {
      return _buildError();
    }

    if (localPath == null) {
      return const SizedBox();
    }

    return Column(
      children: [
        Expanded(
          child: _buildPdfViewer(),
        ),

        if (totalPages > 0)
          _buildBottomNavigation(),
      ],
    );
  }

  Widget _buildPdfViewer() {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        12,
        0,
        12,
        10,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xffE9ECEB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xffDDE3E2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          PDFView(
            filePath: localPath!,

            enableSwipe: true,
            swipeHorizontal: false,

            autoSpacing: true,
            pageFling: true,
            pageSnap: true,

            fitPolicy: FitPolicy.WIDTH,

            preventLinkNavigation: false,

            backgroundColor:
            const Color(0xffE9ECEB),

            onRender: (pages) {
              if (!mounted) return;

              setState(() {
                totalPages = pages ?? 0;
              });
            },

            onViewCreated: (controller) {
              pdfController = controller;
            },

            onPageChanged: (page, total) {
              if (!mounted) return;

              setState(() {
                currentPage = page ?? 0;
                totalPages =
                    total ?? totalPages;
              });
            },

            onError: (error) {
              debugPrint(
                'PDFView error: $error',
              );
            },

            onPageError: (page, error) {
              debugPrint(
                'PDF page $page error: $error',
              );
            },
          ),

          /// رقم الصفحة داخل الـ PDF
          if (totalPages > 0)
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.60),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${currentPage + 1} / $totalPages',
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final bool canGoPrevious =
        currentPage > 0;

    final bool canGoNext =
        currentPage < totalPages - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        11,
        16,
        14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _navigationButton(
              icon: Icons.arrow_back_rounded,
              title: 'السابق',
              enabled: canGoPrevious,
              onTap: _goToPreviousPage,
              primary: false,
            ),
          ),

          const SizedBox(width: 12),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 13,
            ),
            child: Text(
              '${currentPage + 1}',
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xff264653),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: _navigationButton(
              title: 'التالي',
              icon: Icons.arrow_forward_rounded,
              enabled: canGoNext,
              onTap: _goToNextPage,
              primary: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _navigationButton({
    required String title,
    required IconData icon,
    required bool enabled,
    required VoidCallback onTap,
    required bool primary,
  }) {
    if (primary) {
      return SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: enabled ? onTap : null,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor:
            const Color(0xff2A9D8F),
            disabledBackgroundColor:
            const Color(0xffD9DFDE),
            foregroundColor: Colors.white,
            disabledForegroundColor:
            const Color(0xffA7B0AF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(width: 7),

              Icon(
                icon,
                size: 20,
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 50,
      child: OutlinedButton(
        onPressed: enabled ? onTap : null,
        style: OutlinedButton.styleFrom(
          foregroundColor:
          const Color(0xff2A9D8F),
          disabledForegroundColor:
          const Color(0xffAAB4B3),
          side: BorderSide(
            color: enabled
                ? const Color(0xff2A9D8F)
                : const Color(0xffDDE3E2),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
            ),

            const SizedBox(width: 7),

            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 26,
            vertical: 34,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Color(0xff2A9D8F),
                ),
              ),

              SizedBox(height: 20),

              Text(
                'جاري تجهيز الملف',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff264653),
                ),
              ),

              SizedBox(height: 7),

              Text(
                'يتم تحميل ملف المحاضرة وتجهيزه للعرض',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xff7B8B8A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // Error
  // =========================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: const Color(0xffE76F51)
                      .withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  color: Color(0xffE76F51),
                  size: 38,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff264653),
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'تحقق من اتصال الإنترنت ثم حاول مرة أخرى',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xff7B8B8A),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _loadPdf,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor:
                    const Color(0xff2A9D8F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(
                    Icons.refresh_rounded,
                  ),
                  label: const Text(
                    'إعادة المحاولة',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}