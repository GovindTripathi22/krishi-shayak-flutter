import '../entities/scheme_category_entity.dart';

abstract class CategoryRepository {
  Future<List<SchemeCategoryEntity>> getCategories();
}
