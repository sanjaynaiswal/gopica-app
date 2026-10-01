import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider((ref) => ApiService());

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    // Update to your production API URL
    baseUrl: 'https://heysamay-62a2a.web.app/api_v1/api/gopica',
    connectTimeout: const Duration(seconds: 10),
  ));

  Future<Map<String, dynamic>> sendCommand(String command) async {
    try {
      // Note: Add proper Bearer token authentication here when integrating HeySamay Auth
      final response = await _dio.post('/command', data: {
        'command': command,
        'persona': 'prime'
      });
      return response.data;
    } catch (e) {
      throw Exception('Failed to send command: $e');
    }
  }
}
