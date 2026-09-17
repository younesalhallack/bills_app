import 'package:bills_app/core/constants/app_constants.dart';
import 'package:bills_app/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

import '../model/transaction_model.dart';

class BalanceCard extends StatefulWidget {
  final double amount;
  final String currencyCode;
  final List<TransactionModel> transactions;

  const BalanceCard({
    super.key,
    required this.amount,
    required this.currencyCode,
    required this.transactions,
  });

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  //   hide balance controller
  bool _isBalanceVisible = true;

  List<FlSpot> _generateChartSpots() {
    if (widget.transactions.isEmpty) {
      return const [FlSpot(0, 0)];
    }

    final sortedTx = List<TransactionModel>.from(widget.transactions)
      ..sort((a, b) => a.date.compareTo(b.date));

    List<FlSpot> spots = [const FlSpot(0, 0)];
    double runningBalance = 0;

    for (int i = 0; i < sortedTx.length; i++) {
      runningBalance += sortedTx[i].baseAmount;
      spots.add(FlSpot((i + 1).toDouble(), runningBalance));
    }

    return spots;
  }

  // format amount
  String _formatAmount(double value) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final formattedAmount = _isBalanceVisible
        ? '${_formatAmount(widget.amount)} ${widget.currencyCode}'
        : '••••••••';

    final spots = _generateChartSpots();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecorations.primaryCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.totalBalance,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              //    hide balance  btn
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _isBalanceVisible = !_isBalanceVisible;
                  });
                },
                icon: HeroIcon(
                  _isBalanceVisible ? HeroIcons.eye : HeroIcons.eyeSlash,
                  color: Colors.white70,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            formattedAmount,
            style: AppTextStyles.amountLarge.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.md),

          //  line chart
          SizedBox(
            height: 70,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: widget.amount >= 0
                        ? const Color.fromARGB(255, 73, 192, 77)
                        : AppColors.danger,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.white.withValues(alpha: .15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
