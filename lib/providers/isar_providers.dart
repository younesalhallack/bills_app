import 'package:bills_app/model/app_settings_model.dart';
import 'package:bills_app/model/currency_settings_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../model/categories_model.dart';
import '../model/transaction_model.dart';
import '../services/isar_service.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();

  if (Isar.instanceNames.isEmpty) {
    return await Isar.open([
      AppSettingsModelSchema,
      TransactionModelSchema,
      CategoriesModelSchema,
      CurrencySettingsModelSchema,
    ], directory: dir.path);
  }

  return Isar.getInstance()!;
});

// Provider لقراءة وتحديث قائمة الفئات
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

// Provider لقراءة وتحديث إعدادات العملة وسعر الصرف
final currencySettingsStreamProvider = StreamProvider<CurrencySettingsModel>((
  ref,
) async* {
  yield* IsarService.db.currencySettingsModels
      .where()
      .watch(fireImmediately: true)
      .map((list) {
        if (list.isEmpty) {
          final defaultSettings = CurrencySettingsModel()
            ..baseCurrencyCode = 'SAR'
            ..secondaryCurrencyCode = 'USD'
            ..secondaryExchangeRate = 3.75;

          IsarService.db.writeTxnSync(() {
            IsarService.db.currencySettingsModels.putSync(defaultSettings);
          });

          return defaultSettings;
        }
        return list.first;
      });
});

// ----------------------- [ مزوّدات الحسابات الماليّة الموحدة ] -----------------------

/// حساب إجمالي الرصيد المتاح دائماً بالعملة الأساسية (Base Amount)
final totalBalanceProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsStreamProvider).value ?? [];
  return transactions.fold(0.0, (sum, tx) => sum + tx.baseAmount);
});

/// حساب إجمالي الإيرادات بالعملة الأساسية
final totalIncomeProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsStreamProvider).value ?? [];
  return transactions
      .where((tx) => tx.baseAmount > 0)
      .fold(0.0, (sum, tx) => sum + tx.baseAmount);
});

/// حساب إجمالي المصروفات بالعملة الأساسية (قيم موجبة للعرض)
final totalExpensesProvider = Provider<double>((ref) {
  final transactions = ref.watch(transactionsStreamProvider).value ?? [];
  return transactions
      .where((tx) => tx.baseAmount < 0)
      .fold(0.0, (sum, tx) => sum + tx.baseAmount.abs());
});

// ----------------------------------------------------------------------------------

// Notifier لإدارة وتحديث إعدادات العملات
class CurrencyNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> updateCurrencySettings({
    required String baseCurrency,
    required String secondaryCurrency,
    required double exchangeRate,
  }) async {
    final currentSettings =
        await IsarService.db.currencySettingsModels.where().findFirst() ??
        CurrencySettingsModel();

    currentSettings.baseCurrencyCode = baseCurrency;
    currentSettings.secondaryCurrencyCode = secondaryCurrency;
    currentSettings.secondaryExchangeRate = exchangeRate;

    await IsarService.db.writeTxn(() async {
      await IsarService.db.currencySettingsModels.put(currentSettings);
    });
  }
}

final currencyNotifierProvider = NotifierProvider<CurrencyNotifier, void>(
  CurrencyNotifier.new,
);

// Notifier لإضافة المعاملات والتعديل عليها
class TransactionNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> addTransaction({
    required double amount,
    required DateTime date,
    required String currencyCode,
    required double exchangeRate,
    required double baseAmount,
    required CategoriesModel category,
    String? note,
  }) async {
    final newTransaction = TransactionModel()
      ..amount = amount
      ..date = date
      ..currencyCode = currencyCode
      ..exchangeRate = exchangeRate
      ..baseAmount = baseAmount
      ..note = note;

    newTransaction.category.value = category;

    await IsarService.db.writeTxn(() async {
      await IsarService.db.transactionModels.put(newTransaction);
      newTransaction.category.value = category;
      await newTransaction.category.save();
    });
  }

  Future<void> deleteTransaction(Id id) async {
    await IsarService.db.writeTxn(() async {
      await IsarService.db.transactionModels.delete(id);
    });
  }
}

final transactionNotifierProvider = NotifierProvider<TransactionNotifier, void>(
  TransactionNotifier.new,
);

class CategoryNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> addCategory({
    required String name,
    required String iconName,
    required String type,
  }) async {
    final newCategory = CategoriesModel()
      ..name = name
      ..iconName = iconName
      ..type = type;

    await IsarService.db.writeTxn(() async {
      await IsarService.db.categoriesModels.put(newCategory);
    });
  }
}

final categoryNotifierProvider = NotifierProvider<CategoryNotifier, void>(
  CategoryNotifier.new,
);
// import 'package:bills_app/model/app_settings_model.dart';
// import 'package:bills_app/model/currency_settings_model.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:isar_community/isar.dart';
// import 'package:path_provider/path_provider.dart';

