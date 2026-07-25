import 'package:agrisathi_ai/core/services/ai/rag_search_engine.dart';
import 'package:agrisathi_ai/domain/entities/farmer_profile_entity.dart';
import 'package:agrisathi_ai/domain/entities/government_scheme_entity.dart';
import 'package:agrisathi_ai/domain/entities/scheme_filter_params.dart';
import 'package:agrisathi_ai/domain/entities/scheme_sort_option.dart';
import 'package:agrisathi_ai/domain/repositories/government_scheme_repository.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeSchemeRepository implements GovernmentSchemeRepository {
  @override
  Future<List<GovernmentSchemeEntity>> getSchemes({
    int page = 1,
    int pageSize = 20,
    SchemeFilterParams? filter,
    SchemeSortOption sort = SchemeSortOption.newest,
  }) async => [];

  @override
  Future<List<GovernmentSchemeEntity>> getFeaturedSchemes() async => [];

  @override
  Future<List<GovernmentSchemeEntity>> getLatestSchemes() async => [];

  @override
  Future<GovernmentSchemeEntity?> getSchemeById(String id) async => null;

  @override
  Future<List<GovernmentSchemeEntity>> searchSchemes(String query) async => [];
}

void main() {
  test('retrieveContext returns RAG formatted context string', () async {
    final fakeRepo = FakeSchemeRepository();
    final ragEngine = RagSearchEngine(schemeRepository: fakeRepo);

    const profile = FarmerProfileEntity(
      uid: 'u1',
      fullName: 'Ramesh Patil',
      phoneNumber: '9876543210',
      state: 'Maharashtra',
      district: 'Nashik',
      village: 'Pimplegaon',
      primaryCrop: 'Wheat / Wheat',
      landSize: '3 Acres',
      landOwnership: 'Owned',
      annualIncome: '₹2,000,000',
      farmerCategory: 'Small Farmer',
      gender: 'Male',
      age: 40,
      preferredLanguage: 'en',
    );

    final result = await ragEngine.retrieveContext(
      userQuery: 'Cotton subsidy',
      farmerProfile: profile,
    );

    expect(result.formattedContext, contains('Ramesh Patil'));
    expect(result.formattedContext, contains('Maharashtra'));
  });
}
