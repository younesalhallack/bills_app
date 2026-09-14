import 'package:bills_app/core/constants/app_constants.dart';
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
  int _selectedFilterIndex = 0; // 0: الكل, 1: مصاريف, 2: إيرادات
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _filters = ['الكل', 'مصاريف', 'إيرادات'];

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

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('سجل المعاملات', style: AppTextStyles.h1),
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
              // 1. شريط البحث
              TextField(
                controller: _searchController,
                style: AppTextStyles.bodyMedium,
                decoration: InputDecoration(
                  hintText: 'البحث عن معاملة أو ملاحظة...',
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

              // 2. الفلاتر السريعة (Chips)
              SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filters.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final isSelected = _selectedFilterIndex == index;
                    return ChoiceChip(
                      label: Text(_filters[index]),
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

              // 3. قائمة المعاملات الممتدة مع تطبيق الفلاتر والبحث
              Expanded(
                child: transactionsAsync.when(
                  data: (allTransactions) {
                    // تطبيق الفلترة بالبحث والنوع
                    final filteredList = allTransactions.where((tx) {
                      final categoryName = tx.category.value?.name ?? '';
                      final note = tx.note ?? '';

                      // أ) التصفية بحسب نص البحث
                      final matchesSearch =
                          categoryName.toLowerCase().contains(_searchQuery) ||
                          note.toLowerCase().contains(_searchQuery);

                      // ب) التصفية بحسب النوع (0: الكل، 1: مصاريف، 2: إيرادات)
                      bool matchesType = true;
                      if (_selectedFilterIndex == 1) {
                        matchesType = tx.amount < 0;
                      } else if (_selectedFilterIndex == 2) {
                        matchesType = tx.amount > 0;
                      }

                      return matchesSearch && matchesType;
                    }).toList();

                    if (filteredList.isEmpty) {
                      return Center(
                        child: Text(
                          _searchQuery.isNotEmpty || _selectedFilterIndex != 0
                              ? 'لا توجد نتائج تطابق التصفية'
                              : 'لا توجد معاملات مسجلة حتى الآن',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }

                    // ج) تجميع المعاملات المفلترة حسب التاريخ
                    final groupedTransactions = _groupTransactionsByDate(
                      filteredList,
                    );

                    return ListView.builder(
                      itemCount: groupedTransactions.length,
                      itemBuilder: (context, index) {
                        final dateHeader = groupedTransactions.keys.elementAt(
                          index,
                        );
                        final dayTransactions =
                            groupedTransactions[dateHeader]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDateHeader(dateHeader),
                            ...dayTransactions.map((tx) {
                              final category = tx.category.value;
                              final isIncome = tx.amount > 0;
                              final formattedAmount =
                                  '${isIncome ? "+" : ""}${tx.amount.toStringAsFixed(2)} ${tx.currencyCode}';
                              final formattedTime = DateFormat(
                                'hh:mm a',
                                'ar',
                              ).format(tx.date);

                              return _buildTransactionItem(
                                category?.name ?? (tx.note ?? 'معاملة'),
                                formattedTime,
                                formattedAmount,
                                isIncome,
                                _getHeroIconData(category?.iconName),
                                isIncome
                                    ? AppColors.success.withValues(alpha: 0.15)
                                    : AppColors.danger.withValues(alpha: 0.15),
                                tx.note,
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
                      Center(child: Text('حدث خطأ في تحميل البيانات: $err')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // تجميع المعاملات بحسب التاريخ
  Map<String, List<TransactionModel>> _groupTransactionsByDate(
    List<TransactionModel> transactions,
  ) {
    final Map<String, List<TransactionModel>> groups = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var tx in transactions) {
      final txDate = DateTime(tx.date.year, tx.date.month, tx.date.day);
      String dateKey;

      if (txDate == today) {
        dateKey = 'اليوم - ${DateFormat('d MMMM', 'ar').format(tx.date)}';
      } else if (txDate == yesterday) {
        dateKey = 'الأمس - ${DateFormat('d MMMM', 'ar').format(tx.date)}';
      } else {
        dateKey = DateFormat('d MMMM yyyy', 'ar').format(tx.date);
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

  Widget _buildTransactionItem(
    String title,
    String time,
    String amount,
    bool isIncome,
    HeroIcons icon,
    Color bgColor, [
    String? note,
  ]) {
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
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: HeroIcon(icon, color: AppColors.textPrimary),
                ),
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
              Text(
                amount,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: isIncome ? AppColors.success : AppColors.danger,
                ),
              ),
            ],
          ),

          // قسم الملاحظات بدون خط فاصل (تم حذف الـ Divider)
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
