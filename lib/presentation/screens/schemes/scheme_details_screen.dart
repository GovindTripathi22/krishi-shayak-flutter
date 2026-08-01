import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/localization/app_localizations.dart';

import '../../../domain/entities/government_scheme_entity.dart';
import '../../../domain/repositories/government_scheme_repository.dart';
import '../../common_widgets/app_button.dart';
import '../../common_widgets/app_card.dart';
import '../../common_widgets/app_dialog.dart';
import '../../common_widgets/app_error_widget.dart';
import '../../common_widgets/app_loading_indicator.dart';
import '../../common_widgets/app_top_bar.dart';
import '../ai_chat/ai_chat_screen.dart';
import '../../providers/scheme_providers.dart';

final schemeDetailsProvider =
    FutureProvider.family<GovernmentSchemeEntity?, String>((ref, schemeId) async {
  final repo = sl<GovernmentSchemeRepository>();
  return await repo.getSchemeById(schemeId);
});

class SchemeDetailsScreen extends ConsumerWidget {
  final String schemeId;

  const SchemeDetailsScreen({
    super.key,
    required this.schemeId,
  });

  void _openOfficialPortal(BuildContext context, String url, String portalTitle) {
    // HTTPS Validation
    final Uri? targetUri = Uri.tryParse(url);
    if (targetUri == null || !targetUri.isScheme('HTTPS') && !targetUri.isScheme('HTTP')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid government portal URL')),
      );
      return;
    }

    AppDialog.show(
      context: context,
      title: 'Redirecting to Official Portal',
      message: 'You are leaving KrishiSahayak and being directed to the official government website:\n\n$url\n\nEnsure you submit your application only on verified .gov.in portals.',
      primaryButtonText: 'Proceed to Official Site',
      onPrimaryPressed: () async {
        if (await canLaunchUrl(targetUri)) {
          await launchUrl(targetUri, mode: LaunchMode.externalApplication);
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening portal URL: $url')),
            );
          }
        }
      },
      secondaryButtonText: 'Cancel',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final schemeAsync = ref.watch(schemeDetailsProvider(schemeId));
    final bookmarkedIds = ref.watch(bookmarkNotifierProvider);

    return Scaffold(
      appBar: AppTopBar(
        title: 'Scheme Details',
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sharing scheme link with farmer friends...')),
              );
            },
          ),
          IconButton(
            icon: Icon(
              bookmarkedIds.contains(schemeId) ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              color: AppColors.primary,
            ),
            onPressed: () {
              ref.read(bookmarkNotifierProvider.notifier).toggleBookmark(schemeId);
            },
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      body: SafeArea(
        child: schemeAsync.when(
          data: (scheme) {
            if (scheme == null) {
              return const Center(child: Text('Scheme not found.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hero Card Banner
                  AppCard(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text(
                                scheme.isCentralScheme ? 'Central Government' : 'State Government',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12.0),
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.verified_user_rounded, color: AppColors.accent),
                          ],
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          scheme.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          scheme.shortDescription,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Financial Benefits Highlight
                  AppCard(
                    backgroundColor: AppColors.primaryContainer,
                    child: Row(
                      children: [
                        const Icon(Icons.payments_rounded, size: 40.0, color: AppColors.primary),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Financial Assistance & Benefit',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(scheme.benefits, style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Detailed Description
                  Text('Detailed Description', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  Text(scheme.detailedDescription, style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 24.0),

                  Text('Scheme Information', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category: ${scheme.category}'),
                        const SizedBox(height: 8.0),
                        if (scheme.deadline.isNotEmpty) Text('Application deadline: ${scheme.deadline}'),
                        if (scheme.deadline.isNotEmpty) const SizedBox(height: 8.0),
                        Text('Applicable states: ${scheme.applicableStates.join(', ')}'),
                        const SizedBox(height: 8.0),
                        Text('Applicable crops: ${scheme.applicableCrops.join(', ')}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Eligibility Checklist
                  Text('Eligibility Criteria', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  AppCard(
                    child: Column(
                      children: scheme.eligibilityCriteria
                          .map((crit) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check_circle_outline, color: AppColors.primary, size: 20.0),
                                    const SizedBox(width: 10.0),
                                    Expanded(child: Text(crit, style: theme.textTheme.bodyMedium)),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Required Documents
                  Text('Required Documents', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8.0),
                  AppCard(
                    child: Column(
                      children: scheme.requiredDocuments
                          .map((doc) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.description_outlined, color: AppColors.accentDark, size: 20.0),
                                    const SizedBox(width: 10.0),
                                    Expanded(child: Text(doc, style: theme.textTheme.bodyMedium)),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  if (scheme.importantNotes.isNotEmpty) ...[
                    Text('Important Notes', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    AppCard(
                      child: Column(
                        children: scheme.importantNotes.map((note) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20.0),
                            const SizedBox(width: 10.0),
                            Expanded(child: Text(note)),
                          ]),
                        )).toList(),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                  ],

                  // FAQs Accordion
                  if (scheme.faqs.isNotEmpty) ...[
                    Text('Frequently Asked Questions (FAQs)', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    ...scheme.faqs.map(
                      (faq) => AppCard(
                        child: ExpansionTile(
                          title: Text(faq.question, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(faq.answer, style: theme.textTheme.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                  ],

                  // Official Action Buttons
                  if (scheme.officialApplicationLink.isNotEmpty) ...[
                    AppButton(
                      text: 'Apply on Official Government Portal',
                      icon: Icons.open_in_new_rounded,
                      onPressed: () => _openOfficialPortal(context, scheme.officialApplicationLink, scheme.name),
                    ),
                    const SizedBox(height: 12.0),
                  ],
                  if (scheme.officialWebsite.isNotEmpty)
                    AppButton(
                      text: 'Visit Official Scheme Website',
                      type: AppButtonType.outlined,
                      icon: Icons.language_rounded,
                      onPressed: () => _openOfficialPortal(context, scheme.officialWebsite, scheme.name),
                    ),
                  const SizedBox(height: 12.0),
                  AppButton(
                    text: 'Explain this scheme with AI',
                    type: AppButtonType.outlined,
                    icon: Icons.auto_awesome_outlined,
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => AiChatScreen(schemeId: scheme.id, initialQuestion: 'Explain this scheme, including benefits, eligibility, documents, deadline, and how to apply.'))),
                  ),
                  const SizedBox(height: 24.0),
                ],
              ),
            );
          },
          loading: () => const AppLoadingIndicator(message: 'Loading scheme details...'),
          error: (err, stack) => AppErrorWidget(
            errorMessage: 'Unable to load this scheme. Check your connection and try again.',
            onRetry: () => ref.invalidate(schemeDetailsProvider(schemeId)),
          ),
        ),
      ),
    );
  }
}
