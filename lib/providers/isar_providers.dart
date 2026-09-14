import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';

import '../model/categories_model.dart';
import '../model/transaction_model.dart';
import '../services/isar_service.dart';

// Provider لقراءة وتحديث قائمة الفئات (الاستعلام اللحظي Stream)
final categoriesStreamProvider = StreamProvider<List<CategoriesModel>>((ref) {
  return IsarService.db.categoriesModels.where().watch(fireImmediately: true);
});

// Provider لقراءة وتحديث قائمة المعاملات المالية
final transactionsStreamProvider = StreamProvider<List<TransactionModel>>((
  ref,
) {
  return IsarService.db.transactionModels.where().sortByDateDesc().watch(
    fireImmediately: true,
  );
});

//Notifier أو خادم لإضافة المعاملات والتعديل عليها
class TransactionNotifier extends Notifier<void> {
  @override
  void build() {}

  // دالة إضافة معاملة جديدة
  Future<void> addTransaction({
    required double amount,
    required DateTime date,
    required String currencyCode,
    required CategoriesModel category,
    String? note,
  }) async {
    final newTransaction = TransactionModel()
      ..amount = amount
      ..date = date
      ..currencyCode = currencyCode
      ..note = note;

    newTransaction.category.value = category;

    await IsarService.db.writeTxn(() async {
      await IsarService.db.transactionModels.put(newTransaction);
      await newTransaction.category.save(); // حفظ رابط الفئة
    });
  }

  // دالة حذف معاملة
  Future<void> deleteTransaction(Id id) async {
    await IsarService.db.writeTxn(() async {
      await IsarService.db.transactionModels.delete(id);
    });
  }
}

final transactionNotifierProvider = NotifierProvider<TransactionNotifier, void>(
  TransactionNotifier.new,
);
