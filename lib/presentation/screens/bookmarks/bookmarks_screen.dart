import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../domain/entities/government_scheme_entity.dart';
import '../../../domain/repositories/bookmark_repository.dart';
import '../../../core/di/injection_container.dart';

import '../../common_widgets/app_bottom_navigation.dart';
import '../../common_widgets/app_empty_state_widget.dart';
import '../../common_widgets/app_error_widget.dart';
import '../../common_widgets/app_top_bar.dart';
import '../schemes/scheme_details_screen.dart';
import '../schemes/widgets/scheme_card_widget.dart';
import '../../providers/scheme_providers.dart';

final bookmarkedSchemesListProvider = FutureProvider<List<GovernmentSchemeEntity>>((ref) async {
  ref.watch(bookmarkNotifierProvider);
  final repo = sl<BookmarkRepository>();
  return await repo.getBookmarkedSchemes();
});

class BookmarksScreen extends ConsumerWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final bookmarksAsync = ref.watch(bookmarkedSchemesListProvider);

    return Scaffold(
      appBar: AppTopBar(title: loc.bookmarks),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 3),
      body: SafeArea(
        child: bookmarksAsync.when(
          data: (schemes) {
            if (schemes.isEmpty) {
              return const AppEmptyStateWidget(
                title: 'No Saved Schemes Yet',
                description: 'Save important government subsidies and schemes by tapping the bookmark icon while browsing.',
                icon: Icons.bookmark_outline_rounded,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              itemCount: schemes.length,
              itemBuilder: (context, index) {
                final scheme = schemes[index];
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
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => AppErrorWidget(
            errorMessage: 'Unable to load your saved schemes. Please try again.',
            onRetry: () => ref.invalidate(bookmarkedSchemesListProvider),
          ),
        ),
      ),
    );
  }
}
