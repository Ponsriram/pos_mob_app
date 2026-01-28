import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pos_app/core/error/failure.dart';
import 'dart:developer' as developer;

part 'ai_agent_repository.g.dart';

@riverpod
AiAgentRepository aiAgentRepository(Ref ref) {
  return AiAgentRepositoryImpl();
}

/// Abstract repository interface for AI agent operations
abstract class AiAgentRepository {
  /// Sends a message to the AI and returns the response
  Future<Either<Failure, String>> sendMessage(
    String message,
    List<Content> history,
  );
}

/// Implementation of the AI agent repository using Google Gemini
class AiAgentRepositoryImpl implements AiAgentRepository {
  GenerativeModel? _model;

  // System instruction to restrict AI to POS app topics only
  static const String _systemInstruction = '''
You are a helpful AI assistant for a Point of Sale (POS) application. 
You can ONLY help with topics related to:

1. **Orders & Sales**: Creating orders, managing transactions, applying discounts, refunds, order history
2. **Inventory Management**: Stock levels, product categories, adding/editing products, low stock alerts
3. **Reports & Analytics**: Sales reports, daily summaries, outlet statistics, revenue tracking
4. **Payment Processing**: Payment methods, receipts, transaction history, cash management
5. **Customer Management**: Customer profiles, purchase history, loyalty programs
6. **Staff & Permissions**: User roles, access control, staff performance
7. **App Navigation**: How to use features in this POS app, where to find settings
8. **Troubleshooting**: Common POS app issues and solutions, sync problems, printer issues

IMPORTANT RULES:
- If a user asks about anything NOT related to POS operations or this app, politely decline and say: "I'm specifically designed to help with POS-related questions. Is there anything about orders, inventory, reports, or app features I can help you with?"
- Keep responses concise, practical, and action-oriented
- Use bullet points for step-by-step instructions
- Always be helpful, professional, and friendly
- If you don't know something specific about this app, provide general POS best practices

Example topics you should DECLINE:
- General coding questions
- Weather, news, or entertainment
- Personal advice unrelated to business
- Other apps or software
- Academic or research questions
''';

  /// Initializes the Gemini model with API key from environment
  void _initModel() {
    if (_model != null) return;

    final apiKey = dotenv.env['GEMINI_API_KEY'];

    // Debug logging
    developer.log(
      'Initializing AI Agent',
      name: 'AiAgentRepository',
      error: apiKey == null
          ? 'API Key is null'
          : apiKey.isEmpty
          ? 'API Key is empty'
          : 'OK',
    );

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'GEMINI_API_KEY not found in .env file. '
        'Please add your API key to use the AI assistant.',
      );
    }

    try {
      _model = GenerativeModel(
        model: 'gemini-2.0-flash-lite', // Free tier model - fast and efficient
        apiKey: apiKey,
        systemInstruction: Content.text(_systemInstruction),
        generationConfig: GenerationConfig(
          temperature: 0.7,
          maxOutputTokens: 1024,
          topP: 0.95,
          topK: 40,
        ),
        safetySettings: [
          SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
          SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
          SafetySetting(
            HarmCategory.sexuallyExplicit,
            HarmBlockThreshold.medium,
          ),
          SafetySetting(
            HarmCategory.dangerousContent,
            HarmBlockThreshold.medium,
          ),
        ],
      );
      developer.log(
        'AI Model initialized successfully',
        name: 'AiAgentRepository',
      );
    } catch (e) {
      developer.log(
        'Failed to initialize AI Model',
        name: 'AiAgentRepository',
        error: e,
      );
      rethrow;
    }
  }

  @override
  Future<Either<Failure, String>> sendMessage(
    String message,
    List<Content> history,
  ) async {
    try {
      developer.log(
        'sendMessage() called',
        name: 'AiAgentRepository',
        error: 'message=$message, history_length=${history.length}',
      );

      _initModel();

      developer.log(
        'Model initialized, starting chat',
        name: 'AiAgentRepository',
      );

      final chat = _model!.startChat(history: history);
      developer.log(
        'Chat started, sending message',
        name: 'AiAgentRepository',
        error: message,
      );

      final response = await chat.sendMessage(Content.text(message));

      developer.log(
        'Response received from Gemini',
        name: 'AiAgentRepository',
        error: 'response_length=${response.text?.length}',
      );

      final text = response.text;
      if (text == null || text.isEmpty) {
        developer.log(
          'Received empty response from AI',
          name: 'AiAgentRepository',
        );
        return left(
          const Failure(
            message: 'I received an empty response. Please try again.',
          ),
        );
      }

      developer.log(
        'AI response received successfully',
        name: 'AiAgentRepository',
      );
      return right(text);
    } on GenerativeAIException catch (e) {
      // Handle Gemini-specific errors
      developer.log(
        'GenerativeAI Error',
        name: 'AiAgentRepository',
        error: e.message,
      );

      String errorMessage = 'AI service error. Please try again.';

      if (e.message.contains('API key') ||
          e.message.contains('401') ||
          e.message.contains('403')) {
        errorMessage =
            'Invalid or expired API key. Please verify your GEMINI_API_KEY in the .env file.';
      } else if (e.message.contains('quota') || e.message.contains('429')) {
        errorMessage =
            'API quota exceeded. Please try again later or check your usage limits.';
      } else if (e.message.contains('blocked')) {
        errorMessage =
            'This request was blocked for safety reasons. Please rephrase your question.';
      } else if (e.message.contains('network') ||
          e.message.contains('Connection')) {
        errorMessage =
            'Network error. Please check your internet connection and try again.';
      }

      return left(Failure(message: errorMessage, originalError: e));
    } catch (e) {
      // Handle initialization errors
      developer.log(
        'Unexpected Error',
        name: 'AiAgentRepository',
        error: e.toString(),
      );

      if (e.toString().contains('GEMINI_API_KEY')) {
        return left(
          Failure(
            message:
                'API key not configured. Please add GEMINI_API_KEY to your .env file.',
            originalError: e,
          ),
        );
      }

      return left(
        Failure(
          message:
              'Something went wrong. Please check your internet connection and try again. Error: $e',
          originalError: e,
        ),
      );
    }
  }
}
