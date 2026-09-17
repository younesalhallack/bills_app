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
    'SYP',
    'USD',
    'EUR',

    // 'EGP',
    // 'AED',
    // 'IQD',
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
