import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/services/network/connectivity_service.dart';
import '../../../core/services/voice/voice_service.dart';
import '../../../domain/entities/chat_message_entity.dart';

import '../../common_widgets/app_bottom_navigation.dart';
import '../../common_widgets/app_top_bar.dart';
import '../../common_widgets/language_selector_widget.dart';
import '../providers/chat_providers.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _suggestedPrompts = const [
    'Which schemes are available for cotton farmers?',
    'Am I eligible for PM-KISAN subsidy?',
    'What documents are needed for drip irrigation?',
    'Show government schemes for Maharashtra',
    'How do I claim PMFBY crop insurance?',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: AppConstants.durationFast,
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSend(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();
    ref.read(chatMessagesNotifierProvider.notifier).sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final chatState = ref.watch(chatMessagesNotifierProvider);
    final voiceState = ref.watch(voiceStateProvider);
    final networkStatus = ref.watch(connectivityProvider);

    ref.listen<ChatState>(chatMessagesNotifierProvider, (prev, next) {
      _scrollToBottom();
    });

    return Scaffold(
      appBar: AppTopBar(
        title: loc.aiChat,
        actions: [
          IconButton(
            icon: Icon(
              voiceState == VoiceState.speaking ? Icons.volume_up_rounded : Icons.volume_mute_rounded,
              color: AppColors.primary,
            ),
            tooltip: 'Toggle Voice Read Aloud',
            onPressed: () {
              if (voiceState == VoiceState.speaking) {
                ref.read(voiceStateProvider.notifier).stopSpeech();
              } else {
                ref.read(voiceStateProvider.notifier).speak('Reading latest AI advisory aloud in your language');
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.language_rounded, color: AppColors.primary),
            onPressed: () => LanguageSelectorWidget.showLanguageModal(context),
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 2),
      body: SafeArea(
        child: Column(
          children: [
            // Offline Warning Banner
            if (networkStatus == NetworkStatus.offline)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                color: Colors.orange.shade800,
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 18.0),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'Offline Mode: Viewing past messages. Live AI requires internet.',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

            // Messages View
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                itemCount: chatState.messages.length,
                itemBuilder: (context, index) {
                  final message = chatState.messages[index];
                  return _ChatMessageBubble(message: message);
                },
              ),
            ),

            // Suggested Prompts Horizontal Bar
            if (!chatState.isStreaming)
              SizedBox(
                height: 44.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
                  itemCount: _suggestedPrompts.length,
                  itemBuilder: (context, index) {
                    final promptText = _suggestedPrompts[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ActionChip(
                        avatar: const Icon(Icons.auto_awesome, size: 14.0, color: AppColors.primary),
                        label: Text(promptText, style: const TextStyle(fontSize: 12.0)),
                        backgroundColor: AppColors.primaryContainer.withOpacity(0.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () => _handleSend(promptText),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 8.0),

            // Input Bar & Voice Mic Trigger
            Container(
              padding: const EdgeInsets.all(AppConstants.paddingSmall),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: const [
                  BoxShadow(color: AppColors.shadowLight, blurRadius: 8.0, offset: Offset(0, -2)),
                ],
              ),
              child: Row(
                children: [
                  // Voice STT Microphone Button
                  IconButton(
                    icon: AnimatedContainer(
                      duration: AppConstants.durationFast,
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: voiceState == VoiceState.listening ? AppColors.errorContainer : AppColors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        voiceState == VoiceState.listening ? Icons.mic : Icons.mic_none_rounded,
                        color: voiceState == VoiceState.listening ? AppColors.error : AppColors.primary,
                        size: 24.0,
                      ),
                    ),
                    tooltip: 'Speech to Text Voice Input',
                    onPressed: () {
                      if (voiceState == VoiceState.listening) {
                        ref.read(voiceStateProvider.notifier).stopListening();
                      } else {
                        ref.read(voiceStateProvider.notifier).startListening();
                        _textController.text = 'Tell me about cotton crop insurance subsidy';
                      }
                    },
                  ),

                  // Text Field
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: _handleSend,
                      decoration: InputDecoration(
                        hintText: 'Ask in your language or tap mic...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                      ),
                    ),
                  ),

                  // Send Action Button
                  IconButton(
                    icon: const Icon(Icons.send_rounded, color: AppColors.primary, size: 28.0),
                    onPressed: () => _handleSend(_textController.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessageBubble extends ConsumerWidget {
  final ChatMessageEntity message;

  const _ChatMessageBubble({required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.all(14.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.primary : AppColors.surfaceLight,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
            bottomLeft: Radius.circular(message.isUser ? 16.0 : 4.0),
            bottomRight: Radius.circular(message.isUser ? 4.0 : 16.0),
          ),
          boxShadow: const [
            BoxShadow(color: AppColors.shadowLight, blurRadius: 4.0, offset: Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser)
              Row(
                children: [
                  const Icon(Icons.eco_rounded, size: 16.0, color: AppColors.primary),
                  const SizedBox(width: 6.0),
                  Text(
                    'AgriSathi AI Advisor',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            if (!message.isUser) const SizedBox(height: 6.0),

            Text(
              message.text.isEmpty && message.isStreaming ? 'Thinking & evaluating government rules...' : message.text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: message.isUser ? Colors.white : AppColors.onBackgroundLight,
                height: 1.4,
              ),
            ),

            // Referenced Schemes & Links
            if (!message.isUser && message.referencedSchemeNames.isNotEmpty) ...[
              const SizedBox(height: 10.0),
              Wrap(
                spacing: 6.0,
                children: message.referencedSchemeNames
                    .map((sName) => Chip(
                          label: Text(sName, style: const TextStyle(fontSize: 10.0, fontWeight: FontWeight.bold)),
                          backgroundColor: AppColors.primaryContainer,
                        ))
                    .toList(),
              ),
            ],

            // Message Toolbar Actions
            if (!message.isUser && !message.isStreaming) ...[
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 16.0, color: AppColors.outlineLight),
                    tooltip: 'Copy text',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: message.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Message copied to clipboard')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.volume_up_rounded, size: 16.0, color: AppColors.primary),
                    tooltip: 'Read Aloud (TTS)',
                    onPressed: () {
                      ref.read(voiceStateProvider.notifier).speak(message.text);
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
