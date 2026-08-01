import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations_provider.dart';
import '../../../core/services/voice/voice_service.dart';
import '../../common_widgets/app_loading_indicator.dart';
import '../../common_widgets/app_top_bar.dart';
import '../../providers/chat_providers.dart';

class AiChatScreen extends ConsumerStatefulWidget {
  final String? schemeId;
  final String? initialQuestion;
  const AiChatScreen({super.key, this.schemeId, this.initialQuestion});

  @override
  ConsumerState<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends ConsumerState<AiChatScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialQuestion != null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (_) => _send(widget.initialQuestion));
    }
  }

  void _send([String? value]) {
    final text = (value ?? _controller.text).trim();
    if (text.isEmpty) return;
    _controller.clear();
    ref
        .read(chatMessagesNotifierProvider.notifier)
        .sendMessage(text, schemeId: widget.schemeId);
  }

  void _startVoiceInput() {
    final voiceNotifier = ref.read(voiceServiceProvider.notifier);
    final currentLang = ref.read(localeProvider).languageCode;

    voiceNotifier.startListening(
      onResult: (text) {
        _controller.text = text;
        _send(text);
      },
      languageCode: currentLang,
    );
  }

  void _speakLastResponse() {
    final messages = ref.read(chatMessagesNotifierProvider).messages;
    final lastAiMsg = messages.lastWhere(
      (m) => !m.isUser,
      orElse: () => messages.first,
    );
    final currentLang = ref.read(localeProvider).languageCode;
    ref
        .read(voiceServiceProvider.notifier)
        .speakAiResponse(lastAiMsg.text, languageCode: currentLang);
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatMessagesNotifierProvider);
    final suggestions = ref.watch(chatSuggestionsProvider);
    final voiceState = ref.watch(voiceServiceProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppTopBar(
        title: 'KrishiSahayak Assistant',
        actions: [
          if (chatState.messages.any((m) => !m.isUser))
            IconButton(
              icon: const Icon(Icons.volume_up_rounded),
              tooltip: 'Read last response aloud',
              onPressed: voiceState.state == VoiceState.speaking
                  ? () => ref.read(voiceServiceProvider.notifier).stopSpeech()
                  : _speakLastResponse,
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.primary),
            onPressed: () =>
                ref.read(chatMessagesNotifierProvider.notifier).clearHistory(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Info Banner
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingMedium, vertical: 8),
              child: Text(
                'Ask about official government schemes. Answers are based on retrieved scheme records.',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),

            // Voice status indicator
            if (voiceState.state == VoiceState.listening)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mic_rounded,
                        color: Colors.red, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      voiceState.recognizedText.isNotEmpty
                          ? voiceState.recognizedText
                          : 'Listening... Speak now',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () =>
                          ref.read(voiceServiceProvider.notifier).cancelListening(),
                      child: const Icon(Icons.close, size: 16, color: Colors.red),
                    ),
                  ],
                ),
              ),

            // Speaking indicator
            if (voiceState.state == VoiceState.speaking)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.volume_up_rounded,
                        color: Colors.green, size: 18),
                    const SizedBox(width: 8),
                    const Text('Reading response...',
                        style: TextStyle(color: Colors.green)),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () =>
                          ref.read(voiceServiceProvider.notifier).stopSpeech(),
                      child:
                          const Icon(Icons.stop, size: 16, color: Colors.green),
                    ),
                  ],
                ),
              ),

            // Suggestion chips
            suggestions.when(
              data: (items) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMedium),
                child: Row(
                  children: items
                      .map((item) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ActionChip(
                                label: Text(item),
                                onPressed: () => _send(item)),
                          ))
                      .toList(),
                ),
              ),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),

            // Chat messages
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                itemCount: chatState.messages.length,
                itemBuilder: (context, index) {
                  final message = chatState.messages[index];
                  return Align(
                    alignment: message.isUser
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.84),
                      decoration: BoxDecoration(
                        color: message.isUser
                            ? AppColors.primary
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: message.isUser
                            ? null
                            : Border.all(color: AppColors.primaryContainer),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.text,
                            style: TextStyle(
                                color: message.isUser
                                    ? Colors.white
                                    : AppColors.textDark),
                          ),
                          if (!message.isUser &&
                              message.referencedSchemeNames.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                'Sources: ${message.referencedSchemeNames.join(', ')}',
                                style: theme.textTheme.bodySmall
                                    ?.copyWith(color: AppColors.primary),
                              ),
                            ),
                          // TTS button on AI messages
                          if (!message.isUser)
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () {
                                  final lang = ref
                                      .read(localeProvider)
                                      .languageCode;
                                  ref
                                      .read(voiceServiceProvider.notifier)
                                      .speakAiResponse(message.text,
                                          languageCode: lang);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.only(top: 4),
                                  child: Icon(Icons.volume_up_outlined,
                                      size: 16, color: AppColors.primary),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (chatState.isStreaming)
              const AppLoadingIndicator(
                  message: 'Checking official scheme information...'),
            if (chatState.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(chatState.errorMessage!,
                    style: const TextStyle(color: AppColors.error)),
              ),

            // Input row with microphone
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Mic button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: voiceState.state == VoiceState.listening
                          ? Colors.red.shade50
                          : theme.colorScheme.surfaceContainerHighest,
                    ),
                    child: IconButton(
                      icon: Icon(
                        voiceState.state == VoiceState.listening
                            ? Icons.mic_rounded
                            : Icons.mic_none_rounded,
                        color: voiceState.state == VoiceState.listening
                            ? Colors.red
                            : AppColors.primary,
                      ),
                      onPressed: voiceState.state == VoiceState.listening
                          ? () => ref
                              .read(voiceServiceProvider.notifier)
                              .stopListening()
                          : _startVoiceInput,
                      tooltip: 'Voice input',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onSubmitted: _send,
                      decoration: const InputDecoration(
                          hintText: 'Ask a scheme question...'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send_rounded,
                        color: AppColors.primary),
                    onPressed: _send,
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
