// import 'package:bills_app/model/currency_settings_model.dart';
// import 'package:bills_app/providers/isar_providers.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:isar_community/isar.dart';

// /// StreamProvider للاستماع الفوري لأي تغيير في إعدادات العملة
// final currencySettingsStreamProvider = StreamProvider<CurrencySettingsModel>((
//   ref,
// ) async* {
//   final isar = await ref.watch(isarDbProvider.future);

//   yield* isar.currencySettingsModels.where().watch(fireImmediately: true).map((
//     list,
//   ) {
//     if (list.isEmpty) {
//       // إعداد قيم افتراضية في حال كانت هذه المرة الأولى لفتح التطبيق
//       final defaultSettings = CurrencySettingsModel()
//         ..baseCurrencyCode = 'SAR'
//         ..secondaryCurrencyCode = 'USD'
//         ..secondaryExchangeRate = 3.75;

//       isar.writeTxnSync(() {
//         isar.currencySettingsModels.putSync(defaultSettings);
//       });

//       return defaultSettings;
//     }
//     return list.first;
//   });
// });

// final currencyNotifierProvider = NotifierProvider<CurrencyNotifier, void>(
//   CurrencyNotifier.new,
// );

// class CurrencyNotifier extends Notifier<void> {
//   @override
//   void build() {}

//   /// تحديث إعدادات العملات وسعر الصرف
//   Future<void> updateCurrencySettings({
//     required String baseCurrency,
//     required String secondaryCurrency,
//     required double exchangeRate,
//   }) async {
//     final isar = await ref.read(isarDbProvider.future);

//     final currentSettings =
//         await isar.currencySettingsModels.where().findFirst() ??
//         CurrencySettingsModel();

//     currentSettings.baseCurrencyCode = baseCurrency;
//     currentSettings.secondaryCurrencyCode = secondaryCurrency;
//     currentSettings.secondaryExchangeRate = exchangeRate;

//     await isar.writeTxn(() async {
//       await isar.currencySettingsModels.put(currentSettings);
//     });
//   }
// }
