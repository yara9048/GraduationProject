import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PdfViewerProvider extends ChangeNotifier {
  String? _localPath;
  bool _isLoading = false;
  String? _errorMessage;

  int _currentPage = 0;
  int _totalPages = 0;

  String? get localPath => _localPath;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  int get currentPage => _currentPage;

  int get totalPages => _totalPages;

  bool get hasError => _errorMessage != null;

  bool get hasPdf => _localPath != null;

  bool get canGoPrevious =>
      _currentPage > 0;

  bool get canGoNext =>
      _totalPages > 0 &&
          _currentPage < _totalPages - 1;

  int get previousPage =>
      _currentPage - 1;

  int get nextPage =>
      _currentPage + 1;

  Future<void> loadPdf({
    required String pdfUrl,
    String? fileName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _localPath = null;
    _currentPage = 0;
    _totalPages = 0;

    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(pdfUrl),
      );

      if (response.statusCode != 200) {
        throw Exception(
          'فشل تحميل الملف: ${response.statusCode}',
        );
      }

      final directory =
      await getTemporaryDirectory();

      final String resolvedFileName =
          fileName ??
              pdfUrl
                  .split('/')
                  .last
                  .split('?')
                  .first;

      final file = File(
        '${directory.path}/$resolvedFileName',
      );

      await file.writeAsBytes(
        response.bodyBytes,
        flush: true,
      );

      _localPath = file.path;
    } catch (e) {
      _errorMessage =
      'تعذر تحميل ملف المحاضرة';

      debugPrint(
        'PDF Error: $e',
      );
    } finally {
      _isLoading = false;

      notifyListeners();
    }
  }

  void setTotalPages(
      int? pages,
      ) {
    _totalPages = pages ?? 0;

    notifyListeners();
  }

  void updatePage({
    required int? page,
    required int? total,
  }) {
    _currentPage = page ?? 0;

    if (total != null) {
      _totalPages = total;
    }

    notifyListeners();
  }

  void reset() {
    _localPath = null;
    _isLoading = false;
    _errorMessage = null;
    _currentPage = 0;
    _totalPages = 0;

    notifyListeners();
  }
}