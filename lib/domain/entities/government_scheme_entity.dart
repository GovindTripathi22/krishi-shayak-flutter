import 'package:equatable/equatable.dart';

import 'scheme_faq.dart';

class GovernmentSchemeEntity extends Equatable {
  final String id;
  final String name;
  final String shortDescription;
  final String detailedDescription;
  final String benefits;
  final String financialAssistance;
  final List<String> eligibilityCriteria;
  final List<String> requiredDocuments;
  final String deadline;
  final String startDate;
  final String endDate;
  final String officialWebsite;
  final String officialApplicationLink;
  final String category;
  final bool isCentralScheme;
  final List<String> applicableStates;
  final List<String> applicableDistricts;
  final List<String> applicableCrops;
  final String landRequirement;
  final String incomeRequirement;
  final String farmerCategory;
  final String genderRestrictions;
  final String ageRequirement;
  final List<String> importantNotes;
  final List<SchemeFaq> faqs;
  final DateTime lastUpdatedDate;
  final DateTime createdDate;
  final String status;
  final bool isFeatured;
  final int priorityScore;
  final Map<String, String> languageVersions;
  final bool isBookmarked;

  const GovernmentSchemeEntity({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.detailedDescription,
    required this.benefits,
    required this.financialAssistance,
    required this.eligibilityCriteria,
    required this.requiredDocuments,
    required this.deadline,
    required this.startDate,
    required this.endDate,
    required this.officialWebsite,
    required this.officialApplicationLink,
    required this.category,
    required this.isCentralScheme,
    required this.applicableStates,
    required this.applicableDistricts,
    required this.applicableCrops,
    required this.landRequirement,
    required this.incomeRequirement,
    required this.farmerCategory,
    required this.genderRestrictions,
    required this.ageRequirement,
    required this.importantNotes,
    required this.faqs,
    required this.lastUpdatedDate,
    required this.createdDate,
    required this.status,
    required this.isFeatured,
    required this.priorityScore,
    required this.languageVersions,
    this.isBookmarked = false,
  });

  GovernmentSchemeEntity copyWith({
    String? id,
    String? name,
    String? shortDescription,
    String? detailedDescription,
    String? benefits,
    String? financialAssistance,
    List<String>? eligibilityCriteria,
    List<String>? requiredDocuments,
    String? deadline,
    String? startDate,
    String? endDate,
    String? officialWebsite,
    String? officialApplicationLink,
    String? category,
    bool? isCentralScheme,
    List<String>? applicableStates,
    List<String>? applicableDistricts,
    List<String>? applicableCrops,
    String? landRequirement,
    String? incomeRequirement,
    String? farmerCategory,
    String? genderRestrictions,
    String? ageRequirement,
    List<String>? importantNotes,
    List<SchemeFaq>? faqs,
    DateTime? lastUpdatedDate,
    DateTime? createdDate,
    String? status,
    bool? isFeatured,
    int? priorityScore,
    Map<String, String>? languageVersions,
    bool? isBookmarked,
  }) {
    return GovernmentSchemeEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      shortDescription: shortDescription ?? this.shortDescription,
      detailedDescription: detailedDescription ?? this.detailedDescription,
      benefits: benefits ?? this.benefits,
      financialAssistance: financialAssistance ?? this.financialAssistance,
      eligibilityCriteria: eligibilityCriteria ?? this.eligibilityCriteria,
      requiredDocuments: requiredDocuments ?? this.requiredDocuments,
      deadline: deadline ?? this.deadline,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      officialWebsite: officialWebsite ?? this.officialWebsite,
      officialApplicationLink: officialApplicationLink ?? this.officialApplicationLink,
      category: category ?? this.category,
      isCentralScheme: isCentralScheme ?? this.isCentralScheme,
      applicableStates: applicableStates ?? this.applicableStates,
      applicableDistricts: applicableDistricts ?? this.applicableDistricts,
      applicableCrops: applicableCrops ?? this.applicableCrops,
      landRequirement: landRequirement ?? this.landRequirement,
      incomeRequirement: incomeRequirement ?? this.incomeRequirement,
      farmerCategory: farmerCategory ?? this.farmerCategory,
      genderRestrictions: genderRestrictions ?? this.genderRestrictions,
      ageRequirement: ageRequirement ?? this.ageRequirement,
      importantNotes: importantNotes ?? this.importantNotes,
      faqs: faqs ?? this.faqs,
      lastUpdatedDate: lastUpdatedDate ?? this.lastUpdatedDate,
      createdDate: createdDate ?? this.createdDate,
      status: status ?? this.status,
      isFeatured: isFeatured ?? this.isFeatured,
      priorityScore: priorityScore ?? this.priorityScore,
      languageVersions: languageVersions ?? this.languageVersions,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        shortDescription,
        detailedDescription,
        benefits,
        financialAssistance,
        eligibilityCriteria,
        requiredDocuments,
        deadline,
        startDate,
        endDate,
        officialWebsite,
        officialApplicationLink,
        category,
        isCentralScheme,
        applicableStates,
        applicableDistricts,
        applicableCrops,
        landRequirement,
        incomeRequirement,
        farmerCategory,
        genderRestrictions,
        ageRequirement,
        importantNotes,
        faqs,
        lastUpdatedDate,
        createdDate,
        status,
        isFeatured,
        priorityScore,
        languageVersions,
        isBookmarked,
      ];
}
