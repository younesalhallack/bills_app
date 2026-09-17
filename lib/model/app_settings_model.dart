import 'package:isar_community/isar.dart';

part 'app_settings_model.g.dart';

@collection
class AppSettingsModel {
  Id id = 0;

  //general settings
  String currencyCode;
  String currencySymbol;
  String languageCode;
  bool notificationsEnabled;

  // security
  bool useBiometrics;
  DateTime? lastBackupDate;
  bool autoBackup;

  // 3. budget
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
