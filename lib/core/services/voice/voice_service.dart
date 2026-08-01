import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';

import '../../logger/app_logger.dart';

enum VoiceState { idle, listening, speaking, paused, error }

/// Full production Voice State Model
class VoiceModel {
  final VoiceState state;
  final String recognizedText;
  final bool isAvailable;
  final String? errorMessage;

  const VoiceModel({
    this.state = VoiceState.idle,
    this.recognizedText = '',
    this.isAvailable = false,
    this.errorMessage,
  });

  VoiceModel copyWith({
    VoiceState? state,
    String? recognizedText,
    bool? isAvailable,
    String? errorMessage,
  }) =>
      VoiceModel(
        state: state ?? this.state,
        recognizedText: recognizedText ?? this.recognizedText,
        isAvailable: isAvailable ?? this.isAvailable,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}

final voiceServiceProvider =
    StateNotifierProvider<VoiceService, VoiceModel>((ref) => VoiceService());

/// Production Voice Service — Speech-to-Text + Text-to-Speech with language support
class VoiceService extends StateNotifier<VoiceModel> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  /// Language codes mapped for TTS & STT
  static const Map<String, String> _ttsLanguageMap = {
    'en': 'en-IN',
    'hi': 'hi-IN',
    'mr': 'mr-IN',
    'gu': 'gu-IN',
    'ta': 'ta-IN',
    'te': 'te-IN',
    'kn': 'kn-IN',
  };

  static const Map<String, String> _sttLocaleMap = {
    'en': 'en_IN',
    'hi': 'hi_IN',
    'mr': 'mr_IN',
    'gu': 'gu_IN',
    'ta': 'ta_IN',
    'te': 'te_IN',
    'kn': 'kn_IN',
  };

  VoiceService() : super(const VoiceModel()) {
    _init();
  }

  Future<void> _init() async {
    try {
      await _tts.setSharedInstance(true);
      await _tts.setPitch(1.0);
      await _tts.setSpeechRate(0.85);
      await _tts.setVolume(1.0);

      final savedLang = await _getSavedLanguage();
      await _applyTtsLanguage(savedLang);

      _tts.setCompletionHandler(() {
        if (mounted) state = state.copyWith(state: VoiceState.idle);
      });
      _tts.setErrorHandler((msg) {
        AppLogger.error('VoiceService TTS error: $msg', null, null);
        if (mounted) state = state.copyWith(state: VoiceState.idle);
      });

      final available = await _speech.initialize(
        onError: (e) {
          AppLogger.error('VoiceService STT error: ${e.errorMsg}', null, null);
          if (mounted) {
            state = state.copyWith(
              state: VoiceState.error,
              errorMessage: e.errorMsg,
            );
          }
        },
        onStatus: (status) {
          AppLogger.info('VoiceService STT status: $status');
          if (status == 'done' || status == 'notListening') {
            if (mounted) state = state.copyWith(state: VoiceState.idle);
          }
        },
      );

      if (mounted) {
        state = state.copyWith(isAvailable: available);
        AppLogger.info('VoiceService initialized. STT available: $available');
      }
    } catch (e, stack) {
      AppLogger.error('VoiceService init error', e, stack);
    }
  }

  Future<void> _applyTtsLanguage(String langCode) async {
    final ttsLang = _ttsLanguageMap[langCode] ?? 'en-IN';
    try {
      await _tts.setLanguage(ttsLang);
      AppLogger.info('VoiceService: TTS language set to $ttsLang');
    } catch (e) {
      await _tts.setLanguage('en-IN');
    }
  }

