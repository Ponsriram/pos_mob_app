import 'package:flutter/material.dart';
import 'package:pos_app/features/ai_agent/model/chat_message_model.dart';

/// A chat bubble widget that displays a single message with markdown support
class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  /// Parses markdown text and returns a list of text spans
  List<TextSpan> _parseMarkdown(
    String text,
    TextStyle baseStyle,
    TextStyle boldStyle,
  ) {
    final spans = <TextSpan>[];

    // Pattern to match **bold**, *bullet*, and newlines
    final boldPattern = RegExp(r'\*\*([^*]+)\*\*');
    final linePattern = RegExp(r'^\*\s+(.+)$', multiLine: true);

    // First, split by lines to handle bullet points
    final lines = text.split('\n');

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (line.isEmpty) {
        spans.add(TextSpan(text: '\n', style: baseStyle));
        continue;
      }

      // Check if it's a bullet point
      final bulletMatch = linePattern.firstMatch(line);
      if (bulletMatch != null) {
        // Add bullet point with special styling
        spans.add(TextSpan(text: '• ', style: boldStyle));

        final content = bulletMatch.group(1) ?? '';
        int contentIndex = 0;

        // Parse bold text within the bullet
        for (final boldMatch in boldPattern.allMatches(content)) {
          if (boldMatch.start > contentIndex) {
            spans.add(
              TextSpan(
                text: content.substring(contentIndex, boldMatch.start),
                style: baseStyle,
              ),
            );
          }
          spans.add(TextSpan(text: boldMatch.group(1), style: boldStyle));
          contentIndex = boldMatch.end;
        }

        if (contentIndex < content.length) {
          spans.add(
            TextSpan(text: content.substring(contentIndex), style: baseStyle),
          );
        }

        spans.add(TextSpan(text: '\n', style: baseStyle));
      } else {
        // Regular line with potential bold text
        int lineIndex = 0;
        for (final boldMatch in boldPattern.allMatches(line)) {
          if (boldMatch.start > lineIndex) {
            spans.add(
              TextSpan(
                text: line.substring(lineIndex, boldMatch.start),
                style: baseStyle,
              ),
            );
          }
          spans.add(TextSpan(text: boldMatch.group(1), style: boldStyle));
          lineIndex = boldMatch.end;
        }

        if (lineIndex < line.length) {
          spans.add(
            TextSpan(text: line.substring(lineIndex), style: baseStyle),
          );
        }

        spans.add(TextSpan(text: '\n', style: baseStyle));
      }
    }

    // Remove trailing newline if present
    if (spans.isNotEmpty && spans.last.text == '\n') {
      spans.removeLast();
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final colorScheme = Theme.of(context).colorScheme;
    final baseTextColor = isUser
        ? colorScheme.onPrimary
        : colorScheme.onSurface;
    final baseStyle = TextStyle(
      color: baseTextColor,
      fontSize: 15,
      height: 1.4,
    );
    final boldStyle = baseStyle.copyWith(fontWeight: FontWeight.w600);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isUser ? 48 : 8,
          right: isUser ? 8 : 48,
          top: 4,
          bottom: 4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // AI Avatar (only for AI messages)
            if (!isUser) ...[
              CircleAvatar(
                radius: 16,
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(
                  Icons.smart_toy_outlined,
                  size: 18,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 8),
            ],

            // Message bubble
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isUser
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isUser ? 16 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: SelectableText.rich(
                  TextSpan(
                    children: _parseMarkdown(
                      message.content,
                      baseStyle,
                      boldStyle,
                    ),
                  ),
                ),
              ),
            ),

            // User Avatar (only for user messages)
            if (isUser) ...[
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: colorScheme.secondaryContainer,
                child: Icon(
                  Icons.person,
                  size: 18,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A typing indicator widget shown when AI is generating a response
class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.smart_toy_outlined,
                size: 18,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(3, (index) {
                      final delay = index * 0.2;
                      final value = (_animation.value + delay) % 1.0;
                      final opacity = (value < 0.5)
                          ? value * 2
                          : (1 - value) * 2;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        child: Opacity(
                          opacity: opacity.clamp(0.3, 1.0),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
