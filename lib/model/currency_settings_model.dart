import 'package:isar_community/isar.dart';

part 'currency_settings_model.g.dart';

@collection
class CurrencySettingsModel {
  Id id = Isar.autoIncrement;

  String baseCurrencyCode = 'SAR'; // defult
  String secondaryCurrencyCode = 'USD';
  double secondaryExchangeRate = 3.75; // exchange rate
}
