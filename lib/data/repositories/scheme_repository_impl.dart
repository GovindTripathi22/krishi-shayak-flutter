import '../../domain/entities/scheme_entity.dart';
import '../../domain/repositories/scheme_repository.dart';
import '../datasources/scheme_remote_datasource.dart';

class SchemeRepositoryImpl implements SchemeRepository {
  final SchemeRemoteDataSource remoteDataSource;

  SchemeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SchemeEntity>> getSchemes() async {
    return await remoteDataSource.getSchemes();
  }

  @override
  Future<List<SchemeEntity>> getBookmarkedSchemes() async {
    final schemes = await getSchemes();
    return schemes.where((s) => s.isBookmarked).toList();
  }

  @override
  Future<void> toggleBookmark(String schemeId) async {}
}
