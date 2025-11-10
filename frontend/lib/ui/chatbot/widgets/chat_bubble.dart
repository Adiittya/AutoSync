import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/ui/chatbot/widgets/global_action_card.dart';
import 'package:open_filex/open_filex.dart';
import '../../../models/message_model.dart';

class ChatBubble extends StatefulWidget {
  final Message message;
  final Function(String)? onUserAction;
  final bool isFirstInGroup;
  final bool isLastInGroup;

  const ChatBubble({
    super.key,
    required this.message,
    this.onUserAction,
    this.isFirstInGroup = true,
    this.isLastInGroup = true,
  });

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fade = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slide = Tween(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(_fade);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final msg = widget.message;
    final isUser = msg.isUser;
    final radius = 14.0;
    final tail = 6.0;

    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(
        isUser ? radius : (widget.isFirstInGroup ? radius : 4),
      ),
      topRight: Radius.circular(
        isUser ? (widget.isFirstInGroup ? radius : 4) : radius,
      ),
      bottomLeft: Radius.circular(
        isUser ? radius : (widget.isLastInGroup ? tail : radius),
      ),
      bottomRight: Radius.circular(
        isUser ? (widget.isLastInGroup ? tail : radius) : radius,
      ),
    );

    final bubbleColor = isUser ? Colors.blue[50] : Colors.grey[200];

    // ✅ Only show action cards for agent messages, not user
    Widget content = _buildBubbleContent(context, msg, isUser);

    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Row(
          mainAxisAlignment: isUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isUser && widget.isFirstInGroup)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(
                    Icons.car_crash_outlined,
                    color: Colors.black54,
                    size: 16,
                  ),
                ),
              ),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(
                  top: widget.isFirstInGroup ? 6 : 2,
                  left: !isUser && !widget.isFirstInGroup ? 40 : 0,
                  bottom: widget.isLastInGroup ? 6 : 2,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: borderRadius,
                ),
                child: content,
              ),
            ),
            if (isUser && widget.isFirstInGroup)
              const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Icon(Icons.done_all, size: 14, color: Colors.blueAccent),
              ),
          ],
        ),
      ),
    );
  }

  // --- Dynamic Bubble Content ---
  Widget _buildBubbleContent(BuildContext context, Message msg, bool isUser) {
    // ✅ File bubbles work for both
    if (msg.type == MessageType.file) {
      return _buildFileBubble(context);
    }

    // ✅ Action cards appear only for agent
    if (!isUser &&
        {
          MessageType.payment,
          MessageType.booking,
          MessageType.map,
          MessageType.feedback,
          MessageType.delivery,
          MessageType.buttons,
          MessageType.inventory
        }.contains(msg.type)) {
      return GlobalActionCards.build(msg, widget.onUserAction);
    }

    // ✅ Fallback: simple text
    return Text(
      msg.text,
      style: const TextStyle(fontSize: 14, color: Colors.black87),
      softWrap: true,
    );
  }

  // -------- FILE ----------
  Widget _buildFileBubble(BuildContext context) {
    final name = widget.message.metadata?['name'] ?? 'Unknown File';
    final path = widget.message.metadata?['path'];
    final lower = name.toLowerCase();

    final isImage =
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif');

    if (isImage && path != null && File(path).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(File(path), width: 180, fit: BoxFit.cover),
      );
    }

    IconData icon;
    if (lower.endsWith('.pdf')) {
      icon = FontAwesomeIcons.filePdf;
    } else if (lower.endsWith('.doc') || lower.endsWith('.docx')) {
      icon = FontAwesomeIcons.fileWord;
    } else if (lower.endsWith('.mp3') || lower.endsWith('.wav')) {
      icon = FontAwesomeIcons.music;
    } else {
      icon = FontAwesomeIcons.file;
    }

    return InkWell(
      onTap: path != null ? () => OpenFilex.open(path) : null,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 14, color: Colors.black54),
          const SizedBox(width: 6),
          Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
