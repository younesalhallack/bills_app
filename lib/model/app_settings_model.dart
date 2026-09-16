import 'package:isar_community/isar.dart';

part 'app_settings_model.g.dart';

@collection
class AppSettingsModel {
  Id id = 0; // معرف ثابت (0) لضمان وجود كائن إعدادات واحد فقط في التطبيق

  // 1. التفضيلات العامة
  String currencyCode;
  String currencySymbol;
  String languageCode;
  bool notificationsEnabled;

  // 2. الأمان والبيانات
  bool useBiometrics;
  DateTime? lastBackupDate;
  bool autoBackup;

  // 3. الميزانية
  double? monthlyBudgetLimit;

  AppSettingsModel({
    this.id = 0,
    this.currencyCode = 'SAR',
    this.currencySymbol = 'ر.س',
    this.languageCode = 'ar',
    this.notificationsEnabled = true,
    this.useBiometrics = false,
    this.lastBackupDate,
    this.autoBackup = true,
    this.monthlyBudgetLimit,
  });
}
