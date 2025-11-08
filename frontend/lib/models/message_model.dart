enum MessageType { text, file, payment, booking, map, feedback, delivery, buttons, inventory }

class Message {
  final String text;
  final bool isUser;
  final MessageType type;
  final Map<String, dynamic>? metadata;

  Message({
    required this.text,
    required this.isUser,
    this.type = MessageType.text,
    this.metadata,
  });
}
