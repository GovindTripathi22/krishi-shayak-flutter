import '../../domain/entities/government_scheme_entity.dart';
import '../../domain/entities/scheme_filter_params.dart';
import '../../domain/repositories/government_scheme_repository.dart';
import '../../domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final GovernmentSchemeRepository schemeRepository;

  SearchRepositoryImpl({required this.schemeRepository});

  @override
  Future<List<GovernmentSchemeEntity>> smartSearch({
    required String query,
    SchemeFilterParams? filter,
  }) async {
    final schemes = await schemeRepository.getSchemes(
      pageSize: 100,
      filter: filter,
    );

    if (query.trim().isEmpty) return schemes;
    final q = query.toLowerCase();

    return schemes.where((s) {
      final nameMatch = s.name.toLowerCase().contains(q);
      final descMatch = s.shortDescription.toLowerCase().contains(q);
      final benefitMatch = s.benefits.toLowerCase().contains(q);
      final docMatch = s.requiredDocuments.any((doc) => doc.toLowerCase().contains(q));
      final cropMatch = s.applicableCrops.any((c) => c.toLowerCase().contains(q));
      final stateMatch = s.applicableStates.any((st) => st.toLowerCase().contains(q));

      return nameMatch || descMatch || benefitMatch || docMatch || cropMatch || stateMatch;
    }).toList();
  }
}
