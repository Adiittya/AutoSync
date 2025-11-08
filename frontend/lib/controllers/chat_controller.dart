import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:frontend/ui/chatbot/widgets/global_action_card.dart';
import 'package:get/get.dart';
import '../models/message_model.dart';
import '../services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ChatController extends GetxController {
  final messages = <Message>[].obs;
  final isLoading = false.obs;
  final textController = RxString("");
  final chatService = ChatService();
  StreamSubscription<String>? _streamSub;
  final showLottie = true.obs;

  // File picker state
  final selectedFileName = ''.obs;
  final selectedFilePath = ''.obs;

  // Agent state
  final currentAgent = ''.obs;
  final agentActive = false.obs;
  final unreadIndex = 0.obs;

  void markUnread(int index) {
    unreadIndex.value = index;
  }

  /// Picks any file from local system
  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      selectedFileName.value = result.files.single.name;
      selectedFilePath.value = result.files.single.path!;
    }
  }

  /// Clears the selected file (on tap of X button)
  void clearFile() {
    selectedFileName.value = '';
    selectedFilePath.value = '';
  }

  /// Sends text or file-based message
  void sendMessage(String text) {
    if (text.trim().isEmpty && selectedFilePath.isEmpty) return;

    showLottie.value = false;

    // Add user message
    if (text.trim().isNotEmpty) {
      messages.add(Message(text: text.trim(), isUser: true));
    }

    // Activate the default agent (DriveAssist)
    if (!agentActive.value) {
      agentActive.value = true;
      currentAgent.value = 'DriveAssist';
    }

    // Add file message (if exists)
    if (selectedFileName.isNotEmpty) {
      messages.add(
        Message(
          text: selectedFileName.value,
          isUser: true,
          type: MessageType.file,
          metadata: {
            "path": selectedFilePath.value,
            "name": selectedFileName.value,
          },
        ),
      );
      clearFile();
    }

    textController.value = "";

    // Add placeholder assistant response
    messages.add(Message(text: "", isUser: false));
    // _streamResponse(text);
    _simulateResponse(text);
  }

  void _streamResponse(String prompt) async {
    // Cancel any previous stream
    await _streamSub?.cancel();

    // Add placeholder assistant message if not already added
    if (messages.isEmpty || messages.last.isUser) {
      messages.add(Message(text: "", isUser: false));
    }

    final lastIndex = messages.length - 1;

    final request = http.Request(
      'GET',
      Uri.parse('https://pleasant-nearby-hermit.ngrok-free.app/stream'),
    );

    final response = await request.send();

    _streamSub = response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen(
          (line) {
            line = line.trim();
            if (line.isEmpty) return;

            try {
              final data = jsonDecode(line);

              String newText = "";

              // Handle initial JSON
              if (data.containsKey("initial_data")) {
                final jsonData = data["initial_data"];
                newText = "${jsonEncode(jsonData)}";
              }
              // Handle Ollama chunks
              else if (data.containsKey("ollama_chunk")) {
                final chunk = data["ollama_chunk"];
                if (chunk is Map && chunk.containsKey("message")) {
                  newText = chunk["message"]["content"] ?? "";
                } else if (chunk is String) {
                  newText = chunk;
                }
              }

              if (newText.isNotEmpty) {
                // Update the last message progressively
                messages[lastIndex] = Message(
                  text: messages[lastIndex].text + newText,
                  isUser: false,
                  type: MessageType.text,
                );
                messages.refresh();
              }
            } catch (e) {
              // Fallback for raw chunks
              messages[lastIndex] = Message(
                text: messages[lastIndex].text + "Raw chunk: $line",
                isUser: false,
                type: MessageType.text,
              );
              messages.refresh();
            }
          },
          // onDone: () {
          //   isLoading.value = false;
          //   messages.refresh();

          //   // Optional: Add dynamic follow-up widgets
          //   final lastMessageText = messages[lastIndex].text.toLowerCase();
          //   if (lastMessageText.contains("book")) {
          //     messages.add(
          //       Message(
          //         text: "",
          //         isUser: false,
          //         type: MessageType.booking,
          //         metadata: {"service": "Car Wash"},
          //       ),
          //     );
          //   } else if (lastMessageText.contains("rate")) {
          //     messages.add(
          //       Message(text: "", isUser: false, type: MessageType.rating),
          //     );
          //   } else if (lastMessageText.contains("schedule")) {
          //     messages.add(
          //       Message(
          //         text: "",
          //         isUser: false,
          //         type: MessageType.suggestion,
          //         metadata: {
          //           "options": ["Yes", "No", "Remind Me Later"],
          //         },
          //       ),
          //     );
          //   }

          //   messages.refresh();
          // },
          onError: (error) {
            isLoading.value = false;
            messages[lastIndex] = Message(
              text: messages[lastIndex].text + "\nError: $error",
              isUser: false,
              type: MessageType.text,
            );
            messages.refresh();
          },
        );
  }

  /// Simulates a chatbot response locally for demo/testing
  void _simulateResponse(String prompt) async {
    isLoading.value = true;
    final lastIndex = messages.length - 1;

    // final simulatedResponses = [
    //   "Sure! Let me check that for you...",
    //   "Alright, I found a few options based on your request.",
    //   "Here’s what I can do for you 👇",
    // ];

    // for (final chunk in simulatedResponses) {
    //   await Future.delayed(const Duration(milliseconds: 700));
    //   messages[lastIndex] = Message(
    //     text: messages[lastIndex].text + "\n$chunk",
    //     isUser: false,
    //   );
    //   messages.refresh();
    // }

    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;

    final lowerPrompt = prompt.toLowerCase();

    // --- Inline widget messages ---
    messages.add(
      Message(
        text: "",
        isUser: false,
        type: MessageType.payment,
        metadata: {"center_name": "Volks Auto Service Mumbai"},
      ),
    );
    // if (lowerPrompt.contains("pay")) {
    //   messages.add(
    //     Message(
    //       text: "",
    //       isUser: false,
    //       type: MessageType.payment,
    //       metadata: {
    //         "amount": 299.0,
    //         "description": "Service Payment for Car Wash",
    //       },
    //     ),
    //   );
    // } else if (lowerPrompt.contains("book") ||
    //     lowerPrompt.contains("schedule")) {
    //   messages.add(
    //     Message(
    //       text: "",
    //       isUser: false,
    //       type: MessageType.booking,
    //       metadata: {
    //         "service": "Car Wash",
    //         "date": "2025-11-10",
    //         "time": "10:00 AM",
    //       },
    //     ),
    //   );
    // } else if (lowerPrompt.contains("location") ||
    //     lowerPrompt.contains("where") ||
    //     lowerPrompt.contains("nearby")) {
    //   messages.add(
    //     Message(
    //       text: "",
    //       isUser: false,
    //       type: MessageType.map,
    //       metadata: {
    //         "title": "Mumbai Service Center",
    //         "lat": 19.0760,
    //         "lng": 72.8777,
    //       },
    //     ),
    //   );
    // } else if (lowerPrompt.contains("feedback") ||
    //     lowerPrompt.contains("rate")) {
    //   messages.add(
    //     Message(
    //       text: "",
    //       isUser: false,
    //       type: MessageType.feedback,
    //       metadata: {"question": "Was this service helpful?"},
    //     ),
    //   );
    // } else if (lowerPrompt.contains("track") ||
    //     lowerPrompt.contains("delivery")) {
    //   messages.add(
    //     Message(
    //       text: "",
    //       isUser: false,
    //       type: MessageType.delivery,
    //       metadata: {
    //         "status": "Out for Delivery",
    //         "eta": "25 mins",
    //         "trackingUrl": "https://example.com/track123",
    //       },
    //     ),
    //   );
    // }

    messages.refresh();
  }

  /// Triggered when user taps on widget replies
  void addUserReply(String text) {
    messages.add(Message(text: text, isUser: true));
    unreadIndex.value = messages.length - 1;
  }

  @override
  void onClose() {
    _streamSub?.cancel();
    super.onClose();
  }
}
