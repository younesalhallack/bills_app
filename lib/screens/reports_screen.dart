import 'package:bills_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:heroicons/heroicons.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _selectedView = 0; // 1:  by category, 0:by monthly
  int _categoryType = 0; // 0: income, 1: outcome
  final String _selectedMonth = 'ديسمبر 2023';

  // ---  outcome ---
  final List<Map<String, dynamic>> _expenseCategories = [
    {
      'title': 'الطعام',
      'percent': '40%',
      'value': 40.0,
      'amount': '1,640 ر.س',
      'icon': HeroIcons.cake,
      'color': AppColors.success,
    },
    {
      'title': 'السكن',
      'percent': '30%',
      'value': 30.0,
      'amount': '1,230 ر.س',
      'icon': HeroIcons.home,
      'color': AppColors.primary,
    },
    {
      'title': 'نقل',
      'percent': '15%',
      'value': 15.0,
      'amount': '615 ر.س',
      'icon': HeroIcons.truck,
      'color': AppColors.accent,
    },
    {
      'title': 'أخرى',
      'percent': '15%',
      'value': 15.0,
      'amount': '615 ر.س',
      'icon': HeroIcons.ellipsisHorizontal,
      'color': AppColors.textLight,
    },
  ];

  // ---  icome data ---
  final List<Map<String, dynamic>> _incomeCategories = [
    {
      'title': 'الراتب',
      'percent': '60%',
      'value': 60.0,
      'amount': '4,080 ر.س',
      'icon': HeroIcons.banknotes,
      'color': AppColors.success,
    },
    {
      'title': 'عمل حر',
      'percent': '25%',
      'value': 25.0,
      'amount': '1,700 ر.س',
      'icon': HeroIcons.briefcase,
      'color': AppColors.primary,
    },
    {
      'title': 'استثمارات',
      'percent': '10%',
      'value': 10.0,
      'amount': '680 ر.س',
      'icon': HeroIcons.chartBar,
      'color': AppColors.accent,
    },
    {
      'title': 'أخرى',
      'percent': '5%',
      'value': 5.0,
      'amount': '340 ر.س',
      'icon': HeroIcons.ellipsisHorizontal,
      'color': AppColors.textLight,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              //  Month Selector
              _buildMonthPicker(),
              const SizedBox(height: AppSpacing.md),

              //  Toggle View Bar
              _buildViewToggle(),
              const SizedBox(height: AppSpacing.md),

              if (_selectedView == 0) ...[
                _buildCategoryTypeToggle(),
                const SizedBox(height: AppSpacing.lg),
              ] else ...[
                const SizedBox(height: AppSpacing.sm),
              ],

              //
              _selectedView == 0
                  ? _buildCategoryPieChartCard()
                  : _buildMonthlyBarChartCard(),

              const SizedBox(height: AppSpacing.xl),

              // category Breakdown
              _buildCategoryBreakdownList(),
            ],
          ),
        ),
      ),
    );
  }

  // --- App bar  ---
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

  // ---chose a month---
  Widget _buildMonthPicker() {
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
            onPressed: () {},
          ),
          Text(_selectedMonth, style: AppTextStyles.h3),
          IconButton(
            icon: const HeroIcon(HeroIcons.chevronLeft, size: 20),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  // --- main toggle bar---
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

  // ---CategoryTypeToggle bar---
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

  //  destrepioted category based type piechart
  Widget _buildCategoryPieChartCard() {
    final currentData = _categoryType == 0
        ? _expenseCategories
        : _incomeCategories;
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
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 3,
                centerSpaceRadius: 50,
                sections: currentData.map((item) {
                  return PieChartSectionData(
                    color: item['color'] as Color,
                    value: (item['value'] as num).toDouble(),
                    title: '${item['title']} ${item['percent']}',
                    radius: 45,
                    titleStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // compare monthly barchart
  Widget _buildMonthlyBarChartCard() {
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
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const months = ['أكتوبر', 'نوفمبر', 'ديسمبر'];
                        if (value.toInt() < months.length) {
                          return Text(
                            months[value.toInt()],
                            style: AppTextStyles.bodySmall,
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                barGroups: [
                  _makeGroupData(0, 5000, 3200),
                  _makeGroupData(1, 6200, 4100),
                  _makeGroupData(2, 6800, 4100),
                ],
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

  // --- قائمة التفاصيل والنسب لكل فئة (ديناميكية حسب المصاريف/الإيرادات) ---
  Widget _buildCategoryBreakdownList() {
    final categories = _categoryType == 0
        ? _expenseCategories
        : _incomeCategories;
    final listTitle = _categoryType == 0
        ? 'تفاصيل المصاريف'
        : 'تفاصيل الإيرادات';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(listTitle, style: AppTextStyles.h2),
        const SizedBox(height: AppSpacing.sm),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
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
                      color: (cat['color'] as Color).withValues(alpha: .15),
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
                        Text(cat['title'] as String, style: AppTextStyles.h3),
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
}
