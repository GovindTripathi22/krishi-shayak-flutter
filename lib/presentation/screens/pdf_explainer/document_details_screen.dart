import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/voice/voice_service.dart';
import '../../../domain/entities/parsed_document_entity.dart';
import '../../../domain/entities/smart_highlight_entity.dart';
import '../../common_widgets/app_button.dart';
import '../../common_widgets/app_card.dart';
import '../../common_widgets/app_top_bar.dart';
import '../providers/chat_providers.dart';

class DocumentDetailsScreen extends ConsumerWidget {
  final ParsedDocumentEntity document;

  const DocumentDetailsScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final voiceState = ref.watch(voiceStateProvider);

    return Scaffold(
      appBar: AppTopBar(
        title: 'AI Document Analysis',
        actions: [
          IconButton(
            icon: Icon(
              voiceState == VoiceState.speaking ? Icons.volume_up_rounded : Icons.volume_mute_rounded,
              color: AppColors.primary,
            ),
            tooltip: 'Listen to Summary',
            onPressed: () {
              if (voiceState == VoiceState.speaking) {
                ref.read(voiceStateProvider.notifier).stopSpeech();
              } else {
                ref.read(voiceStateProvider.notifier).speak(document.simpleSummary);
              }
            },
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.paddingMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              AppCard(
                backgroundColor: AppColors.primaryContainer.withOpacity(0.4),
                child: Row(
                  children: [
                    const Icon(Icons.picture_as_pdf_rounded, size: 44.0, color: AppColors.primary),
                    const SizedBox(width: 14.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            document.fileName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            'Category: ${document.category} • Size: ${document.fileSize}',
                            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.outlineLight),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),

              // Smart Highlights Chips Bar
              if (document.smartHighlights.isNotEmpty) ...[
                Text('Smart Document Highlights', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8.0),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 6.0,
                  children: document.smartHighlights.map((hl) {
                    Color bg = AppColors.primaryContainer;
                    Color fg = AppColors.primaryDark;
                    if (hl.type == HighlightType.money) {
                      bg = Colors.green.shade100;
                      fg = Colors.green.shade900;
                    } else if (hl.type == HighlightType.deadline) {
                      bg = Colors.red.shade100;
                      fg = Colors.red.shade900;
                    }
                    return Chip(
                      backgroundColor: bg,
                      label: Text(
                        hl.text,
                        style: TextStyle(color: fg, fontWeight: FontWeight.bold, fontSize: 12.0),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20.0),
              ],

              // Simple Summary
              Text('🌾 Simple Summary & Purpose', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(document.simpleSummary, style: theme.textTheme.bodyLarge?.copyWith(height: 1.4)),
                    const Divider(height: 20.0),
                    Text('Purpose:', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4.0),
                    Text(document.purpose, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              // Benefits & Financial Assistance
              Text('💰 Financial Benefits & Subsidies', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              AppCard(
                backgroundColor: AppColors.primaryContainer.withOpacity(0.3),
                child: Text(
                  document.benefits,
                  style: theme.textTheme.titleSmall?.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20.0),

              // Eligibility Checklist
              Text('✅ Eligibility Criteria', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              AppCard(
                child: Column(
                  children: document.eligibility
                      .map((el) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check_circle, color: AppColors.primary, size: 18.0),
                                const SizedBox(width: 10.0),
                                Expanded(child: Text(el, style: theme.textTheme.bodyMedium)),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 20.0),

              // Required Documents Checklist
              Text('📋 Required Documents', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              AppCard(
                child: Column(
                  children: document.requiredDocuments
                      .map((doc) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                const Icon(Icons.description, color: AppColors.accentDark, size: 18.0),
                                const SizedBox(width: 10.0),
                                Expanded(child: Text(doc, style: theme.textTheme.bodyMedium)),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 20.0),

              // Deadlines & Expiry Dates
              Text('⏰ Deadlines & Important Dates', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              AppCard(
                backgroundColor: Colors.orange.shade50,
                child: Column(
                  children: document.deadlines
                      .map((dl) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Icon(Icons.alarm_rounded, color: Colors.orange.shade900, size: 18.0),
                                const SizedBox(width: 10.0),
                                Expanded(child: Text(dl, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold))),
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: 24.0),

              // Ask AI About Document Trigger
              AppButton(
                text: 'Ask AI Questions About This Document',
                icon: Icons.question_answer_rounded,
                onPressed: () {
                  ref.read(chatMessagesNotifierProvider.notifier).sendMessage(
                        'Based on my uploaded document "${document.fileName}", explain the required documents and application process simply.',
                      );
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
