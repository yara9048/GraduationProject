import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/ai_features_provider.dart';
import 'package:graduationprojct/features/home/ui/pages/video_details_page.dart';
import 'package:graduationprojct/features/home/ui/widgets/mind_map_card_template.dart';
import 'package:graduationprojct/features/home/ui/widgets/summary_card_template.dart';
import 'package:provider/provider.dart';

class SummaryPage extends StatefulWidget {
  final int id;
  final String name;
  final int playlistId;

  const SummaryPage({
    super.key,
    required this.id,
    required this.name,
    required this.playlistId,
  });

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  bool _isMindMapInteracting = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        if (!mounted) return;

        context.read<AiFeaturesProvider>().getAiFeatures(
          videoId: widget.id,
        );
      },
    );
  }

  // =====================================================
  // MindMap Interaction
  // =====================================================

  void _onMindMapInteractionChanged(bool isInteracting) {
    if (!mounted) return;

    if (_isMindMapInteracting == isInteracting) {
      return;
    }

    setState(() {
      _isMindMapInteracting = isInteracting;
    });
  }

  // =====================================================
  // Back
  // =====================================================

  void _goBack() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => VideoDetailsPage(
          videoId: widget.id,
          videoName: widget.name,
          playlistId: widget.playlistId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AiFeaturesProvider>();

    // =====================================================
    // Loading
    // =====================================================

    if (provider.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Color(0xff2A9D8F),
          ),
        ),
      );
    }

    // =====================================================
    // Error
    // =====================================================

    if (provider.errorMessage != null) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _buildTopBar(),

                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(
                                alpha: 0.08,
                              ),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Icon(
                              Icons.error_outline_rounded,
                              color: Colors.red,
                              size: 36,
                            ),
                          ),

                          const SizedBox(height: 18),

                          Text(
                            provider.errorMessage!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 15,
                              height: 1.7,
                              color: Color(0xff264653),
                            ),
                          ),

                          const SizedBox(height: 20),

                          ElevatedButton.icon(
                            onPressed: () {
                              context
                                  .read<AiFeaturesProvider>()
                                  .getAiFeatures(
                                videoId: widget.id,
                              );
                            },
                            icon: const Icon(
                              Icons.refresh_rounded,
                            ),
                            label: const Text(
                              'إعادة المحاولة',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xff2A9D8F,
                              ),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  14,
                                ),
                              ),
                            ),
                          ),
                        ],
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

    // =====================================================
    // Data
    // =====================================================

    final simple = provider.getSummaryByType(
      "simple",
    );

    final mindMap = provider.getSummaryByType(
      "mind_map",
    );

    final String simpleText = simple != null
        ? provider.getSummaryText(simple)
        : "";

    final String mindMapUrl = mindMap != null
        ? provider.getMindMapUrl(mindMap)
        : "";

    // =====================================================
    // Page
    // =====================================================

    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              // =============================================
              // Background decoration
              // =============================================

              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/Images/Ellipse 4.png',
                ),
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset(
                  'assets/Images/Ellipse 7.png',
                ),
              ),

              // =============================================
              // Content
              // =============================================

              SafeArea(
                child: Column(
                  children: [
                    _buildTopBar(),

                    // =========================================
                    // Header
                    // =========================================

                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        18,
                        18,
                        18,
                        0,
                      ),
                      child: _buildHeaderCard(),
                    ),

                    const SizedBox(height: 10),

                    // =========================================
                    // Tabs
                    // =========================================

                    Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        right: 18,
                      ),
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xffF2F7F6,
                          ),
                          borderRadius: BorderRadius.circular(
                            16,
                          ),
                          border: Border.all(
                            color: const Color(
                              0xffE0ECEA,
                            ),
                          ),
                        ),
                        child: TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          dividerColor: Colors.transparent,
                          splashBorderRadius: BorderRadius.circular(
                            13,
                          ),
                          indicator: BoxDecoration(
                            color: const Color(
                              0xff2A9D8F,
                            ),
                            borderRadius: BorderRadius.circular(
                              13,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xff2A9D8F,
                                ).withValues(
                                  alpha: 0.20,
                                ),
                                blurRadius: 10,
                                offset: const Offset(
                                  0,
                                  4,
                                ),
                              ),
                            ],
                          ),
                          labelColor: Colors.white,
                          unselectedLabelColor: const Color(
                            0xff6C7A7A,
                          ),
                          labelStyle: const TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelStyle:
                          const TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                          tabs: const [
                            Tab(
                              iconMargin: EdgeInsets.zero,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.notes_rounded,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'ملخص مبسط',
                                  ),
                                ],
                              ),
                            ),
                            Tab(
                              iconMargin: EdgeInsets.zero,
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_tree_outlined,
                                    size: 18,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'خريطة ذهنية',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // =========================================
                    // Tab Content
                    // =========================================

                    Expanded(
                      child: TabBarView(
                        // أثناء التعامل مع MindMap
                        // نوقف Swipe بين Tabs أيضاً.
                        physics: _isMindMapInteracting
                            ? const NeverScrollableScrollPhysics()
                            : const BouncingScrollPhysics(),

                        children: [
                          // ====================================
                          // Simple Summary
                          // ====================================

                          simpleText.isNotEmpty
                              ? SingleChildScrollView(
                            physics:
                            const BouncingScrollPhysics(),
                            padding:
                            const EdgeInsets.fromLTRB(
                              0,
                              4,
                              0,
                              28,
                            ),
                            child: SummaryCard(
                              data: simpleText,
                            ),
                          )
                              : _buildEmptyState(
                            icon: Icons.notes_rounded,
                            title:
                            'لا يوجد ملخص مبسط',
                            subtitle:
                            'لم يتم إنشاء ملخص مبسط لهذا الفيديو بعد.',
                          ),

                          // ====================================
                          // MindMap
                          // ====================================

                          mindMapUrl.isNotEmpty
                              ? SingleChildScrollView(
                            // أهم تعديل:
                            // يتوقف Scroll الخارجي أثناء
                            // لمس وتحريك الـ MindMap.
                            physics:
                            _isMindMapInteracting
                                ? const NeverScrollableScrollPhysics()
                                : const BouncingScrollPhysics(),

                            padding:
                            const EdgeInsets.fromLTRB(
                              0,
                              4,
                              0,
                              28,
                            ),

                            child: MindMapCard(
                              svgUrl: mindMapUrl,

                              onInteractionChanged:
                              _onMindMapInteractionChanged,
                            ),
                          )
                              : _buildEmptyState(
                            icon: Icons
                                .account_tree_outlined,
                            title:
                            'لا توجد خريطة ذهنية',
                            subtitle:
                            'لم يتم إنشاء خريطة ذهنية لهذا الفيديو بعد.',
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

  // =====================================================
  // Top bar
  // =====================================================

  Widget _buildTopBar() {
    return SizedBox(
      height: 65,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
        ),
        child: Row(
          children: [
            InkWell(
              onTap: _goBack,
              borderRadius: BorderRadius.circular(
                12,
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back_ios_new_rounded,
                      textDirection: TextDirection.rtl,
                      color: Color(
                        0xff2A9D8F,
                      ),
                      size: 20,
                    ),

                    SizedBox(width: 15),

                    Text(
                      'ملخص الفيديو',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(
                          0xff2A9D8F,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // Header Card
  // =====================================================

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(
              0xff2A9D8F,
            ),
            Color(
              0xff21867A,
            ),
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(
          22,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(
              0xff2A9D8F,
            ).withValues(
              alpha: 0.20,
            ),
            blurRadius: 16,
            offset: const Offset(
              0,
              7,
            ),
          ),
        ],
      ),
      child: Row(
        children: [
          // ============================================
          // Icon
          // ============================================

          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(
                alpha: 0.17,
              ),
              borderRadius: BorderRadius.circular(
                17,
              ),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 13),

          // ============================================
          // Text
          // ============================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'ملخص الدرس',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  widget.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 18,
                    height: 1.45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // Empty State
  // =====================================================

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(
                  0xff2A9D8F,
                ).withValues(
                  alpha: 0.08,
                ),
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              child: Icon(
                icon,
                size: 32,
                color: const Color(
                  0xff2A9D8F,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(
                  0xff264653,
                ),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 13,
                height: 1.6,
                color: Color(
                  0xff7B8B8A,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}