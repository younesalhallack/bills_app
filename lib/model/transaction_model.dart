import 'package:isar_community/isar.dart';

import 'categories_model.dart';

part 'transaction_model.g.dart';

@collection
class TransactionModel {
  Id id = Isar.autoIncrement;

  late double amount; // قيمة المبلغ
  late DateTime date; // تاريخ المعاملة
  late String currencyCode;
  double exchangeRate = 1.0;
  double baseAmount = 0.0;
  String? note; // ملاحظات أو وصف اختياري

  // علاقة ربط المعاملة بالفئة الخاصة بها
  final category = IsarLink<CategoriesModel>();
}
