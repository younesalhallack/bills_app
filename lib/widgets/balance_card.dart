import 'package:bills_app/core/constants/app_constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../model/transaction_model.dart';

class BalanceCard extends StatelessWidget {
  final double amount;
  final List<TransactionModel> transactions; // إضافة قائمة الحركات

  const BalanceCard({
    super.key,
    required this.amount,
    required this.transactions,
  });

  // بناء نقاط الرسم البياني بناءً على تاريخ الحركات
  List<FlSpot> _generateChartSpots() {
    if (transactions.isEmpty) {
      return const [FlSpot(0, 0)];
    }

    // ترتيب المعاملات زمنياً من الأقدم إلى الأحدث
    final sortedTx = List<TransactionModel>.from(transactions)
      ..sort((a, b) => a.date.compareTo(b.date));

    List<FlSpot> spots = [];
    double runningBalance = 0;

    // إضافة نقطة البداية
    spots.add(const FlSpot(0, 0));

    for (int i = 0; i < sortedTx.length; i++) {
      runningBalance += sortedTx[i].amount;
      spots.add(FlSpot((i + 1).toDouble(), runningBalance));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final formattedAmount = '${amount.toStringAsFixed(2)} ر.س';
    final spots = _generateChartSpots();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecorations.primaryCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'الرصيد الكلي',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formattedAmount,
            style: AppTextStyles.amountLarge.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.md),

          // الرسم البياني التفاعلي مع تغيير الرصيد
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
                    color: amount >= 0
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
