import 'package:bills_app/model/currency_settings_model.dart';
import 'package:bills_app/providers/isar_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencySettingsScreen extends ConsumerStatefulWidget {
  const CurrencySettingsScreen({super.key});

  @override
  ConsumerState<CurrencySettingsScreen> createState() =>
      _CurrencySettingsScreenState();
}

class _CurrencySettingsScreenState
    extends ConsumerState<CurrencySettingsScreen> {
  final _rateController = TextEditingController();
  late String selectedBase;
  late String selectedSecondary;
  bool isInitialized = false;

  final List<String> availableCurrencies = [
    'SAR',
    'USD',
    'EUR',
    'EGP',
    'AED',
    'IQD',
    'SYP',
  ];

  void _initData(CurrencySettingsModel settings) {
    if (!isInitialized) {
      selectedBase = settings.baseCurrencyCode;
      selectedSecondary = settings.secondaryCurrencyCode;
      _rateController.text = settings.secondaryExchangeRate.toString();
      isInitialized = true;
    }
  }

  @override
  void dispose() {
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyAsync = ref.watch(currencySettingsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('إعدادات العملات')),
      body: currencyAsync.when(
        data: (settings) {
          _initData(settings);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('العملة الأساسية (الافتراضية)'),
                DropdownButtonFormField<String>(
                  value: availableCurrencies.contains(selectedBase)
                      ? selectedBase
                      : availableCurrencies.first,
                  items: availableCurrencies
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedBase = val!),
                ),
                const SizedBox(height: 16),
                const Text('العملة الثانوية'),
                DropdownButtonFormField<String>(
                  value: availableCurrencies.contains(selectedSecondary)
                      ? selectedSecondary
                      : availableCurrencies[1],
                  items: availableCurrencies
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) => setState(() => selectedSecondary = val!),
                ),
                const SizedBox(height: 16),
                Text('سعر الصرف (1 $selectedSecondary = كم بـ $selectedBase؟)'),
                const SizedBox(height: 8),
                TextField(
                  controller: _rateController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'أدخل سعر الصرف',
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      final rate = double.tryParse(_rateController.text) ?? 1.0;
                      await ref
                          .read(currencyNotifierProvider.notifier)
                          .updateCurrencySettings(
                            baseCurrency: selectedBase,
                            secondaryCurrency: selectedSecondary,
                            exchangeRate: rate,
                          );
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Text('حفظ الإعدادات'),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('خطأ: $e')),
      ),
    );
  }
}
// import 'package:bills_app/core/constants/app_constants.dart';
// import 'package:bills_app/l10n/app_localizations.dart';
// import 'package:flutter/material.dart';
// import 'package:heroicons/heroicons.dart';

// class CurrencySelectionScreen extends StatefulWidget {
//   const CurrencySelectionScreen({super.key});

//   @override
//   State<CurrencySelectionScreen> createState() =>
//       _CurrencySelectionScreenState();
// }

// class _CurrencySelectionScreenState extends State<CurrencySelectionScreen> {
//   String _selectedCurrency = 'SAR';

//   List<Map<String, String>> _getCurrencies(AppLocalizations l10n) {
//     return [
//       {'code': 'SAR', 'name': l10n.currencySar, 'symbol': l10n.symbolSar},
//       {'code': 'AED', 'name': l10n.currencyAed, 'symbol': l10n.symbolAed},
//       {'code': 'USD', 'name': l10n.currencyUsd, 'symbol': '\$'},
//       {'code': 'EUR', 'name': l10n.currencyEur, 'symbol': '€'},
//       {'code': 'EGP', 'name': l10n.currencySyr, 'symbol': l10n.symbolEgp},
//       {'code': 'KWD', 'name': l10n.currencyKwd, 'symbol': l10n.symbolKwd},
//       {'code': 'QAR', 'name': l10n.currencyQar, 'symbol': l10n.symbolQar},
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final l10n = AppLocalizations.of(context)!;
//     final currencies = _getCurrencies(l10n);

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         title: Text(l10n.mainCurrency, style: AppTextStyles.h2),
//         leading: IconButton(
//           icon: const HeroIcon(
//             HeroIcons.chevronRight,
//             color: AppColors.textPrimary,
//           ),
//           onPressed: () => Navigator.pop(context, _selectedCurrency),
//         ),
//       ),
//       body: SafeArea(
//         child: ListView.separated(
//           padding: AppSpacing.screenPadding,
//           itemCount: currencies.length,
//           separatorBuilder: (context, index) =>
//               const SizedBox(height: AppSpacing.xs),
//           itemBuilder: (context, index) {
//             final currency = currencies[index];
//             final bool isSelected = _selectedCurrency == currency['code'];

//             return Container(
//               decoration: AppDecorations.cardDecoration,
//               child: ListTile(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 onTap: () {
//                   setState(() => _selectedCurrency = currency['code']!);
//                 },
//                 leading: CircleAvatar(
//                   backgroundColor: isSelected
//                       ? AppColors.primary.withValues(alpha: 0.1)
//                       : AppColors.background,
//                   child: Text(
//                     currency['symbol']!,
//                     style: TextStyle(
//                       fontFamily: 'Cairo',
//                       color: isSelected
//                           ? AppColors.primary
//                           : AppColors.textSecondary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 title: Text(currency['name']!, style: AppTextStyles.bodyMedium),
//                 subtitle: Text(
//                   currency['code']!,
//                   style: AppTextStyles.bodySmall,
//                 ),
//                 trailing: isSelected
//                     ? const HeroIcon(HeroIcons.check, color: AppColors.primary)
//                     : null,
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
