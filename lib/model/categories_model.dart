import 'package:isar_community/isar.dart';

part 'categories_model.g.dart';

@collection
class CategoriesModel {
  Id id = Isar.autoIncrement;

  late String name;
  late String type;
  String? colorHex;
  String? iconName;
  bool isSystem = false;
}
