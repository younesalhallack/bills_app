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
  //formate amount num
  String _formatAmount(double value) {
    final formatter = NumberFormat('#,##0.00', 'en_US');
    return formatter.format(value.abs());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    //  get base currency
    final currencySettings = ref.watch(currencySettingsStreamProvider).value;
    final baseCurrencyCode = currencySettings?.baseCurrencyCode ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // see All btn
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
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final category = tx.category.value;
              final isIncome = tx.baseAmount > 0;

              final formattedBaseAmount =
                  '${isIncome ? "+" : "-"}${_formatAmount(tx.baseAmount)} $baseCurrencyCode';

              final isDifferentCurrency = tx.currencyCode != baseCurrencyCode;
              final formattedOriginalAmount =
                  '${_formatAmount(tx.amount)} ${tx.currencyCode}';

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

                            //  check currency if base
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

                    //  note view
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
