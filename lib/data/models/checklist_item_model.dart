import '../../domain/entities/checklist_item_entity.dart';

class ChecklistItemModel extends ChecklistItemEntity {
  const ChecklistItemModel({
    required super.id,
    required super.documentName,
    required super.purposeExplanation,
    super.status,
    super.isRequired,
    super.issuingAuthority,
  });

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) {
    return ChecklistItemModel(
      id: json['id'] as String? ?? '',
      documentName: json['documentName'] as String? ?? '',
      purposeExplanation: json['purposeExplanation'] as String? ?? '',
      status: DocumentStatus.values.firstWhere(
        (s) => s.name == (json['status'] as String? ?? 'pending'),
        orElse: () => DocumentStatus.pending,
      ),
      isRequired: json['isRequired'] as bool? ?? true,
      issuingAuthority: json['issuingAuthority'] as String? ?? 'Government Authority',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentName': documentName,
      'purposeExplanation': purposeExplanation,
      'status': status.name,
      'isRequired': isRequired,
      'issuingAuthority': issuingAuthority,
    };
  }
}
