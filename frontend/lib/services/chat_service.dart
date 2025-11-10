import 'dart:async';

class ChatService {
  Stream<String> streamResponse(String prompt) async* {
    final responses = {
      "hi": "Hello! How can I assist you today?",
      "how are you": "I’m doing great, thanks for asking! 😊",
      "default": "That’s interesting — tell me more about it!"
    };

    final response = responses[prompt.toLowerCase()] ?? responses["default"]!;
    for (int i = 0; i < response.length; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      yield response.substring(0, i + 1);
    }
  }
}
