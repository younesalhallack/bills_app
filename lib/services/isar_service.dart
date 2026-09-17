import 'package:bills_app/model/app_settings_model.dart';
import 'package:bills_app/model/currency_settings_model.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../model/categories_model.dart';
import '../model/transaction_model.dart';

class IsarService {
  static late Isar _isarInstance;

  // open db
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      _isarInstance = await Isar.open(
        [
          CategoriesModelSchema,
          TransactionModelSchema,
          AppSettingsModelSchema,
          CurrencySettingsModelSchema,
        ],
        directory: dir.path,
        inspector: true, // remove it in release
      );
    } else {
      _isarInstance = Isar.getInstance()!;
    }

    // check catigories
    await _seedDefaultCategories();
  }

  static Isar get db => _isarInstance;

  //  add default categories => i need to move it to localizations
  static Future<void> _seedDefaultCategories() async {
    final count = await _isarInstance.categoriesModels.count();
    if (count == 0) {
      final defaultCategories = [
        CategoriesModel()
          ..name = 'طعام ومشروبات'
          ..type = 'expense'
          ..isSystem = true,
        CategoriesModel()
          ..name = 'سكن وفواتير'
          ..type = 'expense'
          ..isSystem = true,
        CategoriesModel()
          ..name = 'طبابة وصحة'
          ..type = 'expense'
          ..isSystem = true,
        CategoriesModel()
          ..name = 'راتب أساسي'
          ..type = 'income'
          ..isSystem = true,
        CategoriesModel()
          ..name = 'عمل حر'
          ..type = 'income'
          ..isSystem = true,
      ];

      await _isarInstance.writeTxn(() async {
        await _isarInstance.categoriesModels.putAll(defaultCategories);
      });
    }
  }

  //calculate Total balance
  double calculateTotalBalance(List<TransactionModel> transactions) {
    return transactions.fold(0.0, (sum, item) => sum + item.baseAmount);
  }

  // calculate Total outcome
  double calculateTotalExpenses(List<TransactionModel> transactions) {
    return transactions
        .where((item) => item.baseAmount < 0)
        .fold(0.0, (sum, item) => sum + item.baseAmount.abs());
  }
}
