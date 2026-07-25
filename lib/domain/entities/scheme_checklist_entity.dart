import 'package:equatable/equatable.dart';
import 'checklist_item_entity.dart';

class SchemeChecklistEntity extends Equatable {
  final String schemeId;
  final String schemeName;
  final List<ChecklistItemEntity> items;
  final DateTime lastUpdated;

  const SchemeChecklistEntity({
    required this.schemeId,
    required this.schemeName,
    required this.items,
    required this.lastUpdated,
  });

  double get completionPercentage {
    if (items.isEmpty) return 0.0;
    final completedCount = items.where((i) => i.status == DocumentStatus.completed).length;
    return (completedCount / items.length) * 100.0;
  }

  int get completedCount => items.where((i) => i.status == DocumentStatus.completed).length;
  int get pendingCount => items.where((i) => i.status == DocumentStatus.pending).length;
  int get missingCount => items.where((i) => i.status == DocumentStatus.notAvailable).length;

  SchemeChecklistEntity copyWith({
    String? schemeId,
    String? schemeName,
    List<ChecklistItemEntity>? items,
    DateTime? lastUpdated,
  }) {
    return SchemeChecklistEntity(
      schemeId: schemeId ?? this.schemeId,
      schemeName: schemeName ?? this.schemeName,
      items: items ?? this.items,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  List<Object?> get props => [schemeId, schemeName, items, lastUpdated];
}
