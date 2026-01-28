import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/features/ai_agent/model/chat_message_model.dart';
import 'package:pos_app/features/ai_agent/repository/ai_agent_repository.dart';

part 'ai_agent_viewmodel.g.dart';

/// State class for the AI agent chat
class AiAgentState {
  final List<ChatMessage> messages;
  final bool isTyping;
  final String? errorMessage;

  const AiAgentState({
    this.messages = const [],
    this.isTyping = false,
    this.errorMessage,
  });

  AiAgentState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
    String? errorMessage,
  }) {
    return AiAgentState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      errorMessage: errorMessage,
    );
  }
}

/// ViewModel for managing AI agent chat interactions
@riverpod
class AiAgentViewModel extends _$AiAgentViewModel {
  late final AiAgentRepository _repo;

  @override
  FutureOr<AiAgentState> build() {
    _repo = ref.read(aiAgentRepositoryProvider);

    // Return initial state with welcome message
    return AiAgentState(
      messages: [
        ChatMessage(
          content:
              "👋 Hello! I'm your POS Assistant.\n\n"
              "I can help you with:\n"
              "• 📦 **Orders & Sales** - Create, manage, refund orders\n"
              "• 📊 **Inventory** - Stock levels, products, categories\n"
              "• 📈 **Reports** - Sales analytics, daily summaries\n"
              "• 💳 **Payments** - Transaction history, receipts\n"
              "• 👥 **Customers** - Profiles, loyalty programs\n"
              "• ⚙️ **App Help** - Navigation, features, settings\n\n"
              "How can I assist you today?",
          isUser: false,
        ),
      ],
    );
  }

  /// List of Content objects for chat history
  /// Note: We build this dynamically from ChatMessage objects since
  /// the google_generative_ai library only provides Content.text() factory
  List<Content> _buildChatHistory() {
    return _localChatHistory.map((msg) {
      // Use Content.text() which automatically sets role='user'
      // For model responses, we need to construct them differently
      return Content.text(msg.content);
    }).toList();
  }

  /// Local storage of chat messages for building Content objects
  final List<ChatMessage> _localChatHistory = [];

  /// Sends a user message and gets AI response
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    final currentState = state.value ?? const AiAgentState();

    // Add user message to the chat
    final userMessage = ChatMessage(content: message.trim(), isUser: true);
    state = AsyncData(
      currentState.copyWith(
        messages: [...currentState.messages, userMessage],
        isTyping: true,
        errorMessage: null,
      ),
    );

    // Add user message to local history
    _localChatHistory.add(userMessage);

    // Get AI response
    final result = await _repo.sendMessage(message.trim(), _buildChatHistory());

    result.match(
      (failure) {
        // On error, add error message and don't update history
        final errorMessage = ChatMessage(
          content: "❌ ${failure.message}\n\nPlease try again.",
          isUser: false,
        );

        // Remove the last user message from history since it failed
        if (_localChatHistory.isNotEmpty && _localChatHistory.last.isUser) {
          _localChatHistory.removeLast();
        }

        state = AsyncData(
          state.value!.copyWith(
            messages: [...state.value!.messages, errorMessage],
            isTyping: false,
            errorMessage: failure.message,
          ),
        );
      },
      (response) {
        // Add AI response to local history
        _localChatHistory.add(ChatMessage(content: response, isUser: false));

        final aiMessage = ChatMessage(content: response, isUser: false);
        state = AsyncData(
          state.value!.copyWith(
            messages: [...state.value!.messages, aiMessage],
            isTyping: false,
            errorMessage: null,
          ),
        );
      },
    );
  }

  /// Clears the chat history and resets to initial state
  void clearChat() {
    _localChatHistory.clear();
    state = AsyncData(
      AiAgentState(
        messages: [
          ChatMessage(
            content:
                "🔄 Chat cleared!\n\n"
                "How can I help you with your POS needs today?",
            isUser: false,
          ),
        ],
      ),
    );
  }

  /// Retries the last failed message
  Future<void> retryLastMessage() async {
    final currentMessages = state.value?.messages ?? [];
    if (currentMessages.length < 2) return;

    // Find the last user message
    String? lastUserMessage;
    for (int i = currentMessages.length - 1; i >= 0; i--) {
      if (currentMessages[i].isUser) {
        lastUserMessage = currentMessages[i].content;
        break;
      }
    }

    if (lastUserMessage != null) {
      // Remove the last error message
      final updatedMessages = List<ChatMessage>.from(currentMessages);
      if (!updatedMessages.last.isUser) {
        updatedMessages.removeLast();
      }
      // Remove the failed user message
      if (updatedMessages.isNotEmpty && updatedMessages.last.isUser) {
        updatedMessages.removeLast();
      }

      state = AsyncData(state.value!.copyWith(messages: updatedMessages));

      // Retry sending the message
      await sendMessage(lastUserMessage);
    }
  }
}
