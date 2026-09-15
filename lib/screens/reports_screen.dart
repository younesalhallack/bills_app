import 'package:bills_app/core/constants/app_constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';

import '../model/transaction_model.dart';
import '../providers/isar_providers.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  int _selectedView = 0; // 0: by category, 1: by monthly comparison
  int _categoryType = 0; // 0: expenses, 1: income
  DateTime _selectedDate = DateTime.now(); // الشهر المختار حالياً

  // قائمة ألوان افتراضية للفئات

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: transactionsAsync.when(
          data: (allTransactions) {
            // 1. تصفية معاملات الشهر المحدد
            final currentMonthTx = allTransactions.where((tx) {
              return tx.date.year == _selectedDate.year &&
                  tx.date.month == _selectedDate.month;
            }).toList();

            // 2. معالجة وتجميع بيانات الفئات للشهر المحدد
            final categoryData = _processCategoryData(currentMonthTx);

            // 3. معالجة بيانات المقارنة الشهرية (لآخر 3 أشهر)
            final monthlyComparisonData = _processMonthlyData(allTransactions);

            return SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                children: [
                  // محدد الشهر
                  _buildMonthPicker(),
                  const SizedBox(height: AppSpacing.md),

                  // شريط تبديل طريقة العرض
                  _buildViewToggle(),
                  const SizedBox(height: AppSpacing.md),

                  if (_selectedView == 0) ...[
                    _buildCategoryTypeToggle(),
                    const SizedBox(height: AppSpacing.lg),
                  ] else ...[
                    const SizedBox(height: AppSpacing.sm),
                  ],

                  // الرسم البياني (دائري أو أعمدة)
                  _selectedView == 0
                      ? _buildCategoryPieChartCard(categoryData)
                      : _buildMonthlyBarChartCard(monthlyComparisonData),

                  const SizedBox(height: AppSpacing.xl),

                  // تفاصيل الفئات
                  if (_selectedView == 0)
                    _buildCategoryBreakdownList(categoryData),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) =>
              Center(child: Text('حدث خطأ أثناء تحميل البيانات: $err')),
        ),
      ),
    );
  }

  // --- تجميع بيانات الفئات حسب نوع الحركة (إيراد/مصروف) ---
  List<Map<String, dynamic>> _processCategoryData(
    List<TransactionModel> monthTx,
  ) {
    final isExpense = _categoryType == 0;

    final filteredTx = monthTx.where((tx) {
      return isExpense ? tx.amount < 0 : tx.amount > 0;
    }).toList();

    double totalAmount = 0;
    final Map<String, Map<String, dynamic>> grouped = {};

    for (var tx in filteredTx) {
      final cat = tx.category.value;
      final catName = cat?.name ?? 'بدون فئة';
      final iconName = cat?.iconName;
      final amount = tx.amount.abs();
      totalAmount += amount;

      if (grouped.containsKey(catName)) {
        grouped[catName]!['amount'] += amount;
      } else {
        grouped[catName] = {
          'title': catName,
          'amount': amount,
          'iconName': iconName,
        };
      }
    }

    return grouped.values.map((item) {
      final double amount = item['amount'];
      final double percent = totalAmount > 0 ? (amount / totalAmount) * 100 : 0;
      final String title = item['title'];

      return {
        'title': title,
        'percent': '${percent.toStringAsFixed(1)}%',
        'value': percent,
        'amountValue': amount,
        'amount': '${amount.toStringAsFixed(2)} ر.س',
        'icon': _getHeroIconData(item['iconName']),
        'color': _getCategoryColor(title), // استخدام اللون المميز للفئة
      };
    }).toList();
  }

  // --- تجميع البيانات الشهرية للمقارنة (الشهر المختار والشهران السابقان) ---
  List<Map<String, dynamic>> _processMonthlyData(List<TransactionModel> allTx) {
    List<Map<String, dynamic>> monthsData = [];

    for (int i = 2; i >= 0; i--) {
      final targetDate = DateTime(
        _selectedDate.year,
        _selectedDate.month - i,
        1,
      );
      final monthTx = allTx.where(
        (tx) =>
            tx.date.year == targetDate.year &&
            tx.date.month == targetDate.month,
      );

      double income = 0;
      double expense = 0;

      for (var tx in monthTx) {
        if (tx.amount > 0) {
          income += tx.amount;
        } else {
          expense += tx.amount.abs();
        }
      }

      monthsData.add({
        'monthName': DateFormat('MMMM', 'ar').format(targetDate),
        'income': income,
        'expense': expense,
      });
    }

    return monthsData;
  }

  // --- AppBar ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: const Text('التقارير', style: AppTextStyles.h1),
      actions: [
        IconButton(
          icon: const HeroIcon(HeroIcons.bars3, color: AppColors.textPrimary),
          onPressed: () {},
        ),
      ],
      leading: Container(
        margin: const EdgeInsets.only(right: 16),
        child: IconButton(
          icon: const HeroIcon(HeroIcons.bell, color: AppColors.textPrimary),
          onPressed: () {},
        ),
      ),
    );
  }

  // --- محدد الشهر ---
  Widget _buildMonthPicker() {
    final formattedMonth = DateFormat('MMMM yyyy', 'ar').format(_selectedDate);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppSpacing.borderRadiusMd,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const HeroIcon(HeroIcons.chevronRight, size: 20),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime(
                  _selectedDate.year,
                  _selectedDate.month - 1,
                );
              });
            },
          ),
          Text(formattedMonth, style: AppTextStyles.h3),
          IconButton(
            icon: const HeroIcon(HeroIcons.chevronLeft, size: 20),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime(
                  _selectedDate.year,
                  _selectedDate.month + 1,
                );
              });
            },
          ),
        ],
      ),
    );
  }

  // --- شريط التبديل الرئيسي ---
  Widget _buildViewToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: 0.5),
        borderRadius: AppSpacing.borderRadiusMd,
      ),
      child: Row(
        children: [
          Expanded(
            child: _toggleButton(
              title: 'توزيع الفئات',
              isSelected: _selectedView == 0,
              onTap: () => setState(() => _selectedView = 0),
            ),
          ),
          Expanded(
            child: _toggleButton(
              title: 'مقارنة شهرية',
              isSelected: _selectedView == 1,
              onTap: () => setState(() => _selectedView = 1),
            ),
          ),
        ],
      ),
    );
  }

  // --- شريط تبديل نوع الفئة (إيراد / مصروف) ---
  Widget _buildCategoryTypeToggle() {
    return Row(
      children: [
        Expanded(
          child: _subToggleButton(
            title: 'المصاريف',
            isSelected: _categoryType == 0,
            activeColor: AppColors.danger,
            onTap: () => setState(() => _categoryType = 0),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _subToggleButton(
            title: 'الإيرادات',
            isSelected: _categoryType == 1,
            activeColor: AppColors.success,
            onTap: () => setState(() => _categoryType = 1),
          ),
        ),
      ],
    );
  }

  Widget _subToggleButton({
    required String title,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withValues(alpha: 0.12)
              : AppColors.cardBackground,
          borderRadius: AppSpacing.borderRadiusMd,
          border: Border.all(
            color: isSelected ? activeColor : AppColors.border,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? activeColor : AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _toggleButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.cardBackground : Colors.transparent,
          borderRadius: AppSpacing.borderRadiusMd,
          boxShadow: isSelected ? AppDecorations.softShadow : [],
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  // --- الرسم البياني الدائري للفئات ---
  Widget _buildCategoryPieChartCard(List<Map<String, dynamic>> categories) {
    final title = _categoryType == 0
        ? 'توزيع المصاريف حسب الفئة'
        : 'توزيع الإيرادات حسب الفئة';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecorations.cardDecoration,
      child: Column(
        children: [
          Text(title, style: AppTextStyles.h2),
          const SizedBox(height: AppSpacing.lg),
          categories.isEmpty
              ? const SizedBox(
                  height: 180,
                  child: Center(
                    child: Text(
                      'لا توجد بيانات لهذا الشهر',
                      style: AppTextStyles.bodySmall,
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 180,
                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          sections: categories.map((item) {
                            final double value = (item['value'] as num)
                                .toDouble();
                            final bool showTitle =
                                value >=
                                8; // إظهار النص داخل الدائرة فقط للنسب 8% فأكثر لضمان الوضوح

                            return PieChartSectionData(
                              color: item['color'] as Color,
                              value: value,
                              title: showTitle
                                  ? '${value.toStringAsFixed(0)}%'
                                  : '',
                              radius: 42,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // دليل الألوان (Legend) لعرض اسم الفئة والنسبة بشكل واضح تحت الرسم البياني
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: categories.map((item) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: item['color'] as Color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${item['title']} (${item['percent']})',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  // --- رسم الأعمدة البياني للمقارنة الشهرية ---
  Widget _buildMonthlyBarChartCard(List<Map<String, dynamic>> monthlyData) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: AppDecorations.cardDecoration,
      child: Column(
        children: [
          const Text('الإيرادات والمصاريف شهرياً', style: AppTextStyles.h2),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _indicator(AppColors.success, 'الإيرادات'),
              const SizedBox(width: AppSpacing.lg),
              _indicator(AppColors.danger, 'المصاريف'),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < monthlyData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              monthlyData[index]['monthName'],
                              style: AppTextStyles.bodySmall,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(monthlyData.length, (index) {
                  final data = monthlyData[index];
                  return _makeGroupData(
                    index,
                    (data['income'] as num).toDouble(),
                    (data['expense'] as num).toDouble(),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData _makeGroupData(int x, double income, double expense) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: income,
          color: AppColors.success,
          width: 12,
          borderRadius: BorderRadius.circular(4),
        ),
        BarChartRodData(
          toY: expense,
          color: AppColors.danger,
          width: 12,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }

  Widget _indicator(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: AppTextStyles.bodySmall),
      ],
    );
  }

  // --- قائمة تفاصيل الفئات والنسب ---
  Widget _buildCategoryBreakdownList(List<Map<String, dynamic>> categories) {
    final listTitle = _categoryType == 0
        ? 'تفاصيل المصاريف'
        : 'تفاصيل الإيرادات';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(listTitle, style: AppTextStyles.h2),
        const SizedBox(height: AppSpacing.sm),
        categories.isEmpty
            ? Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                width: double.infinity,
                decoration: AppDecorations.cardDecoration,
                child: const Center(
                  child: Text(
                    'لا توجد تفاصيل متاحة',
                    style: AppTextStyles.bodySmall,
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  return Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: AppDecorations.cardDecoration,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: (cat['color'] as Color).withValues(
                              alpha: .15,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: HeroIcon(
                              cat['icon'] as HeroIcons,
                              color: cat['color'] as Color,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat['title'] as String,
                                style: AppTextStyles.h3,
                              ),
                              Text(
                                'نسبة التحصيل/الاستهلاك: ${cat['percent']}',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          cat['amount'] as String,
                          style: AppTextStyles.amountMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
      ],
    );
  }

  // --- أيقونات الفئات ---
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
      case 'cake':
        return HeroIcons.cake;
      case 'truck':
        return HeroIcons.truck;
      default:
        return HeroIcons.tag;
    }
  }
}

// دالة لتوليد لون ثابت ومميز بناءً على اسم الفئة
Color _getCategoryColor(String categoryName) {
  final List<Color> palette = [
    const Color(0xFF10B981), // Emerald (مثلاً للراتب)
    const Color(0xFF3B82F6), // Blue (للعمل الحر)
    const Color(0xFFF59E0B), // Amber (استثمارات)
    const Color(0xFFEC4899), // Pink
    const Color(0xFF8B5CF6), // Purple
    const Color(0xFF06B6D4), // Cyan
    const Color(0xFFEF4444), // Red
    const Color(0xFF64748B), // Slate (أخرى)
  ];

  final int hash = categoryName.hashCode.abs();
  return palette[hash % palette.length];
}
