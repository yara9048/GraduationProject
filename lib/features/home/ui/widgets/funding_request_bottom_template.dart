import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduationprojct/features/home/providers/funding_request_provider.dart';
import 'package:provider/provider.dart';

class FundingRequestBottomTemplate extends StatefulWidget {
  const FundingRequestBottomTemplate({super.key});

  static Future<void> show(BuildContext context) async {
    context.read<FundingRequestProvider>().reset();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return const FundingRequestBottomTemplate();
      },
    );
  }

  @override
  State<FundingRequestBottomTemplate> createState() =>
      _FundingRequestBottomSheetState();
}

class _FundingRequestBottomSheetState
    extends State<FundingRequestBottomTemplate> {
  final TextEditingController _amountController =
  TextEditingController();

  final TextEditingController _noteController =
  TextEditingController();

  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final amount = int.parse(
      _amountController.text.trim(),
    );

    final note = _noteController.text.trim();

    final fundingProvider =
    context.read<FundingRequestProvider>();

    await fundingProvider.fund(
      amount: amount,
      note: note,
    );

    if (!mounted) return;

    if (fundingProvider.isSuccess) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'تم إرسال طلب شحن الرصيد بنجاح',
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
    final fundingProvider =
    context.watch<FundingRequestProvider>();

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
                        'طلب شحن الرصيد',
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
                    'أدخل المبلغ المطلوب وأضف ملاحظة توضيحية.',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      color: Color(0xff6C7A7A),
                    ),
                  ),

                  const SizedBox(height: 22),

                  const Text(
                    'الكمية',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff264653),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: const TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 15,
                      color: Color(0xff264653),
                    ),
                    decoration: _inputDecoration(
                      hintText: 'مثال: 50000',
                      icon: Icons.payments_outlined,
                      suffixText: 'ل.س',
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'أدخل الكمية المطلوبة';
                      }

                      final amount = int.tryParse(
                        value.trim(),
                      );

                      if (amount == null || amount <= 0) {
                        return 'أدخل كمية صحيحة أكبر من صفر';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    'الملاحظة',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff264653),
                    ),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _noteController,
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
                      'اكتب ملاحظة عن طلب الشحن...',
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

                  if (fundingProvider.errorMessage != null)
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
                                fundingProvider
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
                      fundingProvider.isLoading
                          ? null
                          : _submitRequest,
                      icon: fundingProvider.isLoading
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
                        fundingProvider.isLoading
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
                      fundingProvider.isLoading
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