// import '../model/categories_model.dart';
// import '../model/transaction_model.dart';
// import '../services/isar_service.dart';

// final isarProvider = FutureProvider<Isar>((ref) async {
//   final dir = await getApplicationDocumentsDirectory();

//   if (Isar.instanceNames.isEmpty) {
//     return await Isar.open([
//       AppSettingsModelSchema,
//       TransactionModelSchema,
//       CategoriesModelSchema,
//       CurrencySettingsModelSchema,
//     ], directory: dir.path);
//   }

//   return Isar.getInstance()!;
// });

// // Provider لقراءة وتحديث قائمة الفئات (الاستعلام اللحظي Stream)
// final categoriesStreamProvider = StreamProvider<List<CategoriesModel>>((ref) {
//   return IsarService.db.categoriesModels.where().watch(fireImmediately: true);
// });

// // Provider لقراءة وتحديث قائمة المعاملات المالية
// final transactionsStreamProvider = StreamProvider<List<TransactionModel>>((
//   ref,
// ) {
//   return IsarService.db.transactionModels.where().sortByDateDesc().watch(
//     fireImmediately: true,
//   );
// });

// // Provider لقراءة وتحديث إعدادات العملة وسعر الصرف
// final currencySettingsStreamProvider = StreamProvider<CurrencySettingsModel>((
//   ref,
// ) async* {
//   yield* IsarService.db.currencySettingsModels
//       .where()
//       .watch(fireImmediately: true)
//       .map((list) {
//         if (list.isEmpty) {
//           final defaultSettings = CurrencySettingsModel()
//             ..baseCurrencyCode = 'SAR'
//             ..secondaryCurrencyCode = 'USD'
//             ..secondaryExchangeRate = 3.75;

//           IsarService.db.writeTxnSync(() {
//             IsarService.db.currencySettingsModels.putSync(defaultSettings);
//           });

//           return defaultSettings;
//         }
//         return list.first;
//       });
// });

// // Notifier لإدارة وتحديث إعدادات العملات
// class CurrencyNotifier extends Notifier<void> {
//   @override
//   void build() {}

//   Future<void> updateCurrencySettings({
//     required String baseCurrency,
//     required String secondaryCurrency,
//     required double exchangeRate,
//   }) async {
//     final currentSettings =
//         await IsarService.db.currencySettingsModels.where().findFirst() ??
//         CurrencySettingsModel();

//     currentSettings.baseCurrencyCode = baseCurrency;
//     currentSettings.secondaryCurrencyCode = secondaryCurrency;
//     currentSettings.secondaryExchangeRate = exchangeRate;

//     await IsarService.db.writeTxn(() async {
//       await IsarService.db.currencySettingsModels.put(currentSettings);
//     });
//   }
// }

// final currencyNotifierProvider = NotifierProvider<CurrencyNotifier, void>(
//   CurrencyNotifier.new,
// );

// // Notifier أو خادم لإضافة المعاملات والتعديل عليها
// class TransactionNotifier extends Notifier<void> {
//   @override
//   void build() {}

//   // دالة إضافة معاملة جديدة (مع دعم سعر الصرف والقيمة الأساسية)
//   Future<void> addTransaction({
//     required double amount,
//     required DateTime date,
//     required String currencyCode,
//     required double exchangeRate,
//     required double baseAmount,
//     required CategoriesModel category,
//     String? note,
//   }) async {
//     final newTransaction = TransactionModel()
//       ..amount = amount
//       ..date = date
//       ..currencyCode = currencyCode
//       ..exchangeRate = exchangeRate
//       ..baseAmount = baseAmount
//       ..note = note;

//     newTransaction.category.value = category;

//     await IsarService.db.writeTxn(() async {
//       await IsarService.db.transactionModels.put(newTransaction);
//       newTransaction.category.value = category;
//       await newTransaction.category.save(); // حفظ رابط الفئة
//     });
//   }

//   // دالة حذف معاملة
//   Future<void> deleteTransaction(Id id) async {
//     await IsarService.db.writeTxn(() async {
//       await IsarService.db.transactionModels.delete(id);
//     });
//   }
// }

// final transactionNotifierProvider = NotifierProvider<TransactionNotifier, void>(
//   TransactionNotifier.new,
// );

// class CategoryNotifier extends Notifier<void> {
//   @override
//   void build() {}

//   Future<void> addCategory({
//     required String name,
//     required String iconName,
//     required String type, // 'expense' أو 'income'
//   }) async {
//     final newCategory = CategoriesModel()
//       ..name = name
//       ..iconName = iconName
//       ..type = type;

//     await IsarService.db.writeTxn(() async {
//       await IsarService.db.categoriesModels.put(newCategory);
//     });
//   }
// }

// final categoryNotifierProvider = NotifierProvider<CategoryNotifier, void>(
//   CategoryNotifier.new,
// );
