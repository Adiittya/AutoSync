enum MessageType { text, rating, booking, suggestion, file }

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
