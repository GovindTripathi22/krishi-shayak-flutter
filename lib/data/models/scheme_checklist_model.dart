import '../../domain/entities/scheme_checklist_entity.dart';
import 'checklist_item_model.dart';

class SchemeChecklistModel extends SchemeChecklistEntity {
  const SchemeChecklistModel({
    required super.schemeId,
    required super.schemeName,
    required super.items,
    required super.lastUpdated,
  });

  factory SchemeChecklistModel.fromJson(Map<String, dynamic> json) {
    return SchemeChecklistModel(
      schemeId: json['schemeId'] as String? ?? '',
      schemeName: json['schemeName'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => ChecklistItemModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schemeId': schemeId,
      'schemeName': schemeName,
      'items': items.map((item) {
        if (item is ChecklistItemModel) return item.toJson();
        return ChecklistItemModel(
          id: item.id,
          documentName: item.documentName,
          purposeExplanation: item.purposeExplanation,
          status: item.status,
          isRequired: item.isRequired,
          issuingAuthority: item.issuingAuthority,
        ).toJson();
      }).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
