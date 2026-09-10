import 'package:bills_app/core/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class AddTransactionBottomSheet extends StatefulWidget {
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
  State<AddTransactionBottomSheet> createState() =>
      _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  bool isExpense = true;
  String selectedCategory = 'طعام';
  DateTime selectedDate = DateTime.now();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  List<Map<String, dynamic>> categories = [
    //
    {
      'name': 'طعام',
      'icon': HeroIcons.cake,
      'color': AppColors.bgGroceries,
      'isExpense': true,
    },
    {
      'name': 'سكن',
      'icon': HeroIcons.home,
      'color': AppColors.bgHousing,
      'isExpense': true,
    },
    {
      'name': 'نقل',
      'icon': HeroIcons.truck,
      'color': AppColors.bgElectricity,
      'isExpense': true,
    },
    {
      'name': 'تسوق',
      'icon': HeroIcons.shoppingBag,
      'color': AppColors.bgGroceries,
      'isExpense': true,
    },

    //
    {
      'name': 'راتب',
      'icon': HeroIcons.briefcase,
      'color': AppColors.bgSalary,
      'isExpense': false,
    },
    {
      'name': 'مكافأة',
      'icon': HeroIcons.gift,
      'color': AppColors.bgSalary,
      'isExpense': false,
    },
    {
      'name': 'استثمار',
      'icon': HeroIcons.chartBar,
      'color': AppColors.bgSalary,
      'isExpense': false,
    },

    //
    {
      'name': 'أخرى',
      'icon': HeroIcons.ellipsisHorizontal,
      'color': AppColors.divider,
      'isExpense': true,
    },
  ];

  // filter base on type
  List<Map<String, dynamic>> get _filteredCategories {
    return categories.where((cat) => cat['isExpense'] == isExpense).toList();
  }

  @override
  void dispose() {
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final filteredList = _filteredCategories;

    if (!filteredList.any((cat) => cat['name'] == selectedCategory) &&
        filteredList.isNotEmpty) {
      selectedCategory = filteredList.first['name'];
    }

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

            const Center(
              child: Text('إضافة معاملة جديدة', style: AppTextStyles.h2),
            ),
            const SizedBox(height: AppSpacing.lg),

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
                      title: 'مصروف',
                      isSelected: isExpense,
                      color: AppColors.danger,
                      onTap: () => setState(() {
                        isExpense = true;
                      }),
                    ),
                  ),
                  Expanded(
                    child: _buildTypeButton(
                      title: 'إيراد',
                      isSelected: !isExpense,
                      color: AppColors.success,
                      onTap: () => setState(() {
                        isExpense = false;
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            //  amount field
            const Text('المبلغ', style: AppTextStyles.bodySmall),
            const SizedBox(height: AppSpacing.xs),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              style: AppTextStyles.h1,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: '0.00 ر.س',
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
            const SizedBox(height: AppSpacing.lg),

            const Text('الفئة', style: AppTextStyles.bodySmall),
            const SizedBox(height: AppSpacing.xs),
            SizedBox(
              height: 45,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filteredList.length + 1,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  if (index == filteredList.length) {
                    return ActionChip(
                      onPressed: _showAddCategoryDialog,
                      avatar: const Icon(
                        Icons.add,
                        size: 18,
                        color: AppColors.primary,
                      ),
                      label: const Text(
                        'إضافة فئة',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      side: const BorderSide(color: AppColors.primary),
                    );
                  }

                  final cat = filteredList[index];
                  final isSelected = selectedCategory == cat['name'];

                  return ChoiceChip(
                    avatar: HeroIcon(
                      cat['icon'] as HeroIcons,
                      size: 18,
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                    label: Text(cat['name']),
                    selected: isSelected,
                    onSelected: (val) {
                      if (val) setState(() => selectedCategory = cat['name']);
                    },
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.background,
                    labelStyle: TextStyle(
                      fontFamily: 'Cairo',
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

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

            TextField(
              controller: noteController,
              style: AppTextStyles.bodyMedium,
              decoration: InputDecoration(
                hintText: 'أضف ملاحظة أو وصف (اختياري)...',
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

            // save
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.borderRadiusMd,
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'إضافة المعاملة',
                  style: TextStyle(
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

  void _showAddCategoryDialog() {
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
              title: const Text(
                'إضافة فئة جديدة',
                textAlign: TextAlign.center,
                style: AppTextStyles.h2,
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //    chose category type
                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('مصروف')),
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
                            label: const Center(child: Text('إيراد')),
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

                    // category name
                    TextField(
                      controller: categoryNameController,
                      style: AppTextStyles.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'اسم الفئة (مثال: هدايا، تعليم)...',
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

                    // category icon
                    const Text('اختر أيقونة:', style: AppTextStyles.bodySmall),
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
                  child: const Text(
                    'إلغاء',
                    style: TextStyle(
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
                  onPressed: () {
                    final name = categoryNameController.text.trim();
                    if (name.isNotEmpty) {
                      setState(() {
                        categories.add({
                          'name': name,
                          'icon': selectedIcon,
                          'color': AppColors.primary,
                          'isExpense': newCategoryIsExpense,
                        });

                        isExpense = newCategoryIsExpense;
                        selectedCategory = name;
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'إضافة',
                    style: TextStyle(
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
