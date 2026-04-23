import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AiService {
  // TODO: Replace with your actual Gemini API Key or load from environment
  static const String _apiKey = 'API_KEY_HERE';

  final GenerativeModel _model;

  AiService()
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: _apiKey,
        );

  Future<Map<String, dynamic>> analyzeFoodImage(Uint8List imageBytes) async {
    final prompt = 'Analyze this food image and provide the name of the food, '
        'estimated calories, and protein in grams. '
        'Be as accurate as possible for the portion size shown. '
        'Format the response as a valid JSON object with keys: "name", "calories", "protein".';

    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart('image/jpeg', imageBytes),
      ])
    ];

    try {
      final response = await _model.generateContent(
        content,
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json',
        ),
      );

      if (response.text == null) {
        throw Exception('AI response was empty');
      }

      final Map<String, dynamic> data = jsonDecode(response.text!);
      return data;
    } catch (e) {
      debugPrint('Error analyzing image: $e');
      rethrow;
    }
  }
}
