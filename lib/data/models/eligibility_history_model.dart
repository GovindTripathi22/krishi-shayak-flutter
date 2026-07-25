import '../../domain/entities/eligibility_history_entity.dart';

class EligibilityHistoryModel extends EligibilityHistoryEntity {
  const EligibilityHistoryModel({
    required super.id,
    required super.checkDate,
    required super.state,
    required super.crop,
    required super.totalEligibleCount,
    required super.topSchemeNames,
  });

  factory EligibilityHistoryModel.fromJson(Map<String, dynamic> json) {
    return EligibilityHistoryModel(
      id: json['id'] as String? ?? '',
      checkDate: json['checkDate'] != null
          ? DateTime.parse(json['checkDate'] as String)
          : DateTime.now(),
      state: json['state'] as String? ?? '',
      crop: json['crop'] as String? ?? '',
      totalEligibleCount: json['totalEligibleCount'] as int? ?? 0,
      topSchemeNames: (json['topSchemeNames'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkDate': checkDate.toIso8601String(),
      'state': state,
      'crop': crop,
      'totalEligibleCount': totalEligibleCount,
      'topSchemeNames': topSchemeNames,
    };
  }
}
