import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/quiz_model.dart';

class TriviaService {
  // api url - where to get data from
  static const _baseUrl = 'https://quizapi.io/api/v1/questions';

  // use question object to convert api response to useable object
  static Future<List<Question>> fetchQuestions({
    required String apiKey,
    int limit = 5,
    int offset = 0,
    String category = 'Programming',
    String difficulty = 'EASY',
    String type = 'MULTIPLE_CHOICE',
    }) async {
        if (apiKey.trim().isEmpty) {  // if no api key, can't do call
            throw Exception('Missing API key');
        }

    // combine parameters to base url to make api call 
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'limit': '$limit',
      'offset': '$offset',
      'category': category,
      'difficulty': difficulty,
      'type': type,
      'random': 'true',
    });

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $apiKey'},
    ).timeout(const Duration(seconds: 10));

    // handle errors
    if (response.statusCode != 200) {
      throw Exception('HTTP error: ${response.statusCode}');
    }
    
    //  convert json response to object model
    final body = json.decode(response.body) as Map<String, dynamic>;
    if (body['success'] != true) {
      throw Exception('API returned success=false');
    }

    final data = body['data'] as List? ?? [];
    return data
        .map((item) => Question.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}