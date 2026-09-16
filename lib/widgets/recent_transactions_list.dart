import 'package:bills_app/core/constants/app_constants.dart';
import 'package:bills_app/l10n/app_localizations.dart';
import 'package:bills_app/model/transaction_model.dart';
import 'package:bills_app/providers/isar_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

class RecentTransactionsList extends ConsumerWidget {
  final List<TransactionModel> transactions;
  final VoidCallback onSeeMorePressed;

  const RecentTransactionsList({
    super.key,
    required this.transactions,
    required this.onSeeMorePressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    // الحصول على رمز العملة الأساسية الحالية للنظام
    final currencySettings = ref.watch(currencySettingsStreamProvider).value;
    final baseCurrencyCode = currencySettings?.baseCurrencyCode ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الهيدر: العنوان + زر عرض الكل
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.recentTransactions, style: AppTextStyles.h2),
            TextButton(
              onPressed: onSeeMorePressed,
              child: Text(
                l10n.seeAll,
                style: const TextStyle(fontFamily: 'Cairo'),
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
                l10n.noRecentTransactions,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          )
        else
          // عرض القائمة الديناميكية
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final category = tx.category.value;
              final isIncome = tx.baseAmount > 0;

              // تنسيق المبلغ بالعملة الأساسية
              final formattedBaseAmount =
                  '${isIncome ? "+" : ""}${tx.baseAmount.toStringAsFixed(2)} $baseCurrencyCode';

              // هل المعاملة تمت بعملة مختلفة عن العملة الأساسية؟
              final isDifferentCurrency = tx.currencyCode != baseCurrencyCode;
              final formattedOriginalAmount =
                  '${tx.amount.toStringAsFixed(2)} ${tx.currencyCode}';

              // تنسيق التاريخ بحسب لغة الجهاز الحالية (ar أو en)
              final formattedDate = DateFormat(
                'd MMMM - hh:mm a',
                locale,
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
                                category?.name ?? (tx.note ?? l10n.transaction),
                                style: AppTextStyles.h3,
                              ),
                              Text(
                                formattedDate,
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // 1. المبلغ الموحد بالعملة الأساسية
                            Text(
                              formattedBaseAmount,
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: isIncome
                                    ? AppColors.success
                                    : AppColors.danger,
                              ),
                            ),

                            // 2. إذا كانت العملية أُدخلت بعملة أجنبية، نعرض المبلغ الأصلي تحتها
                            if (isDifferentCurrency) ...[
                              const SizedBox(height: 2),
                              Text(
                                '($formattedOriginalAmount)',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),

                    // عرض الملاحظة أسفل التفاصيل
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
// import 'package:bills_app/core/constants/app_constants.dart';
// import 'package:bills_app/l10n/app_localizations.dart';
// import 'package:bills_app/model/transaction_model.dart';
// import 'package:flutter/material.dart';
// import 'package:heroicons/heroicons.dart';
// import 'package:intl/intl.dart';

// class RecentTransactionsList extends StatelessWidget {
//   final List<TransactionModel> transactions;
//   final VoidCallback onSeeMorePressed;

//   const RecentTransactionsList({
//     super.key,
//     required this.transactions,
//     required this.onSeeMorePressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     final locale = Localizations.localeOf(context).languageCode;

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // الهيدر: العنوان + زر عرض الكل
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(l10n.recentTransactions, style: AppTextStyles.h2),
//             TextButton(
//               onPressed: onSeeMorePressed,
//               child: Text(
//                 l10n.seeAll,
//                 style: const TextStyle(fontFamily: 'Cairo'),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: AppSpacing.sm),

//         // في حال كانت القائمة فارغة
//         if (transactions.isEmpty)
//           Container(
//             padding: const EdgeInsets.all(AppSpacing.lg),
//             width: double.infinity,
//             decoration: AppDecorations.cardDecoration,
//             child: Center(
//               child: Text(
//                 l10n.noRecentTransactions,
//                 style: AppTextStyles.bodyMedium.copyWith(
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//             ),
//           )
//         else
//           // عرض القائمة الديناميكية
//           ListView.separated(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: transactions.length,
//             separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
//             itemBuilder: (context, index) {
//               final tx = transactions[index];
//               final category = tx.category.value;
//               final isIncome = tx.amount > 0;
//               final formattedAmount =
//                   '${isIncome ? "+" : ""}${tx.amount.toStringAsFixed(2)} ${tx.currencyCode}';

//               // تنسيق التاريخ بحسب لغة الجهاز الحالية (ar أو en)
//               final formattedDate = DateFormat(
//                 'd MMMM - hh:mm a',
//                 locale,
//               ).format(tx.date);

//               return Container(
//                 padding: const EdgeInsets.all(AppSpacing.md),
//                 decoration: AppDecorations.cardDecoration,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // الصف الرئيسي: الأيقونة، الفئة/التاريخ، والمبلغ
//                     Row(
//                       children: [
//                         Container(
//                           width: 44,
//                           height: 44,
//                           decoration: BoxDecoration(
//                             color: isIncome
//                                 ? AppColors.success.withValues(alpha: 0.15)
//                                 : AppColors.danger.withValues(alpha: 0.15),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: Center(
//                             child: HeroIcon(
//                               _getHeroIconData(category?.iconName),
//                               color: isIncome
//                                   ? AppColors.success
//                                   : AppColors.danger,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: AppSpacing.md),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 category?.name ?? (tx.note ?? l10n.transaction),
//                                 style: AppTextStyles.h3,
//                               ),
//                               Text(
//                                 formattedDate,
//                                 style: AppTextStyles.bodySmall,
//                               ),
//                             ],
//                           ),
//                         ),
//                         Text(
//                           formattedAmount,
//                           style: TextStyle(
//                             fontFamily: 'Cairo',
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15,
//                             color: isIncome
//                                 ? AppColors.success
//                                 : AppColors.danger,
//                           ),
//                         ),
//                       ],
//                     ),

//                     // عرض الملاحظة أسفل التفاصيل
//                     if (tx.note != null && tx.note!.trim().isNotEmpty) ...[
//                       const SizedBox(height: AppSpacing.xs),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const HeroIcon(
//                             HeroIcons.documentText,
//                             size: 14,
//                             color: AppColors.textSecondary,
//                           ),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: Text(
//                               tx.note!,
//                               style: AppTextStyles.bodySmall.copyWith(
//                                 color: AppColors.textSecondary,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ],
//                 ),
//               );
//             },
//           ),
//       ],
//     );
//   }

//   HeroIcons _getHeroIconData(String? iconName) {
//     switch (iconName) {
//       case 'shoppingCart':
//         return HeroIcons.shoppingCart;
//       case 'academicCap':
//         return HeroIcons.academicCap;
//       case 'heart':
//         return HeroIcons.heart;
//       case 'film':
//         return HeroIcons.film;
//       case 'wrench':
//         return HeroIcons.wrench;
//       case 'banknotes':
//         return HeroIcons.banknotes;
//       case 'creditCard':
//         return HeroIcons.creditCard;
//       case 'briefcase':
//         return HeroIcons.briefcase;
//       case 'bolt':
//         return HeroIcons.bolt;
//       case 'shoppingBag':
//         return HeroIcons.shoppingBag;
//       case 'home':
//         return HeroIcons.home;
//       default:
//         return HeroIcons.tag;
//     }
//   }
// }
