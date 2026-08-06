import 'package:flutter/material.dart';
import '../../data/models/wallet_transactions_model.dart';

class WalletTransactionCard extends StatelessWidget {
  final WalletTransactionsModel transaction;

  const WalletTransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final bool isIncome = transaction.amount > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 5),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(color: const Color(0xffDCEBE8)),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),

            blurRadius: 10,

            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Row(
                children: [
                  Container(
                    width: 42,

                    height: 42,

                    decoration: BoxDecoration(
                      color: isIncome
                          ? const Color(0xffE8F7F4)
                          : const Color(0xffFCEBE6),

                      shape: BoxShape.circle,
                    ),

                    child: Icon(
                      isIncome
                          ? Icons.add_circle_outline
                          : Icons.remove_circle_outline,

                      color: isIncome
                          ? const Color(0xff2A9D8F)
                          : const Color(0xffE76F51),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Text(
                    _transactionTitle(),

                    style: const TextStyle(
                      fontFamily: 'Tajawal',

                      fontSize: 16,

                      fontWeight: FontWeight.bold,

                      color: Color(0xff264653),
                    ),
                  ),
                ],
              ),

              Text(
                '${isIncome ? '+' : ''}${transaction.amount.toStringAsFixed(2)}',

                style: TextStyle(
                  fontFamily: 'Tajawal',

                  fontSize: 17,

                  fontWeight: FontWeight.bold,

                  color: isIncome
                      ? const Color(0xff2A9D8F)
                      : const Color(0xffE76F51),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          if (transaction.playlistDetail != null)
            _infoRow(
              Icons.play_circle_outline,

              transaction.playlistDetail!.name,
            ),

          const SizedBox(height: 8),

          _infoRow(
            Icons.account_balance_wallet_outlined,

            'الرصيد بعد العملية: ${transaction.balanceAfter.toStringAsFixed(2)}',
          ),

          const SizedBox(height: 8),

          if (transaction.note.isNotEmpty)
            _infoRow(Icons.notes_rounded, transaction.note),

          const SizedBox(height: 10),

          Align(
            alignment: Alignment.centerLeft,

            child: Text(
              _formatDate(transaction.createdAt),

              style: const TextStyle(
                fontFamily: 'Tajawal',

                fontSize: 12,

                color: Color(0xff839493),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _transactionTitle() {
    switch (transaction.transactionType) {
      case 'fund_approved':
        return 'تم شحن الرصيد';

      case 'subscription_purchase':
        return 'شراء اشتراك';

      case 'refund':
        return 'استرجاع مبلغ';

      default:
        return transaction.transactionType;
    }
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xff2A9D8F)),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            text,

            maxLines: 1,

            overflow: TextOverflow.ellipsis,

            style: const TextStyle(
              fontFamily: 'Tajawal',

              fontSize: 13,

              color: Color(0xff6C7A7A),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(String date) {
    try {
      final d = DateTime.parse(date);

      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return date;
    }
  }
}
