import 'dart:convert';
import 'package:http/http.dart' as http;

class AIRemoteDatasource {
  final String baseUrl;
  AIRemoteDatasource({ required this.baseUrl });
  Future<List<Map<String, dynamic>>> generateWorkout({
    required String level
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/generated-workout'),
      headers: {
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'level': level})
    );

    if (response.statusCode != 200){
      throw Exception('Failed to generate workout.');
    }

    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['workout'] as List);
  }
}