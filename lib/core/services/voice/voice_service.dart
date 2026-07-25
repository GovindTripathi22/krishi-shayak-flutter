import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../logger/app_logger.dart';

enum VoiceState { idle, listening, speaking, paused }

final voiceStateProvider = StateNotifierProvider<VoiceNotifier, VoiceState>((ref) {
  return VoiceNotifier();
});

class VoiceNotifier extends StateNotifier<VoiceState> {
  VoiceNotifier() : super(VoiceState.idle);

  void startListening() {
    AppLogger.info('VoiceService: Started Speech-to-Text (STT) recording');
    state = VoiceState.listening;
  }

  void stopListening() {
    AppLogger.info('VoiceService: Stopped Speech-to-Text (STT)');
    state = VoiceState.idle;
  }

  void speak(String text) {
    AppLogger.info('VoiceService: Text-to-Speech (TTS) reading aloud: "$text"');
    state = VoiceState.speaking;
  }

  void pauseSpeech() {
    state = VoiceState.paused;
  }

  void stopSpeech() {
    state = VoiceState.idle;
  }
}
