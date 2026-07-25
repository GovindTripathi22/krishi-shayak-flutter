import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../logger/app_logger.dart';

enum VoiceState { idle, listening, speaking, paused }

final voiceStateProvider = StateNotifierProvider<VoiceNotifier, VoiceState>((ref) {
  return VoiceNotifier();
});

class VoiceNotifier extends StateNotifier<VoiceState> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  VoiceNotifier() : super(VoiceState.idle) {
    _initTts();
  }

  void _initTts() async {
    try {
      await _tts.setLanguage('en-IN');
      await _tts.setPitch(1.0);
      await _tts.setSpeechRate(0.85);
      _tts.setCompletionHandler(() => state = VoiceState.idle);
    } catch (e, stack) {
      AppLogger.error('VoiceNotifier: TTS init error', e, stack);
    }
  }

  Future<void> startListening() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      AppLogger.error('VoiceNotifier: Microphone permission denied', null, null);
      return;
    }

    try {
      final available = await _speech.initialize();
      if (available) {
        state = VoiceState.listening;
        AppLogger.info('VoiceNotifier: Speech-to-Text listening started');
      }
    } catch (e, stack) {
      AppLogger.error('VoiceNotifier: Speech recognition error', e, stack);
      state = VoiceState.listening;
    }
  }

  void stopListening() {
    _speech.stop();
    state = VoiceState.idle;
  }

  Future<void> speak(String text) async {
    AppLogger.info('VoiceNotifier: Speaking text aloud via TTS');
    state = VoiceState.speaking;
    await _tts.speak(text);
  }

  void pauseSpeech() {
    _tts.pause();
    state = VoiceState.paused;
  }

  void stopSpeech() {
    _tts.stop();
    state = VoiceState.idle;
  }
}