  Future<String> _getSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('preferred_language') ?? 'en';
  }

  /// Update TTS language when user switches language
  Future<void> updateLanguage(String langCode) async {
    await _applyTtsLanguage(langCode);
  }

  /// Start listening via microphone for Speech-to-Text
  Future<void> startListening({
    required void Function(String text) onResult,
    String? languageCode,
  }) async {
    // Request microphone permission
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      AppLogger.error('VoiceService: Microphone permission denied', null, null);
      if (mounted) {
        state = state.copyWith(
          state: VoiceState.error,
          errorMessage: 'Microphone permission denied. Please enable in settings.',
        );
      }
      return;
    }

    if (!state.isAvailable) {
      // Retry initialization
      await _init();
      if (!state.isAvailable) {
        if (mounted) {
          state = state.copyWith(
            state: VoiceState.error,
            errorMessage: 'Speech recognition not available on this device.',
          );
        }
        return;
      }
    }

    try {
      if (mounted) {
        state = state.copyWith(
          state: VoiceState.listening,
          recognizedText: '',
          errorMessage: null,
        );
      }

      final savedLang = languageCode ?? await _getSavedLanguage();
      final sttLocale = _sttLocaleMap[savedLang] ?? 'en_IN';

      await _speech.listen(
        onResult: (result) {
          final text = result.recognizedWords;
          if (mounted) {
            state = state.copyWith(recognizedText: text);
          }
          if (result.finalResult && text.isNotEmpty) {
            onResult(text);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
        localeId: sttLocale,
        cancelOnError: false,
        partialResults: true,
      );
    } catch (e, stack) {
      AppLogger.error('VoiceService: startListening error', e, stack);
      if (mounted) {
        state = state.copyWith(
          state: VoiceState.error,
          errorMessage: 'Failed to start listening. Please try again.',
        );
      }
    }
  }

  /// Stop speech recognition
  Future<void> stopListening() async {
    try {
      await _speech.stop();
      if (mounted) state = state.copyWith(state: VoiceState.idle);
    } catch (e) {
      AppLogger.error('VoiceService: stopListening error', e, null);
    }
  }

  /// Cancel speech recognition
  Future<void> cancelListening() async {
    try {
      await _speech.cancel();
      if (mounted) {
        state = state.copyWith(state: VoiceState.idle, recognizedText: '');
      }
    } catch (e) {
      AppLogger.error('VoiceService: cancelListening error', e, null);
    }
  }

  /// Speak text aloud via Text-to-Speech
  Future<void> speak(String text, {String? languageCode}) async {
    if (text.isEmpty) return;

    try {
      if (languageCode != null) {
        await _applyTtsLanguage(languageCode);
      }

      if (mounted) state = state.copyWith(state: VoiceState.speaking);
      AppLogger.info('VoiceService: Speaking ${text.length} chars');
      await _tts.speak(text);
    } catch (e, stack) {
      AppLogger.error('VoiceService: speak error', e, stack);
      if (mounted) state = state.copyWith(state: VoiceState.idle);
    }
  }

  /// Pause TTS
  Future<void> pauseSpeech() async {
    try {
      await _tts.pause();
      if (mounted) state = state.copyWith(state: VoiceState.paused);
    } catch (e) {
      AppLogger.error('VoiceService: pauseSpeech error', e, null);
    }
  }

  /// Stop TTS
  Future<void> stopSpeech() async {
    try {
      await _tts.stop();
      if (mounted) state = state.copyWith(state: VoiceState.idle);
    } catch (e) {
      AppLogger.error('VoiceService: stopSpeech error', e, null);
    }
  }

  /// Convenience: Speak AI chatbot response
  Future<void> speakAiResponse(String response, {String? languageCode}) async {
    final cleanText = response
        .replaceAll(RegExp(r'\*+'), '')
        .replaceAll(RegExp(r'#+'), '')
        .replaceAll(RegExp(r'\n+'), '. ')
        .trim();
    await speak(cleanText, languageCode: languageCode);
  }

  /// Convenience: Speak PDF summary
  Future<void> speakPdfSummary(String summary, {String? languageCode}) async {
    await speakAiResponse(summary, languageCode: languageCode);
  }

  bool get isListening => state.state == VoiceState.listening;
  bool get isSpeaking => state.state == VoiceState.speaking;

  @override
  void dispose() {
    _speech.cancel();
    _tts.stop();
    super.dispose();
  }
}
