import 'package:equatable/equatable.dart';

enum DocumentStatus { completed, pending, notAvailable }

extension DocumentStatusX on DocumentStatus {
  String get label {
    switch (this) {
      case DocumentStatus.completed:
        return 'Completed';
      case DocumentStatus.pending:
        return 'Pending';
      case DocumentStatus.notAvailable:
        return 'Not Available';
    }
  }
}

class ChecklistItemEntity extends Equatable {
  final String id;
  final String documentName;
  final String purposeExplanation;
  final DocumentStatus status;
  final bool isRequired;
  final String issuingAuthority;

  const ChecklistItemEntity({
    required this.id,
    required this.documentName,
    required this.purposeExplanation,
    this.status = DocumentStatus.pending,
    this.isRequired = true,
    this.issuingAuthority = 'Government Authority',
  });

  ChecklistItemEntity copyWith({
    String? id,
    String? documentName,
    String? purposeExplanation,
    DocumentStatus? status,
    bool? isRequired,
    String? issuingAuthority,
  }) {
    return ChecklistItemEntity(
      id: id ?? this.id,
      documentName: documentName ?? this.documentName,
      purposeExplanation: purposeExplanation ?? this.purposeExplanation,
      status: status ?? this.status,
      isRequired: isRequired ?? this.isRequired,
      issuingAuthority: issuingAuthority ?? this.issuingAuthority,
    );
  }

  @override
  List<Object?> get props => [
        id,
        documentName,
        purposeExplanation,
        status,
        isRequired,
        issuingAuthority,
      ];
}
