import 'package:bills_app/model/app_settings_model.dart';
import 'package:bills_app/model/currency_settings_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'isar_providers.dart';

// settings strem
final settingsStreamProvider = StreamProvider<AppSettingsModel>((ref) async* {
  final isar = await ref.watch(isarProvider.future);

  // create default settings
  final existingSettings = await isar.appSettingsModels.get(0);
  if (existingSettings == null) {
    await isar.writeTxn(() async {
      await isar.appSettingsModels.put(AppSettingsModel());
    });
  }

  yield* isar.appSettingsModels
      .watchObject(0, fireImmediately: true)
      .map((settings) => settings ?? AppSettingsModel());
});

//   setting controller
class SettingsController {
  final Isar isar;
  SettingsController(this.isar);

  //  update language
  Future<void> updateLanguageCode(String languageCode) async {
    final settings = await isar.appSettingsModels.get(0) ?? AppSettingsModel();
    settings.languageCode = languageCode;
    await isar.writeTxn(() async {
      await isar.appSettingsModels.put(settings);
    });
  }

  Future<void> updateCurrency(String code, String symbol) async {
    await isar.writeTxn(() async {
      final settings =
          await isar.appSettingsModels.get(0) ?? AppSettingsModel();
      settings.currencyCode = code;
      settings.currencySymbol = symbol;
      await isar.appSettingsModels.put(settings);

      // update base currency
      final currencySettings =
          await isar.currencySettingsModels.where().findFirst() ??
          CurrencySettingsModel();
      currencySettings.baseCurrencyCode = code;
      await isar.currencySettingsModels.put(currencySettings);
    });
  }

  //  notifications update
  Future<void> toggleNotifications(bool enabled) async {
    final settings = await isar.appSettingsModels.get(0) ?? AppSettingsModel();
    settings.notificationsEnabled = enabled;
    await isar.writeTxn(() async {
      await isar.appSettingsModels.put(settings);
    });
  }

  //  update backup date
  Future<void> updateBackupDate(DateTime date) async {
    final settings = await isar.appSettingsModels.get(0) ?? AppSettingsModel();
    settings.lastBackupDate = date;
    await isar.writeTxn(() async {
      await isar.appSettingsModels.put(settings);
    });
  }
}

final settingsControllerProvider = Provider<SettingsController>((ref) {
  final isar = ref.watch(isarProvider).value;
  if (isar == null) throw UnimplementedError("Isar لم يتم تحميلة بعد");
  return SettingsController(isar);
});
