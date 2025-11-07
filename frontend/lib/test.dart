import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class StreamPage extends StatefulWidget {
  const StreamPage({super.key});

  @override
  State<StreamPage> createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  String fullMessage = ""; // single message to hold all chunks
  final TextEditingController textController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void startStreaming() async {
    final request = http.Request(
      'GET',
      Uri.parse('https://pleasant-nearby-hermit.ngrok-free.app/stream'),
    );

    final response = await request.send();

    response.stream
        .transform(utf8.decoder)
        .transform(const LineSplitter())
        .listen((line) {
      line = line.trim();
      if (line.isEmpty) return;

      try {
        final data = jsonDecode(line);

        String newText = "";

        // Handle initial JSON
        if (data.containsKey("initial_data")) {
          final jsonData = data["initial_data"];
          newText = "📦 Initial Data: ${jsonEncode(jsonData)}";
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
          setState(() {
            fullMessage += newText; // append to the single message
          });

          // Auto-scroll to bottom
          scrollController.animateTo(
            scrollController.position.maxScrollExtent + 50,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
          );
        }
      } catch (e) {
        setState(() {
          fullMessage += "Raw chunk: $line";
        });
      }
    });
  }

  @override
  void dispose() {
    textController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Streaming Example')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(fullMessage),
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: TextFormField(
              controller: textController,
              onChanged: (val) {},
              maxLines: null,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              decoration: const InputDecoration(
                hintText: "Start a new conversation",
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
