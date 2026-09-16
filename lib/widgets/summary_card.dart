import 'package:bills_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final bool isIncome;

  const SummaryCard({
    super.key,
    required this.title,
    required this.amount,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final color = isIncome ? AppColors.success : AppColors.danger;
    final icon = isIncome
        ? HeroIcons.arrowTrendingUp
        : HeroIcons.arrowTrendingDown;

    //RTL/LTR
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final alignment = isRtl ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.cardDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: alignment,
                  child: Text(amount, style: AppTextStyles.amountMedium),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: HeroIcon(icon, color: color, size: 20),
          ),
        ],
      ),
    );
  }
}
