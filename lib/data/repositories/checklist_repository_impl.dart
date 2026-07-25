import 'dart:convert';

import '../../core/logger/app_logger.dart';
import '../../core/services/checklist/checklist_engine.dart';
import '../../core/services/storage/preferences_service.dart';
import '../../domain/entities/checklist_item_entity.dart';
import '../../domain/entities/scheme_checklist_entity.dart';
import '../../domain/repositories/checklist_repository.dart';
import '../../domain/repositories/government_scheme_repository.dart';
import '../models/scheme_checklist_model.dart';

class ChecklistRepositoryImpl implements ChecklistRepository {
  final GovernmentSchemeRepository schemeRepository;
  static const String _keyPrefix = 'pref_scheme_checklist_';

  ChecklistRepositoryImpl({required this.schemeRepository});

  @override
  Future<SchemeChecklistEntity> getChecklistForScheme(String schemeId) async {
    try {
      final rawStr = PreferencesService.getString('$_keyPrefix$schemeId');
      if (rawStr != null && rawStr.isNotEmpty) {
        final Map<String, dynamic> json = jsonDecode(rawStr);
        return SchemeChecklistModel.fromJson(json);
      }
    } catch (e, stack) {
      AppLogger.error('ChecklistRepositoryImpl: Error reading checklist for $schemeId', e, stack);
    }

    // Generate fresh checklist from scheme repository
    final scheme = await schemeRepository.getSchemeById(schemeId);
    if (scheme != null) {
      final generated = ChecklistEngine.generateChecklist(scheme);
      await _saveChecklist(generated);
      return generated;
    }

    // Fallback default checklist
    return SchemeChecklistEntity(
      schemeId: schemeId,
      schemeName: 'Government Scheme Checklist',
      items: const [],
      lastUpdated: DateTime.now(),
    );
  }

  @override
  Future<void> updateItemStatus(String schemeId, String itemId, DocumentStatus newStatus) async {
    final current = await getChecklistForScheme(schemeId);
    final updatedItems = current.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(status: newStatus);
      }
      return item;
    }).toList();

    final updatedChecklist = current.copyWith(
      items: updatedItems,
      lastUpdated: DateTime.now(),
    );

    await _saveChecklist(updatedChecklist);
  }

  Future<void> _saveChecklist(SchemeChecklistEntity checklist) async {
    final model = SchemeChecklistModel(
      schemeId: checklist.schemeId,
      schemeName: checklist.schemeName,
      items: checklist.items,
      lastUpdated: checklist.lastUpdated,
    );
    final jsonStr = jsonEncode(model.toJson());
    await PreferencesService.setString('$_keyPrefix${checklist.schemeId}', jsonStr);
  }
}
