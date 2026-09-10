import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:bills_app/core/constants/app_constants.dart';

class CurrencySelectionScreen extends StatefulWidget {
  const CurrencySelectionScreen({super.key});

  @override
  State<CurrencySelectionScreen> createState() =>
      _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
  String _selectedCurrency = 'SAR';

  final List<Map<String, String>> _currencies = [
    {'code': 'SAR', 'name': 'ريال سعودي', 'symbol': 'ر.س'},
    {'code': 'AED', 'name': 'درهم إماراتي', 'symbol': 'د.إ'},
    {'code': 'USD', 'name': 'دولار أمريكي', 'symbol': '\$'},
    {'code': 'EUR', 'name': 'يورو', 'symbol': '€'},
    {'code': 'EGP', 'name': 'جنيه مصري', 'symbol': 'ج.م'},
    {'code': 'KWD', 'name': 'دينار كويتي', 'symbol': 'د.ك'},
    {'code': 'QAR', 'name': 'ريال قطري', 'symbol': 'ر.ق'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text('العملة الأساسية', style: AppTextStyles.h2),
        leading: IconButton(
          icon: const HeroIcon(
            HeroIcons.chevronRight,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context, _selectedCurrency),
        ),
      ),
      body: SafeArea(
        child: ListView.separated(
          padding: AppSpacing.screenPadding,
          itemCount: _currencies.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.xs),
          itemBuilder: (context, index) {
            final currency = _currencies[index];
            final bool isSelected = _selectedCurrency == currency['code'];

            return Container(
              decoration: AppDecorations.cardDecoration,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onTap: () {
                  setState(() => _selectedCurrency = currency['code']!);
                },
                leading: CircleAvatar(
                  backgroundColor: isSelected
                      ? AppColors.primary.withOpacity(0.1)
                      : AppColors.background,
                  child: Text(
                    currency['symbol']!,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(currency['name']!, style: AppTextStyles.bodyMedium),
                subtitle: Text(
                  currency['code']!,
                  style: AppTextStyles.bodySmall,
                ),
                trailing: isSelected
                    ? const HeroIcon(HeroIcons.check, color: AppColors.primary)
                    : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
