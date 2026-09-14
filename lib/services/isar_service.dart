import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../model/categories_model.dart';
import '../model/transaction_model.dart';

class IsarService {
  static late Isar _isarInstance;

  // فتح قاعدة البيانات وتوليد الفئات الافتراضية عند أول تشغيل
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      _isarInstance = await Isar.open(
        [CategoriesModelSchema, TransactionModelSchema],
        directory: dir.path,
        inspector: true, // يتيح لك معاينة البيانات أثتاء التطوير
      );
    } else {
      _isarInstance = Isar.getInstance()!;
    }

    // التحقق هل توجد فئات مخزنة؟ إذا كانت فارغة، نضيف فئات افتراضية
    await _seedDefaultCategories();
  }

  static Isar get db => _isarInstance;

  // إضافة فئات افتراضية أولية للتطبيق
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
}
