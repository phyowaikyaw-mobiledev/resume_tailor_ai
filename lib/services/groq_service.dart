import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqService {
  static const _timeout = Duration(seconds: 60);

  final String apiKey = dotenv.env['GROQ_API_KEY'] ?? '';

  Future<String> optimizeResume(String resume, String job) async {
    if (apiKey.isEmpty) {
      throw Exception('GROQ_API_KEY not found in .env file');
    }

    const systemPrompt = '''
You are a professional resume optimization assistant.
Rules:
- Make the resume ATS-friendly by matching keywords from the job description.
- Preserve these sections if present: CONTACT, SUMMARY, EXPERIENCE, SKILLS, EDUCATION, CERTIFICATIONS, PROJECTS.
- Use ALL CAPS section headers on their own line.
- Do not invent jobs, skills, or credentials — only reword and reorder existing content.
- Improve clarity and professional tone.
- Return the full optimized resume text only, with no commentary.''';

    final response = await http
        .post(
          Uri.parse('https://api.groq.com/openai/v1/chat/completions'),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'model': 'llama-3.3-70b-versatile',
            'messages': [
              {'role': 'system', 'content': systemPrompt},
              {
                'role': 'user',
                'content':
                    'Resume:\n$resume\n\nJob Description:\n$job\n\nOptimize this resume for ATS and keyword matching. Return only the optimized resume.',
              },
            ],
            'temperature': 0.7,
            'max_tokens': 4096,
          }),
        )
        .timeout(_timeout);

    if (response.statusCode != 200) {
      throw Exception(
        'API error ${response.statusCode}: ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    if (choices == null || choices.isEmpty) {
      throw Exception('No response from AI. Please try again.');
    }

    final message = choices[0]['message'] as Map<String, dynamic>?;
    final content = message?['content'] as String?;
    if (content == null || content.trim().isEmpty) {
      throw Exception('Empty response from AI. Please try again.');
    }

    return content.trim();
  }
}
