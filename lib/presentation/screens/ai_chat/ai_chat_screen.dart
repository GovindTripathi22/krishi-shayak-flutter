import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/voice/voice_service.dart';
import '../../common_widgets/app_card.dart';
import '../../common_widgets/app_loading_indicator.dart';
import '../../common_widgets/app_top_bar.dart';
import '../providers/chat_providers.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  const AiChatScreen({super.key});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    ref.read(chatMessagesNotifierProvider.notifier).sendMessage(text);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final messages = ref.watch(chatMessagesNotifierProvider);
    final isStreaming = ref.watch(chatStreamingStateProvider);
    final voiceState = ref.watch(voiceStateProvider);

    return Scaffold(
      appBar: AppTopBar(
        title: 'KrishiSahayak AI Advisor',
        actions: [
          IconButton(
            icon: Icon(
              voiceState == VoiceState.speaking ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: AppColors.primary,
            ),
            onPressed: () {
              if (messages.isNotEmpty) {
                ref.read(voiceStateProvider.notifier).speak(messages.last.text);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            onPressed: () {
              ref.read(chatMessagesNotifierProvider.notifier).clearHistory();
            },
          ),
          const SizedBox(width: 8.0),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Modern Hero Banner
            Container(
              margin: const EdgeInsets.all(AppConstants.paddingMedium),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 12.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 26.0),
                  ),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'KrishiSahayak AI Assistant',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          'Powered by Gemini RAG • 7 Indian Languages',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Suggested Query Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium),
              child: Row(
                children: [
                  _buildChip('💰 PM-KISAN Status', () {
                    _messageController.text = 'Am I eligible for PM-KISAN scheme?';
                    _sendMessage();
                  }),
                  const SizedBox(width: 8.0),
                  _buildChip('🌧️ Crop Insurance', () {
                    _messageController.text = 'How to claim PMFBY crop insurance in Kharif?';
                    _sendMessage();
                  }),
                  const SizedBox(width: 8.0),
                  _buildChip('🚜 Tractor Subsidy', () {
                    _messageController.text = 'What is the SMAM tractor subsidy in Maharashtra?';
                    _sendMessage();
                  }),
                ],
              ),
            ),
            const SizedBox(height: 10.0),

            // Message List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isUser = msg.isUser;

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.85,
                      ),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: isUser ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0),
                          bottomLeft: Radius.circular(isUser ? 20.0 : 4.0),
                          bottomRight: Radius.circular(isUser ? 4.0 : 20.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: isUser ? null : Border.all(color: AppColors.primaryContainer),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isUser) ...[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryContainer,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    'Verified AI Advisory',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: AppColors.primaryDark,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8.0),
                          ],
                          Text(
                            msg.text,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isUser ? Colors.white : AppColors.textPrimary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (isStreaming)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: AppLoadingIndicator(message: 'Gemini AI is analyzing government schemes...'),
              ),

            // Input Dock Bar
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      voiceState == VoiceState.listening ? Icons.mic_rounded : Icons.mic_none_rounded,
                      color: voiceState == VoiceState.listening ? Colors.red : AppColors.primary,
                    ),
                    onPressed: () {
                      if (voiceState == VoiceState.listening) {
                        ref.read(voiceStateProvider.notifier).stopListening();
                      } else {
                        ref.read(voiceStateProvider.notifier).startListening();
                      }
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Ask in Marathi, Hindi, English...',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13.0),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  FloatingActionButton.small(
                    onPressed: _sendMessage,
                    backgroundColor: AppColors.primary,
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 18.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
      ),
    );
  }
}
