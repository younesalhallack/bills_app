import 'package:bills_app/core/constants/app_constants.dart';
import 'package:bills_app/l10n/app_localizations.dart';
import 'package:bills_app/model/categories_model.dart';
import 'package:bills_app/providers/isar_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';

class AddTransactionBottomSheet extends ConsumerStatefulWidget {
  const AddTransactionBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddTransactionBottomSheet(),
    );
  }

  @override
  ConsumerState<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState
    extends ConsumerState<AddTransactionBottomSheet> {
  bool isExpense = true;
  CategoriesModel? selectedCategory;
  DateTime selectedDate = DateTime.now();
  String? selectedCurrency; //  selected currency for this TRX

  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final currencyAsync = ref.watch(currencySettingsStreamProvider);

    return Container(
      padding: EdgeInsets.only(
        top: AppSpacing.lg,
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        bottom: AppSpacing.lg + bottomInset,
      ),
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Center(
              child: Text(l10n.addNewTransaction, style: AppTextStyles.h2),
            ),
            const SizedBox(height: AppSpacing.lg),

            //  TRX type(in/out)
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: AppSpacing.borderRadiusMd,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTypeButton(
                      title: l10n.expense,
                      isSelected: isExpense,
                      color: AppColors.danger,
                      onTap: () => setState(() {
                        isExpense = true;
                        selectedCategory = null;
                      }),
                    ),
                  ),
                  Expanded(
                    child: _buildTypeButton(
                      title: l10n.income,
                      isSelected: !isExpense,
                      color: AppColors.success,
                      onTap: () => setState(() {
                        isExpense = false;
                        selectedCategory = null;
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            //
            Text(l10n.amount, style: AppTextStyles.bodySmall),
            const SizedBox(height: AppSpacing.xs),
            currencyAsync.when(
              data: (currencySettings) {
                selectedCurrency ??= currencySettings.baseCurrencyCode;

                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        style: AppTextStyles.h1,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: l10n.amountHint,
                          hintStyle: AppTextStyles.h1.copyWith(
                            color: AppColors.textLight,
                          ),
                          filled: true,
                          fillColor: AppColors.background,
                          border: OutlineInputBorder(
                            borderRadius: AppSpacing.borderRadiusMd,
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    // select currency btn
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: AppSpacing.borderRadiusMd,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCurrency,
                          items: [
                            DropdownMenuItem(
                              value: currencySettings.baseCurrencyCode,
                              child: Text(
                                currencySettings.baseCurrencyCode,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DropdownMenuItem(
                              value: currencySettings.secondaryCurrencyCode,
                              child: Text(
                                currencySettings.secondaryCurrencyCode,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => selectedCurrency = val);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const SizedBox(),
            ),
            const SizedBox(height: AppSpacing.lg),

            //  language select
            Text(l10n.category, style: AppTextStyles.bodySmall),
            const SizedBox(height: AppSpacing.xs),
            SizedBox(
              height: 45,
              child: categoriesAsync.when(
                data: (allCategories) {
                  final targetType = isExpense ? 'expense' : 'income';
                  final filteredList = allCategories
                      .where((cat) => cat.type == targetType)
                      .toList();

                  if (filteredList.isNotEmpty) {
                    if (selectedCategory == null ||
                        !filteredList.any(
                          (cat) => cat.id == selectedCategory?.id,
                        )) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            selectedCategory = filteredList.first;
                          });
                        }
                      });
                    }
                  }

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredList.length + 1,
                    separatorBuilder: (_, _) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) {
                      if (index == filteredList.length) {
                        return ActionChip(
                          onPressed: () => _showAddCategoryDialog(l10n),
                          avatar: const Icon(
                            Icons.add,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          label: Text(
                            l10n.addCategory,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          side: const BorderSide(color: AppColors.primary),
                        );
                      }

                      final cat = filteredList[index];
                      final isSelected = selectedCategory?.id == cat.id;

                      return ChoiceChip(
                        avatar: HeroIcon(
                          _getHeroIconData(cat.iconName),
                          size: 18,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                        label: Text(cat.name),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) setState(() => selectedCategory = cat);
                        },
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.background,
                        labelStyle: TextStyle(
                          fontFamily: 'Cairo',
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) =>
                    Center(child: Text('${l10n.errorPrefix}: $err')),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            //  date&time select
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: AppSpacing.borderRadiusMd,
                      ),
                      child: Row(
                        children: [
                          const HeroIcon(
                            HeroIcons.calendarDays,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            //  note field
            TextField(
              controller: noteController,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: l10n.notesHint,
                hintStyle: AppTextStyles.bodySmall,
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: AppSpacing.borderRadiusMd,
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // save  btn
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => _saveTransaction(l10n),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  elevation: 0,
                ),
                child: Text(
                  l10n.addTransaction,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //  save TRX
  Future<void> _saveTransaction(AppLocalizations l10n) async {
    final amountText = amountController.text.trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseEnterAmount)));
      return;
    }

    final rawAmount = double.tryParse(amountText);
    if (rawAmount == null || rawAmount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseEnterValidAmount)));
      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseSelectCategory)));
      return;
    }

    // get current currency settings
    final currencySettings = ref.read(currencySettingsStreamProvider).value;
    final baseCurrency = currencySettings?.baseCurrencyCode ?? 'SAR';
    final secondaryCurrency = currencySettings?.secondaryCurrencyCode ?? 'USD';
    final rate = currencySettings?.secondaryExchangeRate ?? 1.0;

    final usedCurrency = selectedCurrency ?? baseCurrency;

    /// Set the exchange rate for the input currency
    double exchangeRate = 1.0;
    if (usedCurrency == secondaryCurrency) {
      exchangeRate = rate;
    }

    final inputAmount = isExpense ? -rawAmount : rawAmount;
    final calculatedBaseAmount = inputAmount * exchangeRate;

    // ----------------------- check available balance -----------------------
    if (isExpense) {
      final allTransactions = ref.read(transactionsStreamProvider).value ?? [];

      //// Calculate the total available balance in the base currency
      double currentBaseBalance = 0;
      for (var tx in allTransactions) {
        currentBaseBalance += tx.baseAmount;
      }

      //// Compare the amount to be deducted in the base currency
      if (calculatedBaseAmount.abs() > currentBaseBalance) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.insufficientBalanceError(
                currentBaseBalance.toStringAsFixed(2),
              ),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }
    }
    // --------------------------------------------------------------------------

    await ref
        .read(transactionNotifierProvider.notifier)
        .addTransaction(
          amount: inputAmount,
          date: selectedDate,
          currencyCode: usedCurrency,
          exchangeRate: exchangeRate,
          baseAmount: calculatedBaseAmount,
          category: selectedCategory!,
          note: noteController.text.trim().isEmpty
              ? null
              : noteController.text.trim(),
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.transactionAddedSuccess),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.pop(context);
    }
  }

  Widget _buildTypeButton({
    required String title,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          borderRadius: AppSpacing.borderRadiusMd,
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
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

  void _showAddCategoryDialog(AppLocalizations l10n) {
    final categoryNameController = TextEditingController();
    bool newCategoryIsExpense = isExpense;
    HeroIcons selectedIcon = HeroIcons.tag;

    final availableIcons = [
      HeroIcons.tag,
      HeroIcons.shoppingCart,
      HeroIcons.academicCap,
      HeroIcons.heart,
      HeroIcons.film,
      HeroIcons.wrench,
      HeroIcons.banknotes,
      HeroIcons.creditCard,
    ];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppColors.cardBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              ),
              title: Text(
                l10n.addNewCategory,
                textAlign: TextAlign.center,
                style: AppTextStyles.h2,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: Center(child: Text(l10n.expense)),
                            selected: newCategoryIsExpense,
                            selectedColor: AppColors.danger,
                            onSelected: (val) {
                              setDialogState(() => newCategoryIsExpense = true);
                            },
                            labelStyle: TextStyle(
                              fontFamily: 'Cairo',
                              color: newCategoryIsExpense
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Expanded(
                          child: ChoiceChip(
                            label: Center(child: Text(l10n.income)),
                            selected: !newCategoryIsExpense,
                            selectedColor: AppColors.success,
                            onSelected: (val) {
                              setDialogState(
                                () => newCategoryIsExpense = false,
                              );
                            },
                            labelStyle: TextStyle(
                              fontFamily: 'Cairo',
                              color: !newCategoryIsExpense
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    TextField(
                      controller: categoryNameController,
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: l10n.categoryNameHint,
                        hintStyle: AppTextStyles.bodySmall,
                        filled: true,
                        fillColor: AppColors.background,
                        border: OutlineInputBorder(
                          borderRadius: AppSpacing.borderRadiusMd,
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    Text(l10n.chooseIcon, style: AppTextStyles.bodySmall),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: availableIcons.map((icon) {
                        final isSelected = selectedIcon == icon;
                        return InkWell(
                          onTap: () =>
                              setDialogState(() => selectedIcon = icon),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: HeroIcon(
                              icon,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textPrimary,
                              size: 22,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    l10n.cancel,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: AppSpacing.borderRadiusMd,
                    ),
                  ),
                  onPressed: () async {
                    final name = categoryNameController.text.trim();
                    if (name.isNotEmpty) {
                      await ref
                          .read(categoryNotifierProvider.notifier)
                          .addCategory(
                            name: name,
                            iconName: selectedIcon.name,
                            type: newCategoryIsExpense ? 'expense' : 'income',
                          );

                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: Text(
                    l10n.add,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
