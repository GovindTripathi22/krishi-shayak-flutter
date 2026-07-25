import '../../domain/entities/scheme_category_entity.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  @override
  Future<List<SchemeCategoryEntity>> getCategories() async {
    return const [
      SchemeCategoryEntity(id: 'cat_all', title: 'All', iconName: 'apps', count: 150),
      SchemeCategoryEntity(id: 'cat_fin', title: 'Financial Support', iconName: 'payments', count: 42),
      SchemeCategoryEntity(id: 'cat_ins', title: 'Crop Insurance', iconName: 'security', count: 18),
      SchemeCategoryEntity(id: 'cat_crd', title: 'Agri Credit', iconName: 'credit_card', count: 25),
      SchemeCategoryEntity(id: 'cat_irr', title: 'Irrigation & Water', iconName: 'water_drop', count: 30),
      SchemeCategoryEntity(id: 'cat_org', title: 'Organic Farming', iconName: 'eco', count: 15),
      SchemeCategoryEntity(id: 'cat_eqp', title: 'Machinery Subsidy', iconName: 'precision_manufacturing', count: 20),
    ];
  }
}
