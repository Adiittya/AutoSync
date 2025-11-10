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

  final actionCardData = {}.obs;

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

    _streamResponse(text);
    // _simulateResponse(text);
  }

  void _streamResponse(String prompt) async {
    await _streamSub?.cancel();

    if (messages.isEmpty || messages.last.isUser) {
      messages.add(Message(text: "", isUser: false));
    }

    final lastIndex = messages.length - 1;
    final encodedPrompt = Uri.encodeComponent(prompt);

    final request = http.Request(
      'GET',
      Uri.parse(
        'https://pleasant-nearby-hermit.ngrok-free.app/stream?user_query=$encodedPrompt',
      ),
    );

    final response = await request.send();

    String buffer = ""; // holds partial JSON

    _streamSub = response.stream
        .transform(utf8.decoder)
        .listen(
          (chunk) {
            buffer += chunk;

            // split by }{ boundaries safely
            final parts = buffer.split(RegExp(r'(?<=\})\s*(?=\{)'));

            // process all complete parts except possibly last incomplete one
            for (int i = 0; i < parts.length; i++) {
              final part = parts[i].trim();
              if (part.isEmpty) continue;

              // check if JSON seems complete (balanced braces)
              final openCount = part.split('{').length - 1;
              final closeCount = part.split('}').length - 1;
              final isComplete = openCount == closeCount;

              if (!isComplete && i == parts.length - 1) {
                // keep it in buffer for next chunk
                buffer = part;
                return;
              }

              try {
                final data = jsonDecode(part);

                // mark active agent
                if (data.containsKey("agent_name")) {
                  agentActive.value = true;
                  currentAgent.value = data["agent_name"];
                }

                String newText = "";

                if (data.containsKey("initial_data")) {
                  newText = jsonEncode(data["initial_data"]);
                } else if (data["tool_output"] != null) {
                  actionCardData.value = data["tool_output"][0];
                  print("===================TOOL OUTPUT ===================");
                  print(data["tool_output"]);
                } else if (data.containsKey("ollama_output")) {
                  print("===================OLLAMA OUTPUT ===================");

                  final chunkData = data["ollama_output"];
                  print(chunkData);
                  if (chunkData is Map && chunkData.containsKey("message")) {
                    newText = chunkData["message"]["content"] ?? "";
                  } else if (chunkData is String) {
                    newText = chunkData;
                  }
                }

                if (newText.isNotEmpty) {
                  messages[lastIndex] = Message(
                    text: messages[lastIndex].text + newText,
                    isUser: false,
                    type: MessageType.text,
                  );
                  messages.refresh();
                }

                if (currentAgent == "inventory_agent_function") {
                  messages.add(
                    Message(
                      text: "",
                      isUser: false,
                      type: MessageType.inventory,
                      metadata: {
                        "center_name": "Volks Auto Service Mumbai",
                        "address": {
                          "street": "Plot 12, Andheri Industrial Estate",
                          "city": "Mumbai",
                          "state": "Maharashtra",
                          "pincode": "400053",
                        },
                        "contact": "+91-9876543210",
                        "location": {
                          "type": "Point",
                          "coordinates": [72.868, 19.119],
                        },
                        "parts_available": [
                          {
                            "part_name": "Brake Pad",
                            "category": "Braking System",
                            "quantity": 20,
                            "price": 1800,
                          },
                          {
                            "part_name": "Engine Oil",
                            "category": "Lubricants",
                            "quantity": 50,
                            "price": 700,
                          },
                        ],
                      },
                    ),
                  );
                }
                if (prompt.contains("my service payments")) {
                  messages.add(
                    Message(
                      text: "",
                      isUser: false,
                      type: MessageType.payment,
                      metadata: {},
                    ),
                  );
                }

                // clear buffer only when processed successfully
                if (i == parts.length - 1) buffer = "";
              } catch (e) {
                // if last part incomplete, keep in buffer
                if (i == parts.length - 1) {
                  buffer = part;
                } else {
                  // show only once for debugging
                  debugPrint("⚠️ Stream parse error: $e\nPart: $part");
                }
              }
            }
          },
          onError: (error) {
            isLoading.value = false;
            messages[lastIndex] = Message(
              text: messages[lastIndex].text + "\nError: $error",
              isUser: false,
              type: MessageType.text,
            );
            messages.refresh();
          },
          onDone: () {
            // flush any last buffered data
            // if (buffer.isNotEmpty) {
            //   try {
            //     final data = jsonDecode(buffer);
            //     if (data.containsKey("ollama_output")) {
            //       messages[lastIndex] = Message(
            //         text:
            //             messages[lastIndex].text +
            //             (data["ollama_output"].toString()),
            //         isUser: false,
            //         type: MessageType.text,
            //       );
            //       messages.refresh();
            //     }
            //   } catch (_) {}
            // }
          },
        );
  }

  // /// Simulates a chatbot response locally for demo/testing
  // void _simulateResponse(String prompt) async {
  //   isLoading.value = true;
  //   final lastIndex = messages.length - 1;

  //   // final simulatedResponses = [
  //   //   "Sure! Let me check that for you...",
  //   //   "Alright, I found a few options based on your request.",
  //   //   "Here’s what I can do for you 👇",
  //   // ];

  //   // for (final chunk in simulatedResponses) {
  //   //   await Future.delayed(const Duration(milliseconds: 700));
  //   //   messages[lastIndex] = Message(
  //   //     text: messages[lastIndex].text + "\n$chunk",
  //   //     isUser: false,
  //   //   );
  //   //   messages.refresh();
  //   // }

  //   await Future.delayed(const Duration(seconds: 1));
  //   isLoading.value = false;

  //   final lowerPrompt = prompt.toLowerCase();

  //   // --- Inline widget messages ---
  //   messages.add(
  //     Message(
  //       text: "",
  //       isUser: false,
  //       type: MessageType.payment,
  //       metadata: {"center_name": "Volks Auto Service Mumbai"},
  //     ),
  //   );
  //   // if (lowerPrompt.contains("pay")) {
  //   //   messages.add(
  //   //     Message(
  //   //       text: "",
  //   //       isUser: false,
  //   //       type: MessageType.payment,
  //   //       metadata: {
  //   //         "amount": 299.0,
  //   //         "description": "Service Payment for Car Wash",
  //   //       },
  //   //     ),
  //   //   );
  //   // } else if (lowerPrompt.contains("book") ||
  //   //     lowerPrompt.contains("schedule")) {
  //   //   messages.add(
  //   //     Message(
  //   //       text: "",
  //   //       isUser: false,
  //   //       type: MessageType.booking,
  //   //       metadata: {
  //   //         "service": "Car Wash",
  //   //         "date": "2025-11-10",
  //   //         "time": "10:00 AM",
  //   //       },
  //   //     ),
  //   //   );
  //   // } else if (lowerPrompt.contains("location") ||
  //   //     lowerPrompt.contains("where") ||
  //   //     lowerPrompt.contains("nearby")) {
  //   //   messages.add(
  //   //     Message(
  //   //       text: "",
  //   //       isUser: false,
  //   //       type: MessageType.map,
  //   //       metadata: {
  //   //         "title": "Mumbai Service Center",
  //   //         "lat": 19.0760,
  //   //         "lng": 72.8777,
  //   //       },
  //   //     ),
  //   //   );
  //   // } else if (lowerPrompt.contains("feedback") ||
  //   //     lowerPrompt.contains("rate")) {
  //   //   messages.add(
  //   //     Message(
  //   //       text: "",
  //   //       isUser: false,
  //   //       type: MessageType.feedback,
  //   //       metadata: {"question": "Was this service helpful?"},
  //   //     ),
  //   //   );
  //   // } else if (lowerPrompt.contains("track") ||
  //   //     lowerPrompt.contains("delivery")) {
  //   //   messages.add(
  //   //     Message(
  //   //       text: "",
  //   //       isUser: false,
  //   //       type: MessageType.delivery,
  //   //       metadata: {
  //   //         "status": "Out for Delivery",
  //   //         "eta": "25 mins",
  //   //         "trackingUrl": "https://example.com/track123",
  //   //       },
  //   //     ),
  //   //   );
  //   // }

  //   messages.refresh();
  // }

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
