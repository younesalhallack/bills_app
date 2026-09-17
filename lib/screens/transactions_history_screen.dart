import 'package:bills_app/core/constants/app_constants.dart';
import 'package:bills_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

import '../model/transaction_model.dart';
import '../providers/isar_providers.dart';

class TransactionsHistoryScreen extends ConsumerStatefulWidget {
  const TransactionsHistoryScreen({super.key});

  @override
  ConsumerState<TransactionsHistoryScreen> createState() =>
      _TransactionsHistoryScreenState();
}

class _TransactionsHistoryScreenState
    extends ConsumerState<TransactionsHistoryScreen> {
  int _selectedFilterIndex =
      0; // 0: الكل/All, 1: مصاريف/outcome, 2: إيرادات/Income
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> _getFilterLabels(AppLocalizations l10n) {
    return [l10n.all, l10n.expenses, l10n.income];
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsStreamProvider);
    final currencySettings = ref.watch(currencySettingsStreamProvider).value;
    final baseCurrencyCode = currencySettings?.baseCurrencyCode ?? '';

    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final filters = _getFilterLabels(l10n);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(l10n.transactionHistory, style: AppTextStyles.h1),
        actions: [
          IconButton(
            icon: const HeroIcon(
              HeroIcons.adjustmentsHorizontal,
              color: AppColors.textPrimary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              // search bar
              TextField(
                controller: _searchController,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  hintText: l10n.searchTransactionOrNote,
                  hintStyle: AppTextStyles.bodySmall,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: HeroIcon(
                      HeroIcons.magnifyingGlass,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => _searchController.clear(),
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: AppSpacing.borderRadiusLg,
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppSpacing.borderRadiusLg,
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              //  quick filtters
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedFilterIndex == index;
                    return ChoiceChip(
                      label: Text(filters[index]),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) setState(() => _selectedFilterIndex = index);
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.cardBackground,
                      labelStyle: TextStyle(
                        fontFamily: 'Cairo',
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Expanded(
                child: transactionsAsync.when(
                  data: (allTransactions) {
                    final filteredList = allTransactions.where((tx) {
                      final categoryName = tx.category.value?.name ?? '';
                      final note = tx.note ?? '';

                      final matchesSearch =
                          categoryName.toLowerCase().contains(_searchQuery) ||
                          note.toLowerCase().contains(_searchQuery);

                      bool matchesType = true;
                      if (_selectedFilterIndex == 1) {
                        matchesType = tx.baseAmount < 0;
                      } else if (_selectedFilterIndex == 2) {
                        matchesType = tx.baseAmount > 0;
                      }

                      return matchesSearch && matchesType;
                    }).toList();

                    if (filteredList.isEmpty) {
                      return Center(
                        child: Text(
                          _searchQuery.isNotEmpty || _selectedFilterIndex != 0
                              ? l10n.noMatchingResults
                              : l10n.noTransactionsYet,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }

                    final groupedTransactions = _groupTransactionsByDate(
                      filteredList,
                      l10n,
                      locale,
                    );

                    return ListView.builder(
                      itemCount: groupedTransactions.length,
                      itemBuilder: (context, index) {
                        final dateHeader = groupedTransactions.keys.elementAt(
                          index,
                        );
                        final dayTransactions =
                            groupedTransactions[dateHeader]!;
                        final formatter = NumberFormat('#,##0.00', 'en_US');

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDateHeader(dateHeader),
                            ...dayTransactions.map((tx) {
                              final category = tx.category.value;
                              final isIncome = tx.baseAmount > 0;
                              final formattedBaseAmountValue = formatter.format(
                                tx.baseAmount.abs(),
                              );
                              final formattedBaseAmount =
                                  '${isIncome ? "+" : ""}$formattedBaseAmountValue $baseCurrencyCode';

                              final isDifferentCurrency =
                                  tx.currencyCode != baseCurrencyCode;
                              final formattedOriginalAmountValue = formatter
                                  .format(tx.amount.abs());
                              final formattedOriginalAmount =
                                  '$formattedOriginalAmountValue ${tx.currencyCode}';

                              final formattedTime = DateFormat(
                                'hh:mm a',
                                locale,
                              ).format(tx.date);

                              return _buildTransactionItem(
                                title:
                                    category?.name ??
                                    (tx.note ?? l10n.transaction),
                                time: formattedTime,
                                formattedBaseAmount: formattedBaseAmount,
                                formattedOriginalAmount: isDifferentCurrency
                                    ? formattedOriginalAmount
                                    : null,
                                isIncome: isIncome,
                                icon: _getHeroIconData(category?.iconName),
                                note: tx.note,
                              );
                            }),
                            const SizedBox(height: AppSpacing.sm),
                          ],
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (err, stack) =>
                      Center(child: Text('${l10n.errorLoadingData}: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Group transactions by date to support different languages
  Map<String, List<TransactionModel>> _groupTransactionsByDate(
    List<TransactionModel> transactions,
    AppLocalizations l10n,
    String locale,
  ) {
    final Map<String, List<TransactionModel>> groups = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var tx in transactions) {
      final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);
      String dateKey;

      if (txDate == today) {
        dateKey =
            '${l10n.today} - ${DateFormat('d MMMM', locale).format(tx.date)}';
      } else if (txDate == yesterday) {
        dateKey =
            '${l10n.yesterday} - ${DateFormat('d MMMM', locale).format(tx.date)}';
      } else {
        dateKey = DateFormat('d MMMM yyyy', locale).format(tx.date);
      }

      if (!groups.containsKey(dateKey)) {
        groups[dateKey] = [];
      }
      groups[dateKey]!.add(tx);
    }
    return groups;
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
      default:
        return HeroIcons.tag;
    }
  }

  Widget _buildDateHeader(String date) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text(
        date,
        style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTransactionItem({
    required String title,
    required String time,
    required String formattedBaseAmount,
    String? formattedOriginalAmount,
    required bool isIncome,
    required HeroIcons icon,
    String? note,
  }) {
    final color = isIncome ? AppColors.success : AppColors.danger;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
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
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: HeroIcon(icon, color: color)),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.h3),
                    Text(time, style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // amount in base currency
                  Text(
                    formattedBaseAmount,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: color,
                    ),
                  ),

                  //  The original amount if the transaction was in a different currency
                  if (formattedOriginalAmount != null) ...[
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
          if (note != null && note.trim().isNotEmpty) ...[
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
                    note,
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
  }
}
