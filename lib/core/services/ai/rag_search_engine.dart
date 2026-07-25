import '../../../domain/entities/farmer_profile_entity.dart';
import '../../../domain/entities/government_scheme_entity.dart';
import '../../../domain/repositories/government_scheme_repository.dart';
import '../../logger/app_logger.dart';

class RagSearchResult {
  final List<GovernmentSchemeEntity> relevantSchemes;
  final String formattedContext;

  const RagSearchResult({
    required this.relevantSchemes,
    required this.formattedContext,
  });
}

/// Semantic Vector Retrieval-Augmented Generation (RAG) Search Engine
class RagSearchEngine {
  final GovernmentSchemeRepository schemeRepository;

  RagSearchEngine({required this.schemeRepository});

  Future<RagSearchResult> retrieveContext({
    required String userQuery,
    FarmerProfileEntity? farmerProfile,
  }) async {
    AppLogger.info('RagSearchEngine: Performing RAG vector retrieval for query: "$userQuery"');
    final allSchemes = await schemeRepository.searchSchemes(userQuery);

    // If query is broad, fetch top featured schemes
    List<GovernmentSchemeEntity> matchedSchemes = allSchemes;
    if (matchedSchemes.isEmpty) {
      matchedSchemes = await schemeRepository.getFeaturedSchemes();
    }

    final topSchemes = matchedSchemes.take(3).toList();

    // Format Context for Gemini Prompt
    final StringBuffer contextBuffer = StringBuffer();
    contextBuffer.writeln('--- VERIFIED GOVERNMENT SCHEMES KNOWLEDGE BASE ---');

    for (final scheme in topSchemes) {
      contextBuffer.writeln('SCHEME: ${scheme.name}');
      contextBuffer.writeln('Category: ${scheme.category} | Scope: ${scheme.isCentralScheme ? "Central" : "State"}');
      contextBuffer.writeln('Benefits: ${scheme.benefits}');
      contextBuffer.writeln('Financial Assistance: ${scheme.financialAssistance}');
      contextBuffer.writeln('Eligibility Criteria: ${scheme.eligibilityCriteria.join("; ")}');
      contextBuffer.writeln('Required Documents: ${scheme.requiredDocuments.join("; ")}');
      contextBuffer.writeln('Deadline: ${scheme.deadline}');
      contextBuffer.writeln('Official Website: ${scheme.officialWebsite}');
      contextBuffer.writeln('Application Link: ${scheme.officialApplicationLink}');
      if (scheme.faqs.isNotEmpty) {
        contextBuffer.writeln('FAQs:');
        for (final faq in scheme.faqs) {
          contextBuffer.writeln('  Q: ${faq.question} | A: ${faq.answer}');
        }
      }
      contextBuffer.writeln('---');
    }

    if (farmerProfile != null) {
      contextBuffer.writeln('--- FARMER PROFILE CONTEXT ---');
      contextBuffer.writeln('Name: ${farmerProfile.fullName}');
      contextBuffer.writeln('State: ${farmerProfile.state} | District: ${farmerProfile.district}');
      contextBuffer.writeln('Primary Crop: ${profileCropName(farmerProfile.primaryCrop)}');
      contextBuffer.writeln('Land Size: ${farmerProfile.landSize} | Category: ${farmerProfile.farmerCategory}');
      contextBuffer.writeln('---');
    }

    return RagSearchResult(
      relevantSchemes: topSchemes,
      formattedContext: contextBuffer.toString(),
    );
  }

  String profileCropName(String raw) {
    if (raw.contains('/')) return raw.split('/').first.trim();
    return raw;
  }
}
