import '../../../domain/entities/checklist_item_entity.dart';
import '../../../domain/entities/government_scheme_entity.dart';
import '../../../domain/entities/scheme_checklist_entity.dart';

class ChecklistEngine {
  static SchemeChecklistEntity generateChecklist(GovernmentSchemeEntity scheme) {
    final List<ChecklistItemEntity> items = [];

    for (int i = 0; i < scheme.requiredDocuments.length; i++) {
      final docName = scheme.requiredDocuments[i];
      final explanation = getExplanationForDocument(docName);
      final authority = getAuthorityForDocument(docName);

      items.add(ChecklistItemEntity(
        id: 'chk_${scheme.id}_$i',
        documentName: docName,
        purposeExplanation: explanation,
        status: DocumentStatus.pending,
        isRequired: true,
        issuingAuthority: authority,
      ));
    }

    return SchemeChecklistEntity(
      schemeId: scheme.id,
      schemeName: scheme.name,
      items: items,
      lastUpdated: DateTime.now(),
    );
  }

  static String getExplanationForDocument(String docName) {
    final lower = docName.toLowerCase();
    if (lower.contains('aadhaar') || lower.contains('adhar')) {
      return 'Used to verify your unique identity and enable Direct Benefit Transfer (DBT) into your bank account.';
    } else if (lower.contains('7/12') || lower.contains('land') || lower.contains('holding')) {
      return 'Official land revenue record confirming ownership of agricultural land in your village.';
    } else if (lower.contains('bank') || lower.contains('passbook')) {
      return 'Confirms your active bank account number and IFSC code for receiving government subsidy funds.';
    } else if (lower.contains('insurance') || lower.contains('policy')) {
      return 'Proves active crop insurance coverage under PMFBY for risk compensation.';
    } else if (lower.contains('photo') || lower.contains('passport')) {
      return 'Required for beneficiary identity card and official portal records.';
    } else if (lower.contains('quote') || lower.contains('estimate') || lower.contains('quotation')) {
      return 'Vendor cost estimate for micro-irrigation or farm machinery subsidy approval.';
    } else if (lower.contains('sowing') || lower.contains('crop')) {
      return 'Village Talathi certificate confirming the specific crop cultivated in the current season.';
    }
    return 'Required official verification document to validate scheme eligibility.';
  }

  static String getAuthorityForDocument(String docName) {
    final lower = docName.toLowerCase();
    if (lower.contains('aadhaar')) return 'UIDAI / Aadhaar Portal';
    if (lower.contains('7/12') || lower.contains('land')) return 'Talathi / Revenue Department';
    if (lower.contains('bank')) return 'Nationalized / Cooperative Bank';
    if (lower.contains('sowing')) return 'Gram Panchayat / Agricultural Officer';
    return 'Government Authority';
  }
}
