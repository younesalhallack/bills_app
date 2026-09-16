import 'package:bills_app/core/constants/app_constants.dart';
import 'package:bills_app/l10n/app_localizations.dart';
import 'package:bills_app/screens/transactions_history_screen.dart';
import 'package:bills_app/widgets/balance_card.dart';
import 'package:bills_app/widgets/recent_transactions_list.dart';
import 'package:bills_app/widgets/summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

import '../model/transaction_model.dart';
import '../providers/isar_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context, l10n),
      body: SafeArea(
        child: transactionsAsync.when(
          data: (allTransactions) {
            // 1. حساب الإيرادات والمصاريف
            double totalIncome = 0;
            double totalExpenses = 0;

            for (var tx in allTransactions) {
              if (tx.amount > 0) {
                totalIncome += tx.amount;
              } else {
                totalExpenses += tx.amount.abs();
              }
            }

            final netBalance = totalIncome - totalExpenses;

            // 2. تصفية أحدث 4 حركات
            final recentFourTransactions = allTransactions.take(4).toList();

            return LayoutBuilder(
              builder: (context, constraints) {
                bool isTablet = constraints.maxWidth >= 600;

                return SingleChildScrollView(
                  padding: AppSpacing.screenPadding,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isTablet)
                            _buildTabletLayout(
                              context,
                              l10n: l10n,
                              netBalance: netBalance,
                              income: totalIncome,
                              expenses: totalExpenses,
                              allTransactions: allTransactions,
                              recentTransactions: recentFourTransactions,
                            )
                          else
                            _buildMobileLayout(
                              context,
                              l10n: l10n,
                              netBalance: netBalance,
                              income: totalIncome,
                              expenses: totalExpenses,
                              allTransactions: allTransactions,
                              recentTransactions: recentFourTransactions,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) =>
              Center(child: Text('${l10n.errorLoadingData}: $err')),
        ),
      ),
    );
  }

  // AppBar
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    // تحديد هامش الزر حسب اتجاه اللغة لمنع أخطاء التصميم
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final margin = isArabic
        ? const EdgeInsets.only(left: 16)
        : const EdgeInsets.only(right: 16);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 70,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.appName, style: AppTextStyles.bodySmall),
          const SizedBox(height: 2),
          Text(l10n.welcomeUser('أحمد'), style: AppTextStyles.h1),
        ],
      ),
      actions: [
        Container(
          margin: margin,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: IconButton(
            icon: const HeroIcon(HeroIcons.bell, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  // Mobile Layout
  Widget _buildMobileLayout(
    BuildContext context, {
    required AppLocalizations l10n,
    required double netBalance,
    required double income,
    required double expenses,
    required List<TransactionModel> allTransactions,
    required List<TransactionModel> recentTransactions,
  }) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final currencySymbol = isArabic ? 'ر.س' : 'SAR';

    return Column(
      children: [
        BalanceCard(amount: netBalance, transactions: allTransactions),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: SummaryCard(
                title: l10n.expenses,
                amount: '${expenses.toStringAsFixed(2)} $currencySymbol',
                isIncome: false,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: SummaryCard(
                title: l10n.income,
                amount: '${income.toStringAsFixed(2)} $currencySymbol',
                isIncome: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),
        RecentTransactionsList(
          transactions: recentTransactions,
          onSeeMorePressed: () => _navigateToHistoryScreen(context),
        ),
      ],
    );
  }

  // Tablet Layout
  Widget _buildTabletLayout(
    BuildContext context, {
    required AppLocalizations l10n,
    required double netBalance,
    required double income,
    required double expenses,
    required List<TransactionModel> allTransactions,
    required List<TransactionModel> recentTransactions,
  }) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final currencySymbol = isArabic ? 'ر.س' : 'SAR';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            children: [
              BalanceCard(amount: netBalance, transactions: allTransactions),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: SummaryCard(
                      title: l10n.expenses,
                      amount: '${expenses.toStringAsFixed(2)} $currencySymbol',
                      isIncome: false,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: SummaryCard(
                      title: l10n.income,
                      amount: '${income.toStringAsFixed(2)} $currencySymbol',
                      isIncome: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          flex: 6,
          child: RecentTransactionsList(
            transactions: recentTransactions,
            onSeeMorePressed: () => _navigateToHistoryScreen(context),
          ),
        ),
      ],
    );
  }

  void _navigateToHistoryScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TransactionsHistoryScreen(),
      ),
    );
  }
}
