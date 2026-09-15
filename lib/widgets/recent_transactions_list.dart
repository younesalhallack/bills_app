import 'package:bills_app/core/constants/app_constants.dart';
import 'package:bills_app/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

class RecentTransactionsList extends StatelessWidget {
  final List<TransactionModel> transactions;
  final VoidCallback onSeeMorePressed;

  const RecentTransactionsList({
    super.key,
    required this.transactions,
    required this.onSeeMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الهيدر: العنوان + زر عرض الكل
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('أحدث المعاملات', style: AppTextStyles.h2),
            TextButton(
              onPressed: onSeeMorePressed, // ربط الانتقال بشاشة سجل الحركات
              child: const Text(
                'عرض الكل',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),

        // في حال كانت القائمة فارغة
        if (transactions.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            width: double.infinity,
            decoration: AppDecorations.cardDecoration,
            child: Center(
              child: Text(
                'لا توجد معاملات حديثة',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          // عرض القائمة الديناميكية (أحدث 4 حركات)
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final category = tx.category.value;
              final isIncome = tx.amount > 0;
              final formattedAmount =
                  '${isIncome ? "+" : ""}${tx.amount.toStringAsFixed(2)} ${tx.currencyCode}';
              final formattedDate = DateFormat(
                'd MMMM - hh:mm a',
                'ar',
              ).format(tx.date);

              return Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: AppDecorations.cardDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الصف الرئيسي: الأيقونة، الفئة/التاريخ، والمبلغ
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isIncome
                                ? AppColors.success.withValues(alpha: 0.15)
                                : AppColors.danger.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: HeroIcon(
                              _getHeroIconData(category?.iconName),
                              color: isIncome
                                  ? AppColors.success
                                  : AppColors.danger,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category?.name ?? (tx.note ?? 'معاملة'),
                                style: AppTextStyles.h3,
                              ),
                              Text(
                                formattedDate,
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          formattedAmount,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isIncome
                                ? AppColors.success
                                : AppColors
                                      .danger, // أحمر للمصاريف وأخضر للإيراد
                          ),
                        ),
                      ],
                    ),

                    // عرض الملاحظة أسفل التفاصيل في حال وجودها
                    if (tx.note != null && tx.note!.trim().isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const HeroIcon(
                            HeroIcons.documentText,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              tx.note!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  // إرجاع أيقونة الفئة المناسبة
  HeroIcons _getHeroIconData(String? iconName) {
    switch (iconName) {
      case 'shoppingCart':
        return HeroIcons.shoppingCart;
      case 'academicCap':
        return HeroIcons.academicCap;
      case 'heart':
        return HeroIcons.heart;
      case 'film':
        return HeroIcons.film;
      case 'wrench':
        return HeroIcons.wrench;
      case 'banknotes':
        return HeroIcons.banknotes;
      case 'creditCard':
        return HeroIcons.creditCard;
      case 'briefcase':
        return HeroIcons.briefcase;
      case 'bolt':
        return HeroIcons.bolt;
      case 'shoppingBag':
        return HeroIcons.shoppingBag;
      case 'home':
        return HeroIcons.home;
      default:
        return HeroIcons.tag;
    }
  }
}
