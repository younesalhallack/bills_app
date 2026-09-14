import 'package:isar_community/isar.dart';

part 'categories_model.g.dart';

@collection
class CategoriesModel {
  Id id = Isar.autoIncrement;

  late String name; // اسم الفئة (مثل: طعام، راتب، سكن)
  late String type; // نوع الفئة: 'expense' أو 'income'
  String? iconName; // اسم الأيقونة (اختياري)
  bool isSystem = false; // هل هي فئة افتراضية نظامية؟
}
