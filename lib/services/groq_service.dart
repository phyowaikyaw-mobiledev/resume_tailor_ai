import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {
  final String apiKey = dotenv.env['GROQ_API_KEY'] ?? '';

  Future<String> optimizeResume(String resume, String job) async {
    if (apiKey.isEmpty) {
      throw Exception('GROQ_API_KEY not found in .env file');
    }

    final response = await http.post(
      Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer ' + apiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'llama-3.3-70b-versatile',
        'messages': [
          {
            'role': 'system',
            'content': 'You are a professional resume optimization assistant. Make the resume ATS-friendly by matching keywords from the job description, improving clarity, and maintaining a professional tone. Return the full optimized resume text only.',
          },
          {
            'role': 'user',
            'content': 'Resume:\n' + resume + '\n\nJob Description:\n' + job + '\n\nOptimize this resume for ATS and keyword matching. Return only the optimized resume.',
          },
        ],
        'temperature': 0.7,
        'max_tokens': 2048,
      }),
    );

    print('Status: ' + response.statusCode.toString());

    if (response.statusCode != 200) {
      print('Error: ' + response.body);
      throw Exception('API error ' + response.statusCode.toString() + ': ' + response.body);
    }

    final data = jsonDecode(response.body);
    return data['choices'][0]['message']['content'] as String;
  }
}