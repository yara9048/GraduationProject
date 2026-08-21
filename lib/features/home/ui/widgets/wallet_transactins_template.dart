import 'package:flutter/material.dart';

import '../../data/models/wallet_transactions_model.dart';

class WalletTransactionCard extends StatelessWidget {
  final WalletTransactionsModel transaction;

  const WalletTransactionCard({
    super.key,
    required this.transaction,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCredit = _isCreditTransaction();

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xffDCEBE8),
        ),
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
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,

                      decoration: BoxDecoration(
                        color: _transactionBackgroundColor(),
                        shape: BoxShape.circle,
                      ),

                      child: Icon(
                        _transactionIcon(),
                        color: _transactionColor(),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        _transactionTitle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,

                        style: const TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff264653),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              Text(
                '${isCredit ? '+' : '-'}${transaction.amount.abs().toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: _transactionColor(),
                ),
              ),
            ],
          ),

          if (transaction.playlistDetail != null) ...[
            const SizedBox(height: 14),

            _infoRow(
              Icons.play_circle_outline,
              transaction.playlistDetail!.name,
            ),
          ],

          const SizedBox(height: 8),

          _infoRow(
            Icons.account_balance_wallet_outlined,
            'الرصيد بعد العملية: ${transaction.balanceAfter.toStringAsFixed(2)}',
          ),

          if (transaction.note.isNotEmpty) ...[
            const SizedBox(height: 8),

            _infoRow(
              Icons.notes_rounded,
              transaction.note,
            ),
          ],

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

  bool _isCreditTransaction() {
    switch (transaction.transactionType) {
      case 'fund_approved':
      case 'refund_credit':
        return true;

      case 'purchase_debit':
        return false;

      default:
        return transaction.amount >= 0;
    }
  }


  String _transactionTitle() {
    switch (transaction.transactionType) {
      case 'fund_approved':
        return 'تم شحن الرصيد';

      case 'purchase_debit':
        return 'شراء اشتراك';

      case 'refund_credit':
        return 'استرجاع مبلغ';

      default:
        return 'عملية مالية';
    }
  }

  IconData _transactionIcon() {
    switch (transaction.transactionType) {
      case 'fund_approved':
        return Icons.add_card_rounded;

      case 'purchase_debit':
        return Icons.shopping_cart_checkout_rounded;

      case 'refund_credit':
        return Icons.currency_exchange_rounded;

      default:
        return Icons.account_balance_wallet_outlined;
    }
  }

  Color _transactionColor() {
    switch (transaction.transactionType) {
      case 'fund_approved':
        return const Color(0xff2A9D8F);

      case 'refund_credit':
        return const Color(0xff457B9D);

      case 'purchase_debit':
        return const Color(0xffE76F51);

      default:
        return const Color(0xff6C7A7A);
    }
  }


  Color _transactionBackgroundColor() {
    switch (transaction.transactionType) {
      case 'fund_approved':
        return const Color(0xffE8F7F4);

      case 'refund_credit':
        return const Color(0xffEAF3F8);

      case 'purchase_debit':
        return const Color(0xffFCEBE6);

      default:
        return const Color(0xffF2F4F4);
    }
  }


  Widget _infoRow(
      IconData icon,
      String text,
      ) {
    return Row(
      children: [
        const SizedBox(width: 2),

        Icon(
          icon,
          size: 18,
          color: Color(0xff2A9D8F),
        ),

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