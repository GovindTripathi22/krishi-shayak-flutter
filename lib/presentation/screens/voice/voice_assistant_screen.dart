import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/localization/app_localizations_provider.dart';
import '../../../core/services/voice/voice_service.dart';
import '../../common_widgets/app_top_bar.dart';

/// Dedicated Voice Assistant Screen for farmers
class VoiceAssistantScreen extends ConsumerStatefulWidget {
  const VoiceAssistantScreen({super.key});

  @override
  ConsumerState<VoiceAssistantScreen> createState() =>
      _VoiceAssistantScreenState();
}

class _VoiceAssistantScreenState extends ConsumerState<VoiceAssistantScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleListening() {
    final voiceNotifier = ref.read(voiceServiceProvider.notifier);
    final voiceState = ref.read(voiceServiceProvider);
    final currentLang = ref.read(localeProvider).languageCode;

    if (voiceState.state == VoiceState.listening) {
      voiceNotifier.stopListening();
    } else {
      voiceNotifier.startListening(
        onResult: (text) {
          // Show result and speak back a confirmation
          if (text.isNotEmpty) {
            voiceNotifier.speak(
              'I heard: $text. You can ask about government schemes, eligibility, or document requirements.',
              languageCode: currentLang,
            );
          }
        },
        languageCode: currentLang,
      );
    }
  }

  void _stopAll() {
    ref.read(voiceServiceProvider.notifier).stopListening();
    ref.read(voiceServiceProvider.notifier).stopSpeech();
  }

  @override
  Widget build(BuildContext context) {
    final voiceState = ref.watch(voiceServiceProvider);
    final theme = Theme.of(context);
    final isListening = voiceState.state == VoiceState.listening;
    final isSpeaking = voiceState.state == VoiceState.speaking;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppTopBar(title: 'Voice Assistant'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status text
              Text(
                isListening
                    ? 'Listening...'
                    : isSpeaking
                        ? 'Speaking...'
                        : voiceState.state == VoiceState.error
                            ? voiceState.errorMessage ?? 'Error occurred'
                            : 'Tap the microphone to speak',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: isListening
                      ? Colors.red
                      : isSpeaking
                          ? Colors.green
                          : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Pulse animation mic button
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isListening || isSpeaking
                        ? _pulseAnimation.value
                        : 1.0,
                    child: child,
                  );
                },
                child: GestureDetector(
                  onTap: _toggleListening,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isListening
                            ? [Colors.red.shade400, Colors.red.shade700]
                            : isSpeaking
                                ? [Colors.green.shade400, Colors.green.shade700]
                                : [AppColors.primary, AppColors.primaryDark],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isListening
                                  ? Colors.red
                                  : isSpeaking
                                      ? Colors.green
                                      : AppColors.primary)
                              .withOpacity(0.4),
                          blurRadius: 24,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      isListening
                          ? Icons.mic_rounded
                          : isSpeaking
                              ? Icons.volume_up_rounded
                              : Icons.mic_none_rounded,
                      color: Colors.white,
                      size: 52,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Recognized text
              if (voiceState.recognizedText.isNotEmpty)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                        color: theme.colorScheme.primary.withOpacity(0.3)),
                  ),
                  child: Text(
                    '"${voiceState.recognizedText}"',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 24),

              // Controls
              if (isListening || isSpeaking)
                OutlinedButton.icon(
                  onPressed: _stopAll,
                  icon: const Icon(Icons.stop_rounded),
                  label: const Text('Stop'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 40),

              // Quick voice commands
              Text(
                'Try saying:',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  'PM-KISAN eligibility',
                  'Crop insurance deadline',
                  'KCC loan for farmers',
                  'Drip irrigation subsidy',
                ].map((hint) => Chip(
                      label: Text(hint,
                          style: const TextStyle(fontSize: 12)),
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                    )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
