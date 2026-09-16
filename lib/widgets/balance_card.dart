import 'package:bills_app/core/constants/app_constants.dart';
import 'package:bills_app/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../model/transaction_model.dart';

class BalanceCard extends StatelessWidget {
  final double amount;
  final String currencyCode; // التعديل: استلام رمز العملة الأساسية ديناميكياً
  final List<TransactionModel> transactions;

  const BalanceCard({
    super.key,
    required this.amount,
    required this.currencyCode,
    required this.transactions,
  });

  List<FlSpot> _generateChartSpots() {
    if (transactions.isEmpty) {
      return const [FlSpot(0, 0)];
    }

    final sortedTx = List<TransactionModel>.from(transactions)
      ..sort((a, b) => a.date.compareTo(b.date));

    List<FlSpot> spots = [const FlSpot(0, 0)];
    double runningBalance = 0;

    for (int i = 0; i < sortedTx.length; i++) {
      // التعديل الرئيسي: الاعتماد على baseAmount لتوحيد القيم في الرسم البياني
      runningBalance += sortedTx[i].baseAmount;
      spots.add(FlSpot((i + 1).toDouble(), runningBalance));
    }

    return spots;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // عرض المبلغ بأسلوب موحد بالعملة الأساسية
    final formattedAmount = '${amount.toStringAsFixed(2)} $currencyCode';

    final spots = _generateChartSpots();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecorations.primaryCardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.totalBalance,
            style: const TextStyle(
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

          // الرسم البياني
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
// import 'package:bills_app/core/constants/app_constants.dart';
// import 'package:bills_app/l10n/app_localizations.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// import '../model/transaction_model.dart';

// class BalanceCard extends StatelessWidget {
//   final double amount;
//   final List<TransactionModel> transactions;

//   const BalanceCard({
//     super.key,
//     required this.amount,
//     required this.transactions,
//   });

//   List<FlSpot> _generateChartSpots() {
//     if (transactions.isEmpty) {
//       return const [FlSpot(0, 0)];
//     }

//     final sortedTx = List<TransactionModel>.from(transactions)
//       ..sort((a, b) => a.date.compareTo(b.date));

//     List<FlSpot> spots = [const FlSpot(0, 0)];
//     double runningBalance = 0;

//     for (int i = 0; i < sortedTx.length; i++) {
//       runningBalance += sortedTx[i].amount;
//       spots.add(FlSpot((i + 1).toDouble(), runningBalance));
//     }

//     return spots;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;

//     // تنسيق المبلغ مع رمز العملة المترجم بحسب اللغة الحالية
//     final isArabic = Localizations.localeOf(context).languageCode == 'ar';
//     final currencySymbol = isArabic ? 'ل.س' : 'SYP';
//     final formattedAmount = '${amount.toStringAsFixed(2)} $currencySymbol';

//     final spots = _generateChartSpots();

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(AppSpacing.lg),
//       decoration: AppDecorations.primaryCardDecoration,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             l10n.totalBalance, // النص المترجم للرصيد الكلي
//             style: const TextStyle(
//               fontFamily: 'Cairo',
//               color: Colors.white70,
//               fontSize: 14,
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             formattedAmount,
//             style: AppTextStyles.amountLarge.copyWith(color: Colors.white),
//           ),
//           const SizedBox(height: AppSpacing.md),

//           // الرسم البياني
//           SizedBox(
//             height: 70,
//             child: LineChart(
//               LineChartData(
//                 gridData: const FlGridData(show: false),
//                 titlesData: const FlTitlesData(show: false),
//                 borderData: FlBorderData(show: false),
//                 lineBarsData: [
//                   LineChartBarData(
//                     spots: spots,
//                     isCurved: true,
//                     color: amount >= 0
//                         ? const Color.fromARGB(255, 73, 192, 77)
//                         : AppColors.danger,
//                     barWidth: 3,
//                     isStrokeCapRound: true,
//                     dotData: const FlDotData(show: false),
//                     belowBarData: BarAreaData(
//                       show: true,
//                       color: Colors.white.withValues(alpha: .15),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
