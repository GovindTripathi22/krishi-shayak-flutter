import '../../core/services/backend/api_client.dart';
import '../../domain/entities/scheme_filter_params.dart';
import '../../domain/entities/scheme_sort_option.dart';
import '../models/government_scheme_model.dart';

abstract class SchemeRemoteDataSource {
  Future<List<GovernmentSchemeModel>> getSchemes({int page, int pageSize, SchemeFilterParams? filter, SchemeSortOption sort});
  Future<List<GovernmentSchemeModel>> searchSchemes(String query, {int page, int pageSize, SchemeFilterParams? filter, SchemeSortOption sort});
  Future<GovernmentSchemeModel?> getSchemeById(String id);
  Future<List<GovernmentSchemeModel>> getFeaturedSchemes();
  Future<List<GovernmentSchemeModel>> getLatestSchemes();
}

class SchemeRemoteDataSourceImpl implements SchemeRemoteDataSource {
  final ApiClient _apiClient;
  SchemeRemoteDataSourceImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Map<String, String> _parameters({int page = 1, int pageSize = 20, SchemeFilterParams? filter, SchemeSortOption sort = SchemeSortOption.newest}) {
    final values = <String, String>{'page': '$page', 'limit': '$pageSize', 'sort': _sortValue(sort)};
    if (filter?.state?.isNotEmpty == true) values['state'] = filter!.state!;
    if (filter?.district?.isNotEmpty == true) values['district'] = filter!.district!;
    if (filter?.crop?.isNotEmpty == true) values['crop'] = filter!.crop!;
    if (filter?.category?.isNotEmpty == true && filter!.category != 'All') values['category'] = filter.category!;
    if (filter?.isCentralScheme != null) values['isCentralScheme'] = '${filter!.isCentralScheme}';
    return values;
  }

  String _sortValue(SchemeSortOption sort) => switch (sort) {
        SchemeSortOption.newest => 'newest',
        SchemeSortOption.popular => 'popular',
        SchemeSortOption.recentlyUpdated => 'updated',
        SchemeSortOption.highestBenefits => 'benefits',
        SchemeSortOption.deadlineSoon => 'deadline',
        SchemeSortOption.alphabetical => 'alphabetical',
      };

  String _path(String path, Map<String, String> parameters) => Uri(path: path, queryParameters: parameters).toString();
  List<GovernmentSchemeModel> _list(dynamic response) {
    final body = response as Map<String, dynamic>;
    return (body['data'] as List<dynamic>? ?? []).map((item) => GovernmentSchemeModel.fromJson(Map<String, dynamic>.from(item as Map))).toList();
  }

  @override
  Future<List<GovernmentSchemeModel>> getSchemes({int page = 1, int pageSize = 20, SchemeFilterParams? filter, SchemeSortOption sort = SchemeSortOption.newest}) async => _list(await _apiClient.get(_path('/schemes', _parameters(page: page, pageSize: pageSize, filter: filter, sort: sort)), requireAuth: false));

  @override
  Future<List<GovernmentSchemeModel>> searchSchemes(String query, {int page = 1, int pageSize = 20, SchemeFilterParams? filter, SchemeSortOption sort = SchemeSortOption.newest}) async {
    final parameters = _parameters(page: page, pageSize: pageSize, filter: filter, sort: sort)..['q'] = query.trim();
    return _list(await _apiClient.get(_path('/schemes/search', parameters), requireAuth: false));
  }

  @override
  Future<GovernmentSchemeModel?> getSchemeById(String id) async {
    final response = await _apiClient.get('/schemes/$id', requireAuth: false) as Map<String, dynamic>;
    final data = response['data'];
    return data == null ? null : GovernmentSchemeModel.fromJson(Map<String, dynamic>.from(data as Map));
  }

  @override
  Future<List<GovernmentSchemeModel>> getFeaturedSchemes() async => _list(await _apiClient.get('/schemes/featured?limit=20', requireAuth: false));
  @override
  Future<List<GovernmentSchemeModel>> getLatestSchemes() async => _list(await _apiClient.get('/schemes/latest?limit=10', requireAuth: false));
}
