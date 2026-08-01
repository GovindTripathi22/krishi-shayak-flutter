import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../logger/app_logger.dart';
import '../storage/secure_storage_service.dart';

/// Production Reusable REST API Client with JWT Injection and Error Handling
class ApiClient {
  final String baseUrl;

  ApiClient({this.baseUrl = 'http://localhost:5001/api/v1'});

  Future<Map<String, String>> _getHeaders({bool requireAuth = true}) async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth) {
      final token = await SecureStorageService.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<dynamic> get(String endpoint, {bool requireAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    AppLogger.info('ApiClient: GET $url');

    try {
      final headers = await _getHeaders(requireAuth: requireAuth);
      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 15));
      return _processResponse(response);
    } catch (e, stack) {
      AppLogger.error('ApiClient GET Error on $endpoint', e, stack);
      rethrow;
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body, bool requireAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    AppLogger.info('ApiClient: POST $url');

    try {
      final headers = await _getHeaders(requireAuth: requireAuth);
      final response = await http.post(
        url,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 15));
      return _processResponse(response);
    } catch (e, stack) {
      AppLogger.error('ApiClient POST Error on $endpoint', e, stack);
      rethrow;
    }
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body, bool requireAuth = true}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    AppLogger.info('ApiClient: PUT $url');

    try {
      final headers = await _getHeaders(requireAuth: requireAuth);
      final response = await http.put(
        url,
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ).timeout(const Duration(seconds: 15));
      return _processResponse(response);
    } catch (e, stack) {
      AppLogger.error('ApiClient PUT Error on $endpoint', e, stack);
      rethrow;
    }
  }

  dynamic _processResponse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      final message = body['message'] ?? 'An error occurred during request.';
      throw Exception(message);
    }
  }
}
