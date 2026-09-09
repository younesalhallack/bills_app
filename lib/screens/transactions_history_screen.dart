import 'package:bills_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class TransactionsHistoryScreen extends StatefulWidget {
  const TransactionsHistoryScreen({super.key});

  @override
  State<TransactionsHistoryScreen> createState() =>
      _TransactionsHistoryScreenState();
}

class _TransactionsHistoryScreenState extends State<TransactionsHistoryScreen> {
  int _selectedFilterIndex = 0; // 0: الكل, 1: مصاريف, 2: إيرادات
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filters = ['الكل', 'مصاريف', 'إيرادات'];

  @override
  Widget build(BuildContext context) {
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
                  hintText: 'البحث عن معاملة أو فئة...',
                  hintStyle: AppTextStyles.bodySmall,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: HeroIcon(
                      HeroIcons.magnifyingGlass,
                      color: AppColors.textSecondary,
                    ),
                  ),
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

              // 3. قائمة المعاملات الممتدة
              Expanded(
                child: ListView(
                  children: [
                    _buildDateHeader('اليوم - 15 ديسمبر'),
                    _buildTransactionItem(
                      'راتب',
                      '12:30 م',
                      '+4,500 ر.س',
                      true,
                      HeroIcons.briefcase,
                      AppColors.bgSalary,
                    ),
                    _buildTransactionItem(
                      'فاتورة كهرباء',
                      '04:15 م',
                      '-320 ر.س',
                      false,
                      HeroIcons.bolt,
                      AppColors.bgElectricity,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _buildDateHeader('الأمس - 14 ديسمبر'),
                    _buildTransactionItem(
                      'بقالة',
                      '08:20 م',
                      '-150 ر.س',
                      false,
                      HeroIcons.shoppingBag,
                      AppColors.bgGroceries,
                    ),
                    _buildTransactionItem(
                      'تعبئة وقود',
                      '01:10 م',
                      '-80 ر.س',
                      false,
                      HeroIcons.truck,
                      AppColors.bgElectricity,
                    ),
                    const SizedBox(height: AppSpacing.md),

                    _buildDateHeader('12 ديسمبر'),
                    _buildTransactionItem(
                      'إيجار السكن',
                      '10:00 ص',
                      '-1,200 ر.س',
                      false,
                      HeroIcons.home,
                      AppColors.bgHousing,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    Color bgColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: AppDecorations.cardDecoration,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: HeroIcon(icon, color: AppColors.textPrimary)),
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
              color: isIncome ? AppColors.success : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
