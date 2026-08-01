import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> _processUpload(BuildContext context, WidgetRef ref, {required String filePath, required String fileName, required String fileType, required int fileSizeBytes}) async {
    final doc = await ref.read(documentProcessingNotifierProvider.notifier).processFile(
          filePath: filePath,
          fileName: fileName,
          fileType: fileType,
          fileSize: '$fileSizeBytes bytes',
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

  Future<void> _pickPdf(BuildContext context, WidgetRef ref) async {
    final selection = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: const ['pdf']);
    final file = selection?.files.single;
    if (file?.path != null) await _processUpload(context, ref, filePath: file!.path!, fileName: file.name, fileType: 'pdf', fileSizeBytes: file.size);
  }

  Future<void> _pickImage(BuildContext context, WidgetRef ref, ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source, imageQuality: 90);
    if (image != null) await _processUpload(context, ref, filePath: image.path, fileName: image.name, fileType: 'image', fileSizeBytes: await image.length());
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
                            onPressed: procState.isProcessing ? null : () => _pickPdf(context, ref),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.camera_alt_rounded, size: 18.0),
                            label: const Text('Scan Image'),
                            onPressed: procState.isProcessing ? null : () => _pickImage(context, ref, ImageSource.camera),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        icon: const Icon(Icons.photo_library_outlined, size: 18),
                        label: const Text('Choose image from gallery'),
                        onPressed: procState.isProcessing ? null : () => _pickImage(context, ref, ImageSource.gallery),
                      ),
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
