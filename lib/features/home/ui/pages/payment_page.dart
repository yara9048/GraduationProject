import 'package:flutter/material.dart';
import 'package:graduationprojct/features/home/providers/wallet_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/subscriptions_provider.dart';
import '../../providers/wallet_transactions_provider.dart';
import '../widgets/funding_request_bottom_template.dart';
import '../widgets/refund_request_bottom_template.dart';
import '../widgets/wallet_transactins_template.dart';

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
      context.read<WalletTransactionsProvider>().getTransactions();
      context.read<SubscriptionsProvider>().getSubscriptions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletProvider = context.watch<WalletProvider>();
    final wallet = walletProvider.wallet;
    final transactionsProvider = context.watch<WalletTransactionsProvider>();
    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: Colors.white,

        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image.asset('assets/Images/Ellipse 4.png'),
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset('assets/Images/Ellipse 7.png'),
            ),

            // العنوان
            Positioned(
              top: 55,
              right: 16,
              child: Text(
                'سجل الدفع',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xff2A9D8F),
                  fontFamily: 'Tajawal',
                  fontSize: 20,
                ),
              ),
            ),

            // كرت الرصيد
            Positioned(
              top: 120,
              right: 18,
              left: 18,

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 22,
                ),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff2A9D8F), Color(0xff21867A)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),

                  borderRadius: BorderRadius.circular(22),

                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff2A9D8F).withOpacity(0.22),

                      blurRadius: 16,

                      offset: const Offset(0, 8),
                    ),
                  ],
                ),

                child: walletProvider.isLoading
                    ? const SizedBox(
                        height: 60,

                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const Text(
                                'الرصيد الحالي',

                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 15,
                                  color: Colors.white70,
                                ),
                              ),

                              const SizedBox(height: 5),

                              Text(
                                wallet?.balance ?? '0',

                                style: const TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
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

                          Container(
                            width: 60,
                            height: 60,

                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),

                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.account_balance_wallet_outlined,

                              color: Colors.white,

                              size: 32,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // زر الشحن
            Positioned(
              top: 255,

              right: 18,
              left: 18,

              child: SizedBox(
                height: 54,

                child: ElevatedButton.icon(
                  onPressed: () {
                    print("FUNDING BUTTON PRESSED");

                    FundingRequestBottomTemplate.show(context);
                  },

                  icon: const Icon(Icons.add_card_rounded, color: Colors.white),

                  label: const Text(
                    'طلب شحن الرصيد',

                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff264653),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              top: 315,
              right: 18,
              left: 18,

              child: SizedBox(
                height: 54,

                child: ElevatedButton.icon(
                  onPressed: () {
                    print("REFUND BUTTON PRESSED");

                    RefundRequestBottomTemplate.show(context);
                  },

                  icon: const Icon(
                    Icons.remove_circle_outline_sharp,

                    color: Colors.white,
                  ),

                  label: const Text(
                    'طلب الغاء اشتراك',

                    style: TextStyle(
                      fontFamily: 'Tajawal',

                      fontWeight: FontWeight.bold,

                      color: Colors.white,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff264653),

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 380,
              right: 18,
              left: 18,
              bottom: 0,

              child: Consumer<WalletTransactionsProvider>(
                builder: (context, transactionsProvider, child) {
                  if (transactionsProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff2A9D8F),
                      ),
                    );
                  }

                  if (transactionsProvider.errorMessage != null) {
                    return Center(
                      child: Text(
                        transactionsProvider.errorMessage!,

                        textAlign: TextAlign.center,

                        style: const TextStyle(
                          fontFamily: 'Tajawal',
                          color: Colors.red,
                        ),
                      ),
                    );
                  }

                  if (transactionsProvider.transactions.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا يوجد سجل عمليات دفع',

                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 14,
                          color: Color(0xff839493),
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.zero,

                    itemCount: transactionsProvider.transactions.length,

                    itemBuilder: (context, index) {
                      return WalletTransactionCard(
                        transaction: transactionsProvider.transactions[index],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
