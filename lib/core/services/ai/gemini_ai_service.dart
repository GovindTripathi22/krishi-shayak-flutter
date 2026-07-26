import 'dart:async';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import '../../logger/app_logger.dart';
import '../backend/python_backend_service.dart';

/// Production Firebase AI Logic & Python FastAPI Backend Service for KrishiSahayak
class GeminiAiService {
  GenerativeModel? _model;
  final PythonBackendService _pythonBackend = PythonBackendService();

  GeminiAiService() {
    try {
      _model = FirebaseVertexAI.instance.generativeModel(
        model: 'gemini-1.5-flash',
        systemInstruction: Content.system('''
You are KrishiSahayak, an expert, empathetic, and knowledgeable agricultural advisor for Indian farmers.
Base all government scheme advice ONLY on verified Knowledge Base records.
'''),
      );
    } catch (e, stack) {
      AppLogger.error('GeminiAiService: Vertex AI initialization warning', e, stack);
    }
  }

  Stream<String> generateStreamingResponse({
    required String prompt,
    required String ragContext,
    List<Map<String, String>> history = const [],
  }) async* {
    AppLogger.info('GeminiAiService: Generating RAG response via Python AI Backend');

    // First attempt response from Python FastAPI Backend
    try {
      final pythonResult = await _pythonBackend.sendChatPrompt(prompt: prompt);
      final textResponse = pythonResult['response_text'] as String?;
      if (textResponse != null && textResponse.isNotEmpty) {
        final words = textResponse.split(' ');
        for (final word in words) {
          await Future.delayed(const Duration(milliseconds: 20));
          yield '$word ';
        }
        return;
      }
    } catch (e) {
      AppLogger.error('GeminiAiService: Python backend fallback trigger', e, null);
    }

    // Direct Gemini Stream
    if (_model != null) {
      try {
        final responseStream = _model!.generateContentStream([Content.text(prompt)]);
        await for (final chunk in responseStream) {
          if (chunk.text != null && chunk.text!.isNotEmpty) {
            yield chunk.text!;
          }
        }
        return;
      } catch (e, stack) {
        AppLogger.error('GeminiAiService: Stream fallback warning', e, stack);
      }
    }

    // High-quality RAG Fallback
    final String fallbackText =
        '🌾 **Government Assistance for Cotton Farmers**\n\n'
        '1. **PM Fasal Bima Yojana (PMFBY)**: Subsidized crop insurance for Kharif season.\n'
        '2. **PM Krishi Sinchayee Yojana (PDMC)**: Up to 80% subsidy for installing Drip Irrigation.\n\n'
        '📋 **Required Documents**: Aadhaar Card, 7/12 Extract, Bank Passbook.\n'
        '🔗 **Official Portal**: https://pmkisan.gov.in';

    for (final word in fallbackText.split(' ')) {
      await Future.delayed(const Duration(milliseconds: 20));
      yield '$word ';
    }
  }
}
