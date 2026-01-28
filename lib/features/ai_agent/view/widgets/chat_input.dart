import 'package:flutter/material.dart';

/// Input widget for typing and sending chat messages
class ChatInput extends StatefulWidget {
  final Function(String) onSend;
  final bool enabled;

  const ChatInput({super.key, required this.onSend, this.enabled = true});

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && widget.enabled) {
      widget.onSend(text);
      _controller.clear();
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Text input field
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: _focusNode.hasFocus
                        ? colorScheme.primary.withValues(alpha: 0.5)
                        : Colors.transparent,
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                  decoration: InputDecoration(
                    hintText: widget.enabled
                        ? 'Ask about POS features...'
                        : 'AI is thinking...',
                    hintStyle: TextStyle(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.6,
                      ),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  style: TextStyle(color: colorScheme.onSurface, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(width: 8),

            // Send button
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Material(
                color: _hasText && widget.enabled
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(
                  onTap: _hasText && widget.enabled ? _handleSend : null,
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.send_rounded,
                      color: _hasText && widget.enabled
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

/// Quick suggestion chips for common questions
class QuickSuggestions extends StatelessWidget {
  final Function(String) onSuggestionTap;
  final bool enabled;

  const QuickSuggestions({
    super.key,
    required this.onSuggestionTap,
    this.enabled = true,
  });

  static const List<String> suggestions = [
    'How do I create a new order?',
    'Show me today\'s sales summary',
    'How to add a new product?',
    'How to process a refund?',
    'Where are the reports?',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: suggestions.length,
        separatorBuilder: (_, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          return ActionChip(
            label: Text(
              suggestions[index],
              style: TextStyle(
                fontSize: 12,
                color: enabled
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ),
            backgroundColor: colorScheme.surfaceContainerHighest,
            side: BorderSide.none,
            onPressed: enabled
                ? () => onSuggestionTap(suggestions[index])
                : null,
          );
        },
      ),
    );
  }
}
