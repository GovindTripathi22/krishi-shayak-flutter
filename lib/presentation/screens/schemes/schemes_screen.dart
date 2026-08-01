import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/scheme_sort_option.dart';
import '../../common_widgets/app_bottom_navigation.dart';
import '../../common_widgets/app_empty_state_widget.dart';
import '../../common_widgets/app_error_widget.dart';
import '../../common_widgets/app_loading_indicator.dart';
import '../../common_widgets/app_search_bar.dart';
import '../../common_widgets/app_top_bar.dart';
import '../../providers/scheme_providers.dart';
import 'scheme_details_screen.dart';
import 'widgets/scheme_card_widget.dart';
import 'widgets/scheme_filter_bottom_sheet.dart';

class SchemesScreen extends ConsumerWidget {
  const SchemesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final schemesState = ref.watch(schemesListNotifierProvider);
    final selectedSort = ref.watch(schemeSortProvider);
    final filter = ref.watch(schemeFilterProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppTopBar(
        title: loc.schemes,
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_alt_rounded,
              color: filter.hasActiveFilters ? AppColors.primary : AppColors.outlineLight,
            ),
            tooltip: 'Filter Schemes',
            onPressed: () => SchemeFilterBottomSheet.show(context),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 1),
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar & Sort Dropdown
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                children: [
                  AppSearchBar(
                    hintText: 'Search schemes by crop, state, benefit...',
                    onChanged: (val) {
                      ref.read(searchQueryProvider.notifier).state = val;
                    },
                    onVoicePressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Listening for voice search in regional language...')),
                      );
                    },
                  ),
                  const SizedBox(height: 12.0),

                  // Sort Selector Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${schemesState.schemes.length} Schemes Available',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      DropdownButton<SchemeSortOption>(
                        value: selectedSort,
                        underline: const SizedBox(),
                        icon: const Icon(Icons.sort_rounded, color: AppColors.primary, size: 20.0),
                        items: SchemeSortOption.values
                            .map((s) => DropdownMenuItem(
                                  value: s,
                                  child: Text(s.label, style: const TextStyle(fontSize: 13.0)),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(schemeSortProvider.notifier).state = val;
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Schemes List / States
            Expanded(
              child: schemesState.isLoading && schemesState.schemes.isEmpty
                  ? const AppLoadingIndicator(message: 'Searching government schemes...')
                  : schemesState.errorMessage != null && schemesState.schemes.isEmpty
                      ? AppErrorWidget(
                          errorMessage: schemesState.errorMessage!,
                          onRetry: () => ref.read(schemesListNotifierProvider.notifier).fetchSchemes(refresh: true),
                        )
                      : schemesState.schemes.isEmpty
                          ? AppEmptyStateWidget(
                              title: 'No Matching Schemes',
                              description: 'Try adjusting your filters or search keywords to explore more subsidies.',
                              actionButtonText: 'Reset Filters',
                              onActionPressed: () {
                                ref.read(schemeFilterProvider.notifier).state = const SchemeFilterParams();
                                ref.read(searchQueryProvider.notifier).state = '';
                              },
                            )
                          : RefreshIndicator(
                              onRefresh: () async {
                                await ref.read(schemesListNotifierProvider.notifier).fetchSchemes(refresh: true);
                              },
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                                itemCount: schemesState.schemes.length,
                                itemBuilder: (context, index) {
                                  final scheme = schemesState.schemes[index];
                                  return SchemeCardWidget(
                                    scheme: scheme,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SchemeDetailsScreen(schemeId: scheme.id),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }
}
