import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';

import '../../common_widgets/app_bottom_navigation.dart';
import '../../common_widgets/app_card.dart';
import '../../common_widgets/app_empty_state_widget.dart';
import '../../common_widgets/app_loading_indicator.dart';
import '../../common_widgets/app_search_bar.dart';
import '../../common_widgets/app_top_bar.dart';
import '../providers/document_providers.dart';
import 'document_details_screen.dart';

class PdfExplainerScreen extends ConsumerWidget {
  const PdfExplainerScreen({super.key});

  void _processMockUpload(BuildContext context, WidgetRef ref, String fileName, String fileType) async {
    final doc = await ref.read(documentProcessingNotifierProvider.notifier).processFile(
          filePath: '/storage/emulated/0/Download/$fileName',
          fileName: fileName,
          fileType: fileType,
          fileSize: '1.4 MB',
        );

    if (doc != null && context.mounted) {
      ref.read(savedDocumentsNotifierProvider.notifier).loadDocuments();
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DocumentDetailsScreen(document: doc),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final savedDocs = ref.watch(savedDocumentsNotifierProvider);
    final procState = ref.watch(documentProcessingNotifierProvider);

    return Scaffold(
      appBar: AppTopBar(title: 'AI Document Intelligence'),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 0),
      body: SafeArea(
        child: Column(
          children: [
            // Processing Overlay / Progress Bar
            if (procState.isProcessing)
              Container(
                padding: const EdgeInsets.all(16.0),
                color: AppColors.primaryContainer,
                child: Column(
                  children: [
                    LinearProgressIndicator(value: procState.progress, backgroundColor: Colors.white, color: AppColors.primary),
                    const SizedBox(height: 8.0),
                    Text(
                      procState.statusMessage ?? 'Processing Document...',
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

            // Upload Options Bar
            Padding(
              padding: const EdgeInsets.all(AppConstants.paddingMedium),
              child: AppCard(
                backgroundColor: AppColors.surfaceLight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload Government Circular or Scheme PDF',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      'Upload any circular or scan a brochure to extract benefits, eligibility, and deadlines instantly.',
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.outlineLight),
                    ),
                    const SizedBox(height: 14.0),

                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.upload_file_rounded, size: 18.0),
                            label: const Text('Upload PDF'),
                            onPressed: () => _processMockUpload(context, ref, 'Drip_Irrigation_Scheme_2026.pdf', 'pdf'),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.camera_alt_rounded, size: 18.0),
                            label: const Text('Scan Image'),
                            onPressed: () => _processMockUpload(context, ref, 'PMKSY_Brochure_Scan.jpeg', 'image'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Document Search & List Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              child: AppSearchBar(
                hintText: 'Search inside uploaded documents...',
                onChanged: (val) {
                  ref.read(documentSearchQueryProvider.notifier).state = val;
                },
              ),
            ),
            const SizedBox(height: 12.0),

            // Document List View
            Expanded(
              child: procState.isProcessing
                  ? const AppLoadingIndicator(message: 'Executing OCR & Gemini analysis...')
                  : savedDocs.isEmpty
                      ? AppEmptyStateWidget(
                          title: 'No Documents Uploaded Yet',
                          description: 'Upload official government PDFs or capture photos of scheme circulars to simplify complex terms.',
                          icon: Icons.picture_as_pdf_outlined,
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                          itemCount: savedDocs.length,
                          itemBuilder: (context, index) {
                            final doc = savedDocs[index];
                            return AppCard(
                              margin: const EdgeInsets.only(bottom: 12.0),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => DocumentDetailsScreen(document: doc),
                                  ),
                                );
                              },
                              child: ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
                                  ),
                                  child: Icon(
                                    doc.fileType == 'pdf' ? Icons.picture_as_pdf_rounded : Icons.image_rounded,
                                    color: AppColors.primary,
                                  ),
                                ),
                                title: Text(
                                  doc.fileName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${doc.category} • ${doc.fileSize}',
                                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.outlineLight),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: AppColors.error),
                                  onPressed: () {
                                    ref.read(savedDocumentsNotifierProvider.notifier).deleteDoc(doc.id);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
