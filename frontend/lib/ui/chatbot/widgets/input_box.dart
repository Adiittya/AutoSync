import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../controllers/chat_controller.dart';
import '../../../constants/app_theme.dart';
import 'file_preview_chip.dart';

class InputBox extends GetView<ChatController> {
  const InputBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: AppTheme.inputDecoration,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FilePreviewChip(),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: TextEditingController(
                      text: controller.textController.value,
                    )..selection = TextSelection.collapsed(
                        offset: controller.textController.value.length),
                    onChanged: (val) =>
                        controller.textController.value = val,
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
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: controller.pickFile,
                      icon: const FaIcon(FontAwesomeIcons.paperclip,
                          size: 15, color: Colors.black54),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                      splashRadius: 20,
                    ),
                    const SizedBox(width: 5),
                    IconButton(
                      onPressed: () =>
                          controller.sendMessage(controller.textController.value),
                      icon: const FaIcon(FontAwesomeIcons.solidPaperPlane,
                          size: 15, color: Colors.black54),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
