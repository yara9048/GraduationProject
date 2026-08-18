import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduationprojct/features/home/providers/funding_request_provider.dart';
import 'package:graduationprojct/features/home/providers/refund_request_provider.dart';
import 'package:graduationprojct/features/home/providers/subscriptions_provider.dart';
import 'package:provider/provider.dart';

class RefundRequestBottomTemplate extends StatefulWidget {
  const RefundRequestBottomTemplate({super.key});

  static Future<void> show(BuildContext context) async {
    context.read<RefundRequestProvider>().reset();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return const RefundRequestBottomTemplate();
      },
    );
  }

  @override
  State<RefundRequestBottomTemplate> createState() =>
      _RefundRequestBottomTemplateState();
}

class _RefundRequestBottomTemplateState
    extends State<RefundRequestBottomTemplate> {
  int? _selectedSubscriptionId;
  final TextEditingController _reasonController =
  TextEditingController();



  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<SubscriptionsProvider>()
          .getSubscriptions();
    });
  }

  Future<void> _submitRequest() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final reason = _reasonController.text.trim();

    final refundingProvider =
    context.read<RefundRequestProvider>();

    await refundingProvider.refund(
      reason: reason,
      subscriptionId: _selectedSubscriptionId!,
    );

    if (!mounted) return;

    if (refundingProvider.isSuccess) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم إرسال طلب الغاء الاشتراك',
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Color(0xff2A9D8F),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final refundingProvider =
    context.watch<RefundRequestProvider>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            25,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: const Color(0xffD7E7E4),
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Row(
                    children: [
                      Icon(
                        Icons
                            .account_balance_wallet_outlined,
                        color: Color(0xff2A9D8F),
                        size: 27,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'طلب الغاء الاشتراك',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff264653),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 7),

                  const Text(
                    'أدخل قائمة التشغيل المراد الغاء اشتراكها مع السبب.',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      color: Color(0xff6C7A7A),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'قائمة التشغيل',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff264653),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Consumer<SubscriptionsProvider>(
                    builder: (
                        context,
                        subscriptionsProvider,
                        child,
                        ) {
                      final subscriptions =
                          subscriptionsProvider.subscriptions;

                      if (subscriptionsProvider.isLoading) {
                        return const SizedBox(
                          width: 280,
                          height: 60,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Color(0xff2A9D8F),
                            ),
                          ),
                        );
                      }

                      if (subscriptionsProvider.errorMessage != null) {
                        return SizedBox(
                          width: 280,
                          child: Column(
                            children: [
                              Text(
                                subscriptionsProvider.errorMessage ??
                                    'تعذر تحميل الاشتراكات',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontFamily: 'Tajawal',
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 5),
                              TextButton.icon(
                                onPressed: () {
                                  context
                                      .read<SubscriptionsProvider>()
                                      .getSubscriptions();
                                },
                                icon: const Icon(
                                  Icons.refresh_rounded,
                                  color: Color(0xff2A9D8F),
                                ),
                                label: const Text(
                                  'إعادة المحاولة',
                                  style: TextStyle(
                                    color: Color(0xff2A9D8F),
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (subscriptions.isEmpty) {
                        return const SizedBox(
                          width: 280,
                          height: 60,
                          child: Center(
                            child: Text(
                              'لا توجد اشتراكات',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        width: 280,
                        child: DropdownButtonFormField<int>(
                          value: _selectedSubscriptionId,
                          dropdownColor: Colors.white,
                          alignment: AlignmentDirectional.centerEnd,
                          isExpanded: true,
                          decoration: InputDecoration(
                            hintText: 'قوائم التشغيل المشترك بها',
                            hintStyle: const TextStyle(
                              color: Color(0xffD1D9D9),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              fontFamily: 'Tajawal',
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: const BorderSide(
                                color: Colors.black26,
                                width: 2,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: const BorderSide(
                                color: Colors.black26,
                                width: 2,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: const BorderSide(
                                color: Color(0xff2A9D8F),
                                width: 1.5,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(22),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ),
                            ),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 22,
                            color: Colors.black26,
                          ),
                          style: const TextStyle(
                            color: Color(0xff1A2429),
                            fontSize: 15,
                            fontFamily: 'Tajawal',
                          ),

                          items: subscriptions.map((subscription) {
                            return DropdownMenuItem<int>(
                              value: subscription.id,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  subscription.playlistDetail?.name ??
                                      'اشتراك رقم ${subscription.id}',
                                  textDirection: TextDirection.rtl,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontFamily: 'Tajawal',
                                  ),
                                ),
                              ),
                            );
                          }).toList(),

                          onChanged: (int? value) {
                            setState(() {
                              _selectedSubscriptionId = value;
                            });
                          },

                          validator: (int? value) {
                            if (value == null) {
                              return 'يرجى اختيار قائمة';
                            }

                            return null;
                          },
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'السبب',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff264653),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    cursorColor: const Color(0xff2A9D8F),
                    controller: _reasonController,
                    minLines: 3,
                    maxLines: 5,
                    maxLength: 250,
                    textInputAction:
                    TextInputAction.newline,
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 15,
                      color: Color(0xff264653),
                    ),
                    decoration: _inputDecoration(
                      hintText:
                      'اكتب ملاحظة عن طلب الغاء الاشتراك...',
                      icon: Icons.notes_rounded,
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'أدخل ملاحظة للطلب';
                      }

                      if (value.trim().length < 3) {
                        return 'الملاحظة قصيرة جداً';
                      }

                      return null;
                    },
                  ),

                  if (refundingProvider.errorMessage != null)
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                        top: 8,
                        bottom: 14,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                        Colors.red.withOpacity(0.08),
                        borderRadius:
                        BorderRadius.circular(12),
                        border: Border.all(
                          color:
                          Colors.red.withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.error_outline_rounded,
                            color: Colors.red,
                            size: 21,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _cleanErrorMessage(
                                refundingProvider
                                    .errorMessage!,
                              ),
                              style: const TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 13,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    height: 53,
                    child: ElevatedButton.icon(
                      onPressed:
                      refundingProvider.isLoading
                          ? null
                          : _submitRequest,
                      icon: refundingProvider.isLoading
                          ? const SizedBox(
                        width: 21,
                        height: 21,
                        child:
                        CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                          : Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ),
                      label: Text(
                        refundingProvider.isLoading
                            ? 'جارٍ إرسال الطلب...'
                            : 'إرسال الطلب',
                        style: const TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xff2A9D8F),
                        disabledBackgroundColor:
                        const Color(0xff8CC9C1),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    height: 49,
                    child: TextButton(
                      onPressed:
                      refundingProvider.isLoading
                          ? null
                          : () => Navigator.pop(
                        context,
                      ),
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6C7A7A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    String? suffixText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        fontFamily: 'Tajawal',
        color: Color(0xff9AA9A7),
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xff2A9D8F),
      ),
      suffixText: suffixText,
      suffixStyle: const TextStyle(
        fontFamily: 'Tajawal',
        color: Color(0xff2A9D8F),
        fontWeight: FontWeight.bold,
      ),
      filled: true,
      fillColor: const Color(0xffF5FAF9),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xffDCEBE8),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Color(0xff2A9D8F),
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    );
  }

  String _cleanErrorMessage(String error) {
    return error
        .replaceFirst('Exception:', '')
        .replaceFirst('DioException:', '')
        .replaceFirst('خطأ:', '')
        .trim();
  }
}