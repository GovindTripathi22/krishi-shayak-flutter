import '../../core/services/backend/api_client.dart';
import '../../domain/entities/checklist_item_entity.dart';
import '../../domain/entities/scheme_checklist_entity.dart';
import '../../domain/repositories/checklist_repository.dart';

class ChecklistRepositoryImpl implements ChecklistRepository {
  final ApiClient _apiClient;
  final Map<String, SchemeChecklistEntity> _cache = {};
  ChecklistRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  SchemeChecklistEntity _fromApi(Map<String, dynamic> data) {
    final items = (data['items'] as List<dynamic>? ?? []).map((item) { final value = Map<String, dynamic>.from(item as Map); return ChecklistItemEntity(id: value['id'].toString(), documentName: value['name'].toString(), purposeExplanation: value['explanation']?.toString() ?? '', status: value['isComplete'] == true ? DocumentStatus.completed : DocumentStatus.pending, issuingAuthority: value['source']?.toString() ?? 'Official scheme record'); }).toList();
    return SchemeChecklistEntity(schemeId: data['schemeId'].toString(), schemeName: data['schemeName']?.toString() ?? 'Scheme checklist', items: items, lastUpdated: DateTime.now());
  }
  @override
  Future<SchemeChecklistEntity> getChecklistForScheme(String schemeId) async { final response = await _apiClient.get('/checklist/$schemeId') as Map<String, dynamic>; final checklist = _fromApi(Map<String, dynamic>.from(response['data'] as Map)); _cache[schemeId] = checklist; return checklist; }
  @override
  Future<void> updateItemStatus(String schemeId, String itemId, DocumentStatus newStatus) async { final current = _cache[schemeId] ?? await getChecklistForScheme(schemeId); final updated = current.items.map((item) => item.id == itemId ? item.copyWith(status: newStatus) : item).toList(); final completed = updated.where((item) => item.status == DocumentStatus.completed).map((item) => item.id).toList(); await _apiClient.post('/checklist/status', body: {'schemeId': schemeId, 'completedItemIds': completed}); _cache[schemeId] = current.copyWith(items: updated); }
}
