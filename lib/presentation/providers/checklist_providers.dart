import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/injection_container.dart';
import '../../domain/entities/checklist_item_entity.dart';
import '../../domain/entities/scheme_checklist_entity.dart';
import '../../domain/repositories/checklist_repository.dart';

final checklistSearchQueryProvider = StateProvider<String>((ref) => '');

final schemeChecklistNotifierProvider = StateNotifierProvider.family<
    SchemeChecklistNotifier, AsyncValue<SchemeChecklistEntity>, String>((ref, schemeId) {
  return SchemeChecklistNotifier(
    repository: sl<ChecklistRepository>(),
    schemeId: schemeId,
  );
});

class SchemeChecklistNotifier extends StateNotifier<AsyncValue<SchemeChecklistEntity>> {
  final ChecklistRepository repository;
  final String schemeId;

  SchemeChecklistNotifier({
    required this.repository,
    required this.schemeId,
  }) : super(const AsyncValue.loading()) {
    loadChecklist();
  }

  Future<void> loadChecklist() async {
    try {
      final checklist = await repository.getChecklistForScheme(schemeId);
      state = AsyncValue.data(checklist);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> updateItemStatus(String itemId, DocumentStatus newStatus) async {
    state.whenData((checklist) async {
      await repository.updateItemStatus(schemeId, itemId, newStatus);
      await loadChecklist();
    });
  }
}
