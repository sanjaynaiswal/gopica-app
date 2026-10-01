import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider((ref) => ApiService());

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://heysamay.in', // Replace with actual backend
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<String> processGopicaCommand(String input) async {
    try {
      // Simulating network delay for now since backend isn't fully defined
      await Future.delayed(const Duration(seconds: 2));
      
      // Real API Call would look like this:
      // final response = await _dio.post('/api/gopica/process', data: {'command': input});
      // return response.data['result'];
      
      return "Processed result for: $input\n\nThis is a mock response from the Gopica API.";
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to process request. Please try again.');
    }
  }
}