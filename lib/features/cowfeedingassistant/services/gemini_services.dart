// GeminiService.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiService {

  final String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  // Store API key in environment variables or secure storage
  // To use this:
  // 1. Add flutter_dotenv package to pubspec.yaml
  // 2. Create a .env file in project root with: GEMINI_API_KEY=your_key_here
  // 3. Load the .env file in main.dart: await dotenv.load(fileName: ".env");
  final String apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
      // defaultValue: ''); // Don't hardcode the actual key

  Future<String> generateCowFeedingPlan({
    required String productionStage,
    required String weight,
    required String age,
    required String breed,
    required String purpose,
    required String healthConditions,
  }) async {
    try {
      final prompt = '''
Generate a detailed feeding plan for a cow with the following details:
- Production Stage: $productionStage
- Weight: $weight kg
- Age: $age
- Breed: $breed
- Purpose: $purpose
- Health Conditions: $healthConditions

Please provide a comprehensive feeding plan including:
1. Daily nutrient requirements (protein, energy, minerals)
2. Recommended feed types and quantities
3. Feeding schedule
4. Special considerations based on the production stage
5. Supplements needed considering the health conditions
6. Water requirements

Format the response in markdown.
''';

      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] ?? 'No feeding plan generated.';
      } else {
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Error generating feeding plan: $e';
    }
  }

  Future<String> getChatResponse(String message, List<String> previousMessages) async {
    try {
      // Extract just the message content from previous messages
      List<String> contextMessages = previousMessages.map((msg) {
        // Remove the "You: " or "Assistant: " prefix
        if (msg.startsWith("You: ")) {
          return "User: " + msg.substring(5);
        } else if (msg.startsWith("Assistant: ")) {
          return "Assistant: " + msg.substring(11);
        }
        return msg;
      }).toList();

      // Combine into a single string for context
      String context = contextMessages.join("\n");

      final prompt = '''
$context

User: $message

You are a specialized agricultural assistant focusing on cow feeding and management. 
Provide helpful, accurate, and detailed answers to the user's questions about cow nutrition, 
care, feeding plans, health management, and related topics. 

If the user asks about something unrelated to cows, livestock, agriculture, or farm management, politely decline to answer and explain that you're specialized in cow nutrition and care. Do not provide information on unrelated topics, even if requested to do so. Simply respond with "I'm specialized in cow nutrition and management. I can't provide information on that topic, but I'd be happy to answer questions about cow feeding, health, or general livestock management."
back to your area of expertise.Answer with emojis
''';

      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'] ?? 'No response generated.';
      } else {
        return 'Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      return 'Error generating response: $e';
    }
  }
}
