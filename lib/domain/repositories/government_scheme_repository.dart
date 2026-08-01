import '../entities/government_scheme_entity.dart';
import '../entities/scheme_filter_params.dart';
import '../entities/scheme_sort_option.dart';

abstract class GovernmentSchemeRepository {
  Future<List<GovernmentSchemeEntity>> getSchemes({
    int page = 1,
    int pageSize = 20,
    SchemeFilterParams? filter,
    SchemeSortOption sort = SchemeSortOption.newest,
  });

  Future<List<GovernmentSchemeEntity>> getFeaturedSchemes();
  Future<List<GovernmentSchemeEntity>> getLatestSchemes();
  Future<GovernmentSchemeEntity?> getSchemeById(String id);
  Future<List<GovernmentSchemeEntity>> searchSchemes(String query, {int page = 1, int pageSize = 20, SchemeFilterParams? filter, SchemeSortOption sort = SchemeSortOption.newest});
}
