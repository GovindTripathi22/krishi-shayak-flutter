import '../../domain/entities/government_scheme_entity.dart';
import '../../domain/entities/scheme_faq.dart';

class GovernmentSchemeModel extends GovernmentSchemeEntity {
  const GovernmentSchemeModel({
    required super.id,
    required super.name,
    required super.shortDescription,
    required super.detailedDescription,
    required super.benefits,
    required super.financialAssistance,
    required super.eligibilityCriteria,
    required super.requiredDocuments,
    required super.deadline,
    required super.startDate,
    required super.endDate,
    required super.officialWebsite,
    required super.officialApplicationLink,
    required super.category,
    required super.isCentralScheme,
    required super.applicableStates,
    required super.applicableDistricts,
    required super.applicableCrops,
    required super.landRequirement,
    required super.incomeRequirement,
    required super.farmerCategory,
    required super.genderRestrictions,
    required super.ageRequirement,
    required super.importantNotes,
    required super.faqs,
    required super.lastUpdatedDate,
    required super.createdDate,
    required super.status,
    required super.isFeatured,
    required super.priorityScore,
    required super.languageVersions,
    super.isBookmarked,
  });

  factory GovernmentSchemeModel.fromJson(Map<String, dynamic> json) {
    return GovernmentSchemeModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      detailedDescription: json['detailedDescription'] as String? ?? '',
      benefits: json['benefits'] as String? ?? '',
      financialAssistance: json['financialAssistance'] as String? ?? '',
      eligibilityCriteria: (json['eligibilityCriteria'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      requiredDocuments: (json['requiredDocuments'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      deadline: json['deadline'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      officialWebsite: json['officialWebsite'] as String? ?? '',
      officialApplicationLink: json['officialApplicationLink'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      isCentralScheme: json['isCentralScheme'] as bool? ?? true,
      applicableStates: (json['applicableStates'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      applicableDistricts: (json['applicableDistricts'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      applicableCrops: (json['applicableCrops'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      landRequirement: json['landRequirement'] as String? ?? '',
      incomeRequirement: json['incomeRequirement'] as String? ?? '',
      farmerCategory: json['farmerCategory'] as String? ?? 'All Farmers',
      genderRestrictions: json['genderRestrictions'] as String? ?? 'None',
      ageRequirement: json['ageRequirement'] as String? ?? '18+ Years',
      importantNotes: (json['importantNotes'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      faqs: (json['faqs'] as List<dynamic>?)
              ?.map((f) => SchemeFaq.fromJson(f as Map<String, dynamic>))
              .toList() ??
          [],
      lastUpdatedDate: json['lastUpdatedDate'] != null
          ? DateTime.parse(json['lastUpdatedDate'] as String)
          : DateTime.now(),
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'] as String)
          : DateTime.now(),
      status: json['status'] as String? ?? 'Active',
      isFeatured: json['isFeatured'] as bool? ?? false,
      priorityScore: json['priorityScore'] as int? ?? 0,
      languageVersions: (json['languageVersions'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, v.toString())) ??
          {},
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'shortDescription': shortDescription,
      'detailedDescription': detailedDescription,
      'benefits': benefits,
      'financialAssistance': financialAssistance,
      'eligibilityCriteria': eligibilityCriteria,
      'requiredDocuments': requiredDocuments,
      'deadline': deadline,
      'startDate': startDate,
      'endDate': endDate,
      'officialWebsite': officialWebsite,
      'officialApplicationLink': officialApplicationLink,
      'category': category,
      'isCentralScheme': isCentralScheme,
      'applicableStates': applicableStates,
      'applicableDistricts': applicableDistricts,
      'applicableCrops': applicableCrops,
      'landRequirement': landRequirement,
      'incomeRequirement': incomeRequirement,
      'farmerCategory': farmerCategory,
      'genderRestrictions': genderRestrictions,
      'ageRequirement': ageRequirement,
      'importantNotes': importantNotes,
      'faqs': faqs.map((f) => f.toJson()).toList(),
      'lastUpdatedDate': lastUpdatedDate.toIso8601String(),
      'createdDate': createdDate.toIso8601String(),
      'status': status,
      'isFeatured': isFeatured,
      'priorityScore': priorityScore,
      'languageVersions': languageVersions,
      'isBookmarked': isBookmarked,
    };
  }

  factory GovernmentSchemeModel.fromEntity(GovernmentSchemeEntity entity) {
    return GovernmentSchemeModel(
      id: entity.id,
      name: entity.name,
      shortDescription: entity.shortDescription,
      detailedDescription: entity.detailedDescription,
      benefits: entity.benefits,
      financialAssistance: entity.financialAssistance,
      eligibilityCriteria: entity.eligibilityCriteria,
      requiredDocuments: entity.requiredDocuments,
      deadline: entity.deadline,
      startDate: entity.startDate,
      endDate: entity.endDate,
      officialWebsite: entity.officialWebsite,
      officialApplicationLink: entity.officialApplicationLink,
      category: entity.category,
      isCentralScheme: entity.isCentralScheme,
      applicableStates: entity.applicableStates,
      applicableDistricts: entity.applicableDistricts,
      applicableCrops: entity.applicableCrops,
      landRequirement: entity.landRequirement,
      incomeRequirement: entity.incomeRequirement,
      farmerCategory: entity.farmerCategory,
      genderRestrictions: entity.genderRestrictions,
      ageRequirement: entity.ageRequirement,
      importantNotes: entity.importantNotes,
      faqs: entity.faqs,
      lastUpdatedDate: entity.lastUpdatedDate,
      createdDate: entity.createdDate,
      status: entity.status,
      isFeatured: entity.isFeatured,
      priorityScore: entity.priorityScore,
      languageVersions: entity.languageVersions,
      isBookmarked: entity.isBookmarked,
    );
  }
}
