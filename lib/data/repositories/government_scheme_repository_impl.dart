import '../../core/logger/app_logger.dart';
import '../../core/services/network/connectivity_service.dart';
import '../../domain/entities/government_scheme_entity.dart';
import '../../domain/entities/scheme_filter_params.dart';
import '../../domain/entities/scheme_sort_option.dart';
import '../../domain/repositories/government_scheme_repository.dart';
import '../datasources/scheme_local_datasource.dart';
import '../datasources/scheme_remote_datasource.dart';
import '../models/government_scheme_model.dart';

class GovernmentSchemeRepositoryImpl implements GovernmentSchemeRepository {
  final SchemeRemoteDataSource remoteDataSource;
  final SchemeLocalDataSource localDataSource;
  final ConnectivityNotifier connectivityNotifier;
  GovernmentSchemeRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.connectivityNotifier});

  Future<List<GovernmentSchemeEntity>> _remoteOrCache(Future<List<GovernmentSchemeModel>> request) async {
    if (connectivityNotifier.isOnline) {
      try {
        final schemes = await request;
        await localDataSource.cacheSchemes(schemes);
        return schemes;
      } catch (error, stack) {
        AppLogger.error('Scheme API unavailable; using read-only offline cache', error, stack);
      }
    }
    return localDataSource.getCachedSchemes();
  }

  @override
  Future<List<GovernmentSchemeEntity>> getSchemes({int page = 1, int pageSize = 20, SchemeFilterParams? filter, SchemeSortOption sort = SchemeSortOption.newest}) => _remoteOrCache(remoteDataSource.getSchemes(page: page, pageSize: pageSize, filter: filter, sort: sort));
  @override
  Future<List<GovernmentSchemeEntity>> getFeaturedSchemes() => _remoteOrCache(remoteDataSource.getFeaturedSchemes());
  @override
  Future<List<GovernmentSchemeEntity>> getLatestSchemes() => _remoteOrCache(remoteDataSource.getLatestSchemes());
  @override
  Future<GovernmentSchemeEntity?> getSchemeById(String id) async {
    if (connectivityNotifier.isOnline) return remoteDataSource.getSchemeById(id);
    final cached = await localDataSource.getCachedSchemes();
    for (final scheme in cached) { if (scheme.id == id) return scheme; }
    return null;
  }
  @override
  Future<List<GovernmentSchemeEntity>> searchSchemes(String query, {int page = 1, int pageSize = 20, SchemeFilterParams? filter, SchemeSortOption sort = SchemeSortOption.newest}) => _remoteOrCache(remoteDataSource.searchSchemes(query, page: page, pageSize: pageSize, filter: filter, sort: sort));
}
