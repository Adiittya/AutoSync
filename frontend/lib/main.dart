import 'package:flutter/material.dart';
import 'package:frontend/bindings/chat_binding.dart';
import 'package:frontend/ui/chatbot/chat_page.dart';
import 'package:frontend/ui/chatbot/widgets/global_action_card.dart';
import 'package:frontend/ui/home/home_page.dart';
import 'package:frontend/ui/root.dart';
import 'package:get/get.dart';

void main() {
  runApp(const AutoSyncApp());
}

class AutoSyncApp extends StatelessWidget {
  const AutoSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'AutoSync',
      debugShowCheckedModeBanner: false,
      initialBinding: ChatBinding(),
      home: const RootPage(),
    );
  }
}
