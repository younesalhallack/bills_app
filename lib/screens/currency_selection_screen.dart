import 'package:bills_app/core/constants/app_constants.dart';
import 'package:bills_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class CurrencySelectionScreen extends StatefulWidget {
  const CurrencySelectionScreen({super.key});

  @override
  State<CurrencySelectionScreen> createState() =>
      _CurrencySelectionScreenState();
}

class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
  String _selectedCurrency = 'SAR';

  List<Map<String, String>> _getCurrencies(AppLocalizations l10n) {
    return [
      {'code': 'SAR', 'name': l10n.currencySar, 'symbol': l10n.symbolSar},
      {'code': 'AED', 'name': l10n.currencyAed, 'symbol': l10n.symbolAed},
      {'code': 'USD', 'name': l10n.currencyUsd, 'symbol': '\$'},
      {'code': 'EUR', 'name': l10n.currencyEur, 'symbol': '€'},
      {'code': 'EGP', 'name': l10n.currencySyr, 'symbol': l10n.symbolEgp},
      {'code': 'KWD', 'name': l10n.currencyKwd, 'symbol': l10n.symbolKwd},
      {'code': 'QAR', 'name': l10n.currencyQar, 'symbol': l10n.symbolQar},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currencies = _getCurrencies(l10n);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(l10n.mainCurrency, style: AppTextStyles.h2),
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
          itemCount: currencies.length,
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSpacing.xs),
          itemBuilder: (context, index) {
            final currency = currencies[index];
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
                      ? AppColors.primary.withValues(alpha: 0.1)
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
