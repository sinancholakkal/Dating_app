import 'dart:developer';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;
  
  // OPTIMIZATION: Initialize the model once
  late final GenerativeModel _generativeModel;

  @override
  void initState() {
    super.initState();
    // Initialize the model when the widget is first created
    final vertexAI = FirebaseVertexAI.instanceFor(location: 'us-central1');
    _generativeModel = vertexAI.generativeModel(
      model: 'gemini-2.5-pro',
    );
  }

  // Separate function to handle Gemini AI content moderation
  Future<String> checkContentModeration(String text) async {
    try {
      // Get the stream of responses
      final stream = _generativeModel.generateContentStream([
        Content.text("Does the following image Url contain harmful, offensive, sex photo , nude photo,boobs photo, or inappropriate content? Answer with only a single word: YES or NO.\n\nImage: \"$text\""),

      ]);

      String response = '';
      // Listen to the stream and collect all chunks
      await for (final chunk in stream) {
        response += chunk.text ?? '';
      }
      
      return response;
    } catch (e) {
      log('Error with Gemini: $e');
      return 'Error: ${e.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gemini Prompt')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Enter your prompt',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendPrompt, // Call the new function
                child: const Text("Submit"),
              ),
              const SizedBox(height: 30),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      _response,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Updated method to use the separate function
  Future<void> _sendPrompt() async {
    if (controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _response = ''; // Clear previous response
    });

    // Use the separate function with the text parameter
    final result = await checkContentModeration(controller.text);
    
    setState(() {
      _response = result;
      _isLoading = false;
    });
  }
}