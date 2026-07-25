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

  GovernmentSchemeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityNotifier,
  });

  @override
  Future<List<GovernmentSchemeEntity>> getSchemes({
    int page = 1,
    int pageSize = 20,
    SchemeFilterParams? filter,
    SchemeSortOption sort = SchemeSortOption.newest,
  }) async {
    List<GovernmentSchemeModel> allSchemes = [];

    // Offline-first Caching Strategy
    if (connectivityNotifier.isOnline) {
      try {
        allSchemes = await remoteDataSource.getSchemes();
        await localDataSource.cacheSchemes(allSchemes);
      } catch (e, stack) {
        AppLogger.error('GovernmentSchemeRepositoryImpl: Remote fetch error, reading local cache', e, stack);
        allSchemes = await localDataSource.getCachedSchemes();
      }
    } else {
      AppLogger.info('GovernmentSchemeRepositoryImpl: OFFLINE mode -> Loading cached schemes');
      allSchemes = await localDataSource.getCachedSchemes();
    }

    // Attach bookmark state from local storage
    final bookmarkedIds = await localDataSource.getBookmarkedSchemeIds();
    final schemesWithBookmarks = allSchemes.map((s) {
      final isBkm = bookmarkedIds.contains(s.id);
      return s.copyWith(isBookmarked: isBkm);
    }).toList();

    // Apply Filter Pipeline
    var filtered = schemesWithBookmarks;
    if (filter != null && filter.hasActiveFilters) {
      filtered = filtered.where((s) {
        if (filter.category != null && filter.category!.isNotEmpty && filter.category != 'All') {
          if (s.category.toLowerCase() != filter.category!.toLowerCase()) return false;
        }
        if (filter.isCentralScheme != null) {
          if (s.isCentralScheme != filter.isCentralScheme) return false;
        }
        if (filter.state != null && filter.state!.isNotEmpty && filter.state != 'All India') {
          final matchState = s.applicableStates.any(
            (st) => st.toLowerCase() == 'all india' || st.toLowerCase() == filter.state!.toLowerCase(),
          );
          if (!matchState) return false;
        }
        if (filter.crop != null && filter.crop!.isNotEmpty) {
          final matchCrop = s.applicableCrops.any(
            (c) => c.toLowerCase() == 'all crops' || c.toLowerCase().contains(filter.crop!.toLowerCase()),
          );
          if (!matchCrop) return false;
        }
        return true;
      }).toList();
    }

    // Apply Sort Pipeline
    filtered.sort((a, b) {
      switch (sort) {
        case SchemeSortOption.popular:
          return b.priorityScore.compareTo(a.priorityScore);
        case SchemeSortOption.recentlyUpdated:
          return b.lastUpdatedDate.compareTo(a.lastUpdatedDate);
        case SchemeSortOption.highestBenefits:
          return b.priorityScore.compareTo(a.priorityScore);
        case SchemeSortOption.deadlineSoon:
          return a.deadline.compareTo(b.deadline);
        case SchemeSortOption.alphabetical:
          return a.name.compareTo(b.name);
        case SchemeSortOption.newest:
        default:
          return b.createdDate.compareTo(a.createdDate);
      }
    });

    // Apply Pagination
    final startIndex = (page - 1) * pageSize;
    if (startIndex >= filtered.length) return [];
    final endIndex = (startIndex + pageSize) > filtered.length ? filtered.length : (startIndex + pageSize);

    return filtered.sublist(startIndex, endIndex);
  }

  @override
  Future<List<GovernmentSchemeEntity>> getFeaturedSchemes() async {
    final schemes = await getSchemes(pageSize: 50);
    return schemes.where((s) => s.isFeatured).toList();
  }

  @override
  Future<List<GovernmentSchemeEntity>> getLatestSchemes() async {
    return await getSchemes(sort: SchemeSortOption.newest, pageSize: 10);
  }

  @override
  Future<GovernmentSchemeEntity?> getSchemeById(String id) async {
    final schemes = await getSchemes(pageSize: 100);
    try {
      return schemes.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<GovernmentSchemeEntity>> searchSchemes(String query) async {
    if (query.trim().isEmpty) return await getSchemes();
    final schemes = await getSchemes(pageSize: 100);
    final q = query.toLowerCase();

    return schemes.where((s) {
      final nameMatch = s.name.toLowerCase().contains(q);
      final descMatch = s.shortDescription.toLowerCase().contains(q);
      final benefitMatch = s.benefits.toLowerCase().contains(q);
      final catMatch = s.category.toLowerCase().contains(q);
      final cropMatch = s.applicableCrops.any((c) => c.toLowerCase().contains(q));
      final stateMatch = s.applicableStates.any((st) => st.toLowerCase().contains(q));

      return nameMatch || descMatch || benefitMatch || catMatch || cropMatch || stateMatch;
    }).toList();
  }
}
