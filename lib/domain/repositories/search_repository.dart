import '../entities/government_scheme_entity.dart';
import '../entities/scheme_filter_params.dart';

abstract class SearchRepository {
  Future<List<GovernmentSchemeEntity>> smartSearch({
    required String query,
    SchemeFilterParams? filter,
  });
}
