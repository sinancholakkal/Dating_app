import 'dart:developer';
import 'package:firebase_vertexai/firebase_vertexai.dart';

class ModerationServices {
  late final GenerativeModel _generativeModel;

  ModerationServices() {
    final vertexAI = FirebaseVertexAI.instanceFor(location: 'us-central1');
    _generativeModel = vertexAI.generativeModel(
      model: 'gemini-2.5-pro',
    );
  }

  // Separate function to handle Gemini AI content moderation
  Future<String> checkContentModeration({String? text,String? imageUrl}) async {
    try {

      final stream = _generativeModel.generateContentStream([
       (text!=null)? Content.text("Does the following message contain harmful, offensive, or inappropriate content? Answer with only a single word: YES or NO.\n\nMessage: \"$text\""):
       Content.text("Does the following image contain harmful, offensive, sexually explicit, or inappropriate content? Answer with only a single word: YES or NO.\n\nImage: \"$imageUrl\""),
      ]);

      String response = '';
      await for (final chunk in stream) {
        response += chunk.text ?? '';
      }
      
      return response;
    } catch (e) {
      log('Error with Gemini: $e');
      return 'Error: ${e.toString()}';
    }
  }
}