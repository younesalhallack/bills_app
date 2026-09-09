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

  final List<Map<String, dynamic>> categories = [
    {'name': 'طعام', 'icon': HeroIcons.cake, 'color': AppColors.bgGroceries},
    {'name': 'سكن', 'icon': HeroIcons.home, 'color': AppColors.bgHousing},
    {'name': 'نقل', 'icon': HeroIcons.truck, 'color': AppColors.bgElectricity},
    {'name': 'راتب', 'icon': HeroIcons.briefcase, 'color': AppColors.bgSalary},
    {
      'name': 'تسوق',
      'icon': HeroIcons.shoppingBag,
      'color': AppColors.bgGroceries,
    },
    {
      'name': 'أخرى',
      'icon': HeroIcons.ellipsisHorizontal,
      'color': AppColors.divider,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // مراعاة كيبورد الموبايل عند الظهور
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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
            // مقبض السحب العلوي (Drag Handle)
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

            // عنوان النافذة
            const Center(
              child: Text('إضافة معاملة جديدة', style: AppTextStyles.h2),
            ),
            const SizedBox(height: AppSpacing.lg),

            // محول (مصروف / إيراد)
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
                      onTap: () => setState(() => isExpense = true),
                    ),
                  ),
                  Expanded(
                    child: _buildTypeButton(
                      title: 'إيراد',
                      isSelected: !isExpense,
                      color: AppColors.success,
                      onTap: () => setState(() => isExpense = false),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // حقل المبلغ
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

            // اختيار الفئة
            const Text('الفئة', style: AppTextStyles.bodySmall),
            const SizedBox(height: AppSpacing.xs),
            SizedBox(
              height: 45,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final isSelected = selectedCategory == cat['name'];

                  return ChoiceChip(
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

            // حقل التاريخ والملاحظة
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

            // زر الحفظ
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // هنا سنتولى حفظ البيانات لاحقاً
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
}
