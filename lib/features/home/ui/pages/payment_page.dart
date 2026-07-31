import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduationprojct/features/home/providers/funding_request_provider.dart';
import 'package:graduationprojct/features/home/providers/wallet_provider.dart';
import 'package:provider/provider.dart';

import '../widgets/funding_request_bottom_template.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<WalletProvider>().getWallet();
    });
  }


  @override
  Widget build(BuildContext context) {
    final walletProvider =
    context.watch<WalletProvider>();

    final wallet = walletProvider.wallet;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
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

            Positioned(
              top: 55,
              right: 16,
              child: InkWell(
                onTap: () => Navigator.pop(context),
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        textDirection: TextDirection.rtl,
                        color: Color(0xff2A9D8F),
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Text(
                        'سجل الدفع',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff2A9D8F),
                          fontFamily: 'Tajawal',
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 120,
              right: 18,
              left: 18,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 22,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff2A9D8F),
                      Color(0xff21867A),
                    ],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff2A9D8F)
                          .withOpacity(0.22),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: walletProvider.isLoading
                    ? const SizedBox(
                  height: 60,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  ),
                )
                    : Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'الرصيد الحالي',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 15,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            wallet?.balance ?? '0',
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 28,
                              fontWeight:
                              FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'ليرة سورية',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 13,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons
                            .account_balance_wallet_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 255,
              right: 18,
              left: 18,
              child: SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      FundingRequestBottomTemplate.show(context),
                  icon: const Icon(
                    Icons.add_card_rounded,
                    color: Colors.white,
                    size: 23,
                  ),
                  label: const Text(
                    'طلب شحن الرصيد',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    const Color(0xff264653),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),

            /*
             * سجل عمليات الدفع يبدأ من هنا.
             */
            Positioned(
              top: 330,
              right: 18,
              left: 18,
              bottom: 20,
              child: walletProvider.errorMessage != null
                  ? Center(
                child: Text(
                  walletProvider.errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Tajawal',
                    color: Colors.red,
                  ),
                ),
              )
                  : const Center(
                child: Text(
                  'سيظهر سجل عمليات الدفع هنا',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                    color: Color(0xff839493),
                  ),
                ),
              ),
            ),
          ],
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