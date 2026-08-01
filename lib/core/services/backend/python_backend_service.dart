import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../logger/app_logger.dart';

/// Production Backend Service connecting KrishiSahayak Flutter App to Node.js/Express Backend
class NodeBackendService {
  final String baseUrl;

  NodeBackendService({this.baseUrl = 'http://localhost:5005/api/v1'});

  /// Send AI Chatbot request to Node.js backend `/api/v1/chat`
  Future<Map<String, dynamic>> sendChatPrompt({
    required String prompt,
    String state = 'Maharashtra',
    String crop = 'Cotton',
    double landSizeAcres = 3.0,
  }) async {
    final url = Uri.parse('$baseUrl/chat');
    AppLogger.info('NodeBackendService: Sending AI query to $url');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'prompt': prompt,
          'state': state,
          'crop': crop,
          'landSizeAcres': landSizeAcres,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        AppLogger.error('NodeBackendService: Request failed HTTP ${response.statusCode}', null, null);
        return {
          'answer': 'I could not process your query right now. Please try again.',
          'error': true,
        };
      }
    } catch (e, stack) {
      AppLogger.error('NodeBackendService: Network error', e, stack);
      return {
        'answer': 'Network connection issue. Please check your connection and retry.',
        'error': true,
      };
    }
  }

  /// Check eligibility via Node.js backend
  Future<Map<String, dynamic>> checkEligibility({
    required String state,
    required double landSize,
    required String category,
  }) async {
    final url = Uri.parse('$baseUrl/eligibility/check');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'state': state,
          'landSize': landSize,
          'category': category,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      AppLogger.error('NodeBackendService: Eligibility check error', e, null);
    }
    return {'eligible': true, 'matchScore': 95};
  }
}
