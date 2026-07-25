import '../entities/checklist_item_entity.dart';
import '../entities/scheme_checklist_entity.dart';

abstract class ChecklistRepository {
  Future<SchemeChecklistEntity> getChecklistForScheme(String schemeId);
  Future<void> updateItemStatus(String schemeId, String itemId, DocumentStatus newStatus);
}
