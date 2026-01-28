import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pos_app/features/ai_agent/viewmodel/ai_agent_viewmodel.dart';
import 'package:pos_app/features/ai_agent/view/widgets/chat_bubble.dart';
import 'package:pos_app/features/ai_agent/view/widgets/chat_input.dart';

/// Main page for the AI chat assistant
class AiChatPage extends ConsumerStatefulWidget {
  const AiChatPage({super.key});

  @override
  ConsumerState<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends ConsumerState<AiChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(aiAgentViewModelProvider);
    final colorScheme = Theme.of(context).colorScheme;

    // Scroll to bottom when new messages arrive
    ref.listen(aiAgentViewModelProvider, (previous, next) {
      final prevCount = previous?.value?.messages.length ?? 0;
      final nextCount = next.value?.messages.length ?? 0;
      if (nextCount > prevCount) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.smart_toy_outlined,
                size: 20,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'POS Assistant',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Text(
                  state.value?.isTyping == true ? 'Typing...' : 'Online',
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Clear chat button
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'clear') {
                _showClearChatDialog(context);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, size: 20),
                    SizedBox(width: 12),
                    Text('Clear Chat'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Something went wrong',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () =>
                            ref.invalidate(aiAgentViewModelProvider),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
              data: (data) => Column(
                children: [
                  // Quick suggestions (show only when few messages)
                  if (data.messages.length <= 2 && !data.isTyping) ...[
                    const SizedBox(height: 8),
                    QuickSuggestions(
                      onSuggestionTap: (suggestion) {
                        ref
                            .read(aiAgentViewModelProvider.notifier)
                            .sendMessage(suggestion);
                      },
                      enabled: !data.isTyping,
                    ),
                    const SizedBox(height: 8),
                  ],

                  // Messages list
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 16,
                      ),
                      itemCount: data.messages.length + (data.isTyping ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Show typing indicator at the end
                        if (data.isTyping && index == data.messages.length) {
                          return const TypingIndicator();
                        }

                        return ChatBubble(message: data.messages[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Input field
          ChatInput(
            onSend: (message) {
              ref.read(aiAgentViewModelProvider.notifier).sendMessage(message);
            },
            enabled: !(state.value?.isTyping ?? false),
          ),
        ],
      ),
    );
  }

  void _showClearChatDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat'),
        content: const Text(
          'Are you sure you want to clear all messages? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(aiAgentViewModelProvider.notifier).clearChat();
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
