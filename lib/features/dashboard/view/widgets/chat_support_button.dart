import 'package:flutter/material.dart';

/// Floating action button for chat/support
class ChatSupportButton extends StatelessWidget {
  final VoidCallback? onTap;

  const ChatSupportButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: colorScheme.primary,
      elevation: 4,
      child: Icon(
        Icons.chat_bubble_outline,
        color: colorScheme.onPrimary,
        size: 24,
      ),
    );
  }
}
