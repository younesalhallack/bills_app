import 'package:bills_app/model/app_settings_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'isar_providers.dart';

// Provider يستمع لملف الإعدادات بشكل حقيقي ومباشر (Stream)
final settingsStreamProvider = StreamProvider<AppSettingsModel>((ref) async* {
  final isar = await ref.watch(isarProvider.future);

  // إنشاء إعدادات افتراضية في حال عدم وجودها سابقاً
  final existingSettings = await isar.appSettingsModels.get(0);
  if (existingSettings == null) {
    await isar.writeTxn(() async {
      await isar.appSettingsModels.put(AppSettingsModel());
    });
  }

  // الاستماع المستمر لتحديثات الإعدادات
  yield* isar.appSettingsModels
      .watchObject(0, fireImmediately: true)
      .map((settings) => settings ?? AppSettingsModel());
});

// متحكم لتحديث قيم الإعدادات
class SettingsController {
  final Isar isar;
  SettingsController(this.isar);

  // 1. تحديث اللغة
  Future<void> updateLanguageCode(String languageCode) async {
    final settings = await isar.appSettingsModels.get(0) ?? AppSettingsModel();
    settings.languageCode = languageCode;
    await isar.writeTxn(() async {
      await isar.appSettingsModels.put(settings);
    });
  }

  // 2. تحديث العملة
  Future<void> updateCurrency(String code, String symbol) async {
    final settings = await isar.appSettingsModels.get(0) ?? AppSettingsModel();
    settings.currencyCode = code;
    settings.currencySymbol = symbol;
    await isar.writeTxn(() async {
      await isar.appSettingsModels.put(settings);
    });
  }

  // 3. تحديث الإشعارات
  Future<void> toggleNotifications(bool enabled) async {
    final settings = await isar.appSettingsModels.get(0) ?? AppSettingsModel();
    settings.notificationsEnabled = enabled;
    await isar.writeTxn(() async {
      await isar.appSettingsModels.put(settings);
    });
  }

  // 4. تحديث تاريخ النسخ الاحتياطي
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
