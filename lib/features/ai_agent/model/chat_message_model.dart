/// Model class representing a chat message in the AI agent conversation
class ChatMessage {
  final String content;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.content,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  ChatMessage copyWith({String? content, bool? isUser, DateTime? timestamp}) {
    return ChatMessage(
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  String toString() =>
      'ChatMessage(content: $content, isUser: $isUser, timestamp: $timestamp)';
}
