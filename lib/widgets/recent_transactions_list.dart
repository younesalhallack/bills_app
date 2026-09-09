import 'package:bills_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class RecentTransactionsList extends StatelessWidget {
  const RecentTransactionsList({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      {
        'title': 'راتب',
        'date': 'Dec 15',
        'amount': '+4,500 ر.س',
        'isIncome': true,
        'icon': HeroIcons.briefcase,
        'bgColor': AppColors.bgSalary,
      },
      {
        'title': 'فاتورة كهرباء',
        'date': 'Dec 14',
        'amount': '-320 ر.س',
        'isIncome': false,
        'icon': HeroIcons.bolt,
        'bgColor': AppColors.bgElectricity,
      },
      {
        'title': 'بقالة',
        'date': 'Dec 12',
        'amount': '-150 ر.س',
        'isIncome': false,
        'icon': HeroIcons.shoppingBag,
        'bgColor': AppColors.bgGroceries,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('أحدث المعاملات', style: AppTextStyles.h2),
            TextButton(
              onPressed: () {},
              child: const Text(
                'عرض الكل',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ListView.separated(
          shrinkWrap: true, // لتتناسب داخل SingleChildScrollView
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          itemBuilder: (context, index) {
            final item = transactions[index];
            return Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: AppDecorations.cardDecoration,
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: item['bgColor'] as Color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: HeroIcon(
                        item['icon'] as HeroIcons,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item['title'] as String, style: AppTextStyles.h3),
                        Text(
                          item['date'] as String,
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    item['amount'] as String,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: (item['isIncome'] as bool)
                          ? AppColors.success
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
