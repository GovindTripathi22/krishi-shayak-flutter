import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/checklist_item_entity.dart';
import '../../common_widgets/app_card.dart';
import '../../common_widgets/app_loading_indicator.dart';
import '../../common_widgets/app_search_bar.dart';
import '../../common_widgets/app_top_bar.dart';
import '../providers/checklist_providers.dart';

class DocumentChecklistScreen extends ConsumerWidget {
  final String schemeId;

  const DocumentChecklistScreen({super.key, required this.schemeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final checklistAsync = ref.watch(schemeChecklistNotifierProvider(schemeId));
    final searchQuery = ref.watch(checklistSearchQueryProvider);

    return Scaffold(
      appBar: AppTopBar(title: 'Required Document Checklist'),
      body: SafeArea(
        child: checklistAsync.when(
          data: (checklist) {
            final filteredItems = checklist.items.where((i) {
              if (searchQuery.trim().isEmpty) return true;
              return i.documentName.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  i.purposeExplanation.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            final pct = checklist.completionPercentage;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Scheme Title Header Card
                  AppCard(
                    backgroundColor: AppColors.primaryContainer.withOpacity(0.4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Government Scheme Checklist', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4.0),
                        Text(
                          checklist.schemeName,
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Real-Time Progress Card
                  AppCard(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Document Preparedness',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${pct.toInt()}% Completed',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: pct >= 100.0 ? AppColors.primary : AppColors.accentDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: LinearProgressIndicator(
                            value: pct / 100.0,
                            minHeight: 10.0,
                            backgroundColor: Colors.grey.shade200,
                            color: pct >= 100.0 ? AppColors.primary : AppColors.accent,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _MetricItem(label: 'Completed', count: checklist.completedCount, color: AppColors.primary),
                            _MetricItem(label: 'Pending', count: checklist.pendingCount, color: Colors.orange.shade800),
                            _MetricItem(label: 'Not Available', count: checklist.missingCount, color: AppColors.error),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Missing Documents Warning Banner
                  if (checklist.pendingCount > 0 || checklist.missingCount > 0)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                        border: Border.all(color: Colors.orange.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.orange.shade900),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Text(
                              'Ensure all required documents are marked Completed before submitting your application.',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange.shade900, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Search Bar
                  AppSearchBar(
                    hintText: 'Search documents by name...',
                    onChanged: (val) {
                      ref.read(checklistSearchQueryProvider.notifier).state = val;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Checklist Items List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return _ChecklistItemCard(
                        item: item,
                        onStatusChanged: (newStatus) {
                          ref
                              .read(schemeChecklistNotifierProvider(schemeId).notifier)
                              .updateItemStatus(item.id, newStatus);
                        },
                      );
                    },
                  ),
                ],
              ),
            );
          },
          loading: () => const AppLoadingIndicator(message: 'Generating scheme document checklist...'),
          error: (err, stack) => Center(child: Text('Error loading checklist: $err')),
        ),
      ),
    );
  }
}

class _ChecklistItemCard extends StatelessWidget {
  final ChecklistItemEntity item;
  final ValueChanged<DocumentStatus> onStatusChanged;

  const _ChecklistItemCard({
    required this.item,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppCard(
      margin: const EdgeInsets.only(bottom: 14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                item.status == DocumentStatus.completed
                    ? Icons.check_circle
                    : item.status == DocumentStatus.pending
                        ? Icons.pending_rounded
                        : Icons.cancel_rounded,
                color: item.status == DocumentStatus.completed
                    ? AppColors.primary
                    : item.status == DocumentStatus.pending
                        ? Colors.orange.shade800
                        : AppColors.error,
                size: 22.0,
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  item.documentName,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  item.issuingAuthority,
                  style: theme.textTheme.labelSmall?.copyWith(fontSize: 10.0, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10.0),

          // AI Explanation Card
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded, size: 16.0, color: AppColors.primary),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    item.purposeExplanation,
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.onBackgroundLight),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12.0),

          // Segmented Button Selector
          SegmentedButton<DocumentStatus>(
            segments: const [
              ButtonSegment(value: DocumentStatus.completed, label: Text('Done', style: TextStyle(fontSize: 12.0))),
              ButtonSegment(value: DocumentStatus.pending, label: Text('Pending', style: TextStyle(fontSize: 12.0))),
              ButtonSegment(value: DocumentStatus.notAvailable, label: Text('Missing', style: TextStyle(fontSize: 12.0))),
            ],
            selected: {item.status},
            onSelectionChanged: (set) {
              if (set.isNotEmpty) {
                onStatusChanged(set.first);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _MetricItem({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          '$count',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: AppColors.outlineLight),
        ),
      ],
    );
  }
}
