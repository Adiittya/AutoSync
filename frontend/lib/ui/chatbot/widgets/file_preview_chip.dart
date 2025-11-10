import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../controllers/chat_controller.dart';
import '../../../constants/app_theme.dart';

class FilePreviewChip extends GetView<ChatController> {
  const FilePreviewChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final fileName = controller.selectedFileName.value;
      if (fileName.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.fileChip,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(
              FontAwesomeIcons.file,
              size: 12,
              color: Colors.black54,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                fileName.length > 25
                    ? '${fileName.substring(0, 25)}...'
                    : fileName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: controller.clearFile,
              child: const Icon(
                Icons.close_rounded,
                size: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      );
    });
  }
}
