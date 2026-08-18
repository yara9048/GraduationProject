import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';

import '../../providers/pdf_viewer_provider.dart';
import '../widgets/pdf_navigation_button_template.dart';

class PdfViewerPage
    extends StatefulWidget {
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
  State<PdfViewerPage> createState() =>
      _PdfViewerPageState();
}

class _PdfViewerPageState
    extends State<PdfViewerPage> {
  PDFViewController? pdfController;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback(
          (_) {
        if (!mounted) {
          return;
        }

        context
            .read<PdfViewerProvider>()
            .loadPdf(
          pdfUrl:
          widget.pdfUrl,
          fileName:
          widget.fileName,
        );
      },
    );
  }

  @override
  Widget build(
      BuildContext context,
      ) {
    final provider =
    context.watch<
        PdfViewerProvider>();

    return Directionality(
      textDirection:
      TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
        const Color(
          0xffF4F7F6,
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                const EdgeInsets
                    .only(
                  left: 300,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  icon:
                  const Icon(
                    Icons
                        .arrow_back_ios_new_rounded,
                    textDirection:
                    TextDirection
                        .rtl,
                    color:
                    Color(
                      0xff2A9D8F,
                    ),
                    size: 20,
                  ),
                ),
              ),

              Expanded(
                child:
                provider.isLoading

                    ? Center(
                  child:
                  Padding(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal:
                      30,
                    ),
                    child:
                    Container(
                      width:
                      double
                          .infinity,
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal:
                        26,
                        vertical:
                        34,
                      ),
                      decoration:
                      BoxDecoration(
                        color:
                        Colors
                            .white,
                        borderRadius:
                        BorderRadius
                            .circular(
                          24,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                            Colors
                                .black
                                .withOpacity(
                              0.05,
                            ),
                            blurRadius:
                            20,
                            offset:
                            const Offset(
                              0,
                              8,
                            ),
                          ),
                        ],
                      ),
                      child:
                      const Column(
                        mainAxisSize:
                        MainAxisSize
                            .min,
                        children: [
                          SizedBox(
                            width:
                            48,
                            height:
                            48,
                            child:
                            CircularProgressIndicator(
                              strokeWidth:
                              3,
                              color:
                              Color(
                                0xff2A9D8F,
                              ),
                            ),
                          ),
                          SizedBox(
                            height:
                            20,
                          ),
                          Text(
                            'جاري تجهيز الملف',
                            style:
                            TextStyle(
                              fontFamily:
                              'Tajawal',
                              fontSize:
                              18,
                              fontWeight:
                              FontWeight
                                  .bold,
                              color:
                              Color(
                                0xff264653,
                              ),
                            ),
                          ),
                          SizedBox(
                            height:
                            7,
                          ),
                          Text(
                            'يتم تحميل ملف المحاضرة وتجهيزه للعرض',
                            textAlign:
                            TextAlign
                                .center,
                            style:
                            TextStyle(
                              fontFamily:
                              'Tajawal',
                              fontSize:
                              13,
                              height:
                              1.5,
                              color:
                              Color(
                                0xff7B8B8A,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )

                    : provider.hasError

                    ? Center(
                  child:
                  Padding(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal:
                      30,
                    ),
                    child:
                    Container(
                      width:
                      double
                          .infinity,
                      padding:
                      const EdgeInsets
                          .all(
                        28,
                      ),
                      decoration:
                      BoxDecoration(
                        color:
                        Colors
                            .white,
                        borderRadius:
                        BorderRadius
                            .circular(
                          24,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                            Colors
                                .black
                                .withOpacity(
                              0.05,
                            ),
                            blurRadius:
                            20,
                            offset:
                            const Offset(
                              0,
                              8,
                            ),
                          ),
                        ],
                      ),
                      child:
                      Column(
                        mainAxisSize:
                        MainAxisSize
                            .min,
                        children: [
                          Container(
                            width:
                            76,
                            height:
                            76,
                            decoration:
                            BoxDecoration(
                              color:
                              const Color(
                                0xffE76F51,
                              ).withOpacity(
                                0.10,
                              ),
                              shape:
                              BoxShape
                                  .circle,
                            ),
                            child:
                            const Icon(
                              Icons
                                  .error_outline_rounded,
                              color:
                              Color(
                                0xffE76F51,
                              ),
                              size:
                              38,
                            ),
                          ),
                          const SizedBox(
                            height:
                            20,
                          ),
                          Text(
                            provider
                                .errorMessage!,
                            textAlign:
                            TextAlign
                                .center,
                            style:
                            const TextStyle(
                              fontFamily:
                              'Tajawal',
                              fontSize:
                              18,
                              fontWeight:
                              FontWeight
                                  .bold,
                              color:
                              Color(
                                0xff264653,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height:
                            8,
                          ),
                          const Text(
                            'تحقق من اتصال الإنترنت ثم حاول مرة أخرى',
                            textAlign:
                            TextAlign
                                .center,
                            style:
                            TextStyle(
                              fontFamily:
                              'Tajawal',
                              fontSize:
                              13,
                              height:
                              1.5,
                              color:
                              Color(
                                0xff7B8B8A,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height:
                            24,
                          ),
                          SizedBox(
                            width:
                            double
                                .infinity,
                            height:
                            50,
                            child:
                            ElevatedButton
                                .icon(
                              onPressed:
                                  () {
                                provider
                                    .loadPdf(
                                  pdfUrl:
                                  widget.pdfUrl,
                                  fileName:
                                  widget.fileName,
                                );
                              },
                              style:
                              ElevatedButton
                                  .styleFrom(
                                elevation:
                                0,
                                backgroundColor:
                                const Color(
                                  0xff2A9D8F,
                                ),
                                foregroundColor:
                                Colors.white,
                                shape:
                                RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(
                                    15,
                                  ),
                                ),
                              ),
                              icon:
                              const Icon(
                                Icons
                                    .refresh_rounded,
                              ),
                              label:
                              const Text(
                                'إعادة المحاولة',
                                style:
                                TextStyle(
                                  fontFamily:
                                  'Tajawal',
                                  fontSize:
                                  14,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )

                    : provider
                    .localPath ==
                    null

                    ? const SizedBox()

                    : Column(
                  children: [
                    Expanded(
                      child:
                      Container(
                        margin:
                        const EdgeInsets
                            .fromLTRB(
                          12,
                          0,
                          12,
                          10,
                        ),
                        clipBehavior:
                        Clip
                            .antiAlias,
                        decoration:
                        BoxDecoration(
                          color:
                          const Color(
                            0xffE9ECEB,
                          ),
                          borderRadius:
                          BorderRadius
                              .circular(
                            20,
                          ),
                          border:
                          Border.all(
                            color:
                            const Color(
                              0xffDDE3E2,
                            ),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color:
                              Colors
                                  .black
                                  .withOpacity(
                                0.055,
                              ),
                              blurRadius:
                              16,
                              offset:
                              const Offset(
                                0,
                                5,
                              ),
                            ),
                          ],
                        ),
                        child:
                        Stack(
                          children: [
                            PDFView(
                              filePath:
                              provider.localPath!,
                              enableSwipe:
                              true,
                              swipeHorizontal:
                              false,
                              autoSpacing:
                              true,
                              pageFling:
                              true,
                              pageSnap:
                              true,
                              fitPolicy:
                              FitPolicy.WIDTH,
                              preventLinkNavigation:
                              false,
                              backgroundColor:
                              const Color(
                                0xffE9ECEB,
                              ),
                              onRender:
                                  (
                                  pages,
                                  ) {
                                provider
                                    .setTotalPages(
                                  pages,
                                );
                              },
                              onViewCreated:
                                  (
                                  controller,
                                  ) {
                                pdfController =
                                    controller;
                              },
                              onPageChanged:
                                  (
                                  page,
                                  total,
                                  ) {
                                provider
                                    .updatePage(
                                  page:
                                  page,
                                  total:
                                  total,
                                );
                              },
                              onError:
                                  (
                                  error,
                                  ) {
                                debugPrint(
                                  'PDFView error: $error',
                                );
                              },
                              onPageError:
                                  (
                                  page,
                                  error,
                                  ) {
                                debugPrint(
                                  'PDF page $page error: $error',
                                );
                              },
                            ),

                            if (provider
                                .totalPages >
                                0)
                              Positioned(
                                bottom:
                                12,
                                left:
                                12,
                                child:
                                Container(
                                  padding:
                                  const EdgeInsets
                                      .symmetric(
                                    horizontal:
                                    10,
                                    vertical:
                                    6,
                                  ),
                                  decoration:
                                  BoxDecoration(
                                    color:
                                    Colors
                                        .black
                                        .withOpacity(
                                      0.60,
                                    ),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      20,
                                    ),
                                  ),
                                  child:
                                  Text(
                                    '${provider.currentPage + 1} / ${provider.totalPages}',
                                    style:
                                    const TextStyle(
                                      fontFamily:
                                      'Tajawal',
                                      fontSize:
                                      11,
                                      fontWeight:
                                      FontWeight.bold,
                                      color:
                                      Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    if (provider
                        .totalPages >
                        0)
                      Container(
                        padding:
                        const EdgeInsets
                            .fromLTRB(
                          16,
                          11,
                          16,
                          14,
                        ),
                        decoration:
                        BoxDecoration(
                          color:
                          Colors
                              .white,
                          boxShadow: [
                            BoxShadow(
                              color:
                              Colors
                                  .black
                                  .withOpacity(
                                0.055,
                              ),
                              blurRadius:
                              18,
                              offset:
                              const Offset(
                                0,
                                -4,
                              ),
                            ),
                          ],
                        ),
                        child:
                        Row(
                          children: [
                            Expanded(
                              child:
                              PdfNavigationButtonTemplate(
                                icon:
                                Icons.arrow_back_rounded,
                                title:
                                'السابق',
                                enabled:
                                provider.canGoPrevious,
                                primary:
                                false,
                                onTap:
                                    () {
                                  pdfController
                                      ?.setPage(
                                    provider.previousPage,
                                  );
                                },
                              ),
                            ),

                            const SizedBox(
                              width:
                              12,
                            ),

                            Padding(
                              padding:
                              const EdgeInsets
                                  .symmetric(
                                horizontal:
                                13,
                              ),
                              child:
                              Text(
                                '${provider.currentPage + 1}',
                                style:
                                const TextStyle(
                                  fontFamily:
                                  'Tajawal',
                                  fontSize:
                                  18,
                                  fontWeight:
                                  FontWeight.bold,
                                  color:
                                  Color(
                                    0xff264653,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              width:
                              12,
                            ),

                            Expanded(
                              child:
                              PdfNavigationButtonTemplate(
                                title:
                                'التالي',
                                icon:
                                Icons.arrow_forward_rounded,
                                enabled:
                                provider.canGoNext,
                                primary:
                                true,
                                onTap:
                                    () {
                                  pdfController
                                      ?.setPage(
                                    provider.nextPage,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}