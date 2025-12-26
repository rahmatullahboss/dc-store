import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/config/white_label_config.dart';
import '../data/models/chat_message.dart';

/// AI Chat Service using OpenRouter API
///
/// Provides methods to send messages to AI and get responses.
/// Supports both regular and streaming responses.
class AIChatService {
  final Dio _dio;

  AIChatService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = WhiteLabelConfig.openRouterBaseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer ${WhiteLabelConfig.openRouterApiKey}',
      'Content-Type': 'application/json',
      'HTTP-Referer': WhiteLabelConfig.websiteUrl,
      'X-Title': WhiteLabelConfig.appName,
    };
  }

  /// Send a message and get AI response
  ///
  /// [messages] - List of previous messages for context
  /// [userMessage] - The new user message
  /// Returns the AI's response as a string
  Future<String> sendMessage(
    List<ChatMessage> messages,
    String userMessage,
  ) async {
    try {
      // Build message list with system prompt
      final apiMessages = <Map<String, dynamic>>[
        {'role': 'system', 'content': WhiteLabelConfig.aiSystemPrompt},
        // Add previous messages for context (limit to last 10)
        ...messages
            .skip(messages.length > 10 ? messages.length - 10 : 0)
            .map((m) => m.toApiMessage()),
        // Add new user message
        {'role': 'user', 'content': userMessage},
      ];

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': WhiteLabelConfig.aiModel,
          'messages': apiMessages,
          'max_tokens': 500,
          'temperature': 0.7,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final content = data['choices']?[0]?['message']?['content'] as String?;
        return content ?? 'Sorry, I could not generate a response.';
      } else {
        throw AIChatException('Failed to get response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw AIChatException(
          'Invalid API key. Please check your OpenRouter API key.',
        );
      } else if (e.response?.statusCode == 429) {
        throw AIChatException('Rate limit exceeded. Please wait a moment.');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw AIChatException(
          'Connection timeout. Please check your internet.',
        );
      } else {
        throw AIChatException('Network error: ${e.message}');
      }
    } catch (e) {
      if (e is AIChatException) rethrow;
      throw AIChatException('Unexpected error: $e');
    }
  }

  /// Send a message with streaming response
  ///
  /// Returns a stream of response chunks for real-time display
  Stream<String> sendMessageStream(
    List<ChatMessage> messages,
    String userMessage,
  ) async* {
    try {
      // Build message list with system prompt
      final apiMessages = <Map<String, dynamic>>[
        {'role': 'system', 'content': WhiteLabelConfig.aiSystemPrompt},
        ...messages
            .skip(messages.length > 10 ? messages.length - 10 : 0)
            .map((m) => m.toApiMessage()),
        {'role': 'user', 'content': userMessage},
      ];

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': WhiteLabelConfig.aiModel,
          'messages': apiMessages,
          'max_tokens': 500,
          'temperature': 0.7,
          'stream': true,
        },
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data.stream as Stream<List<int>>;
      String buffer = '';

      await for (final chunk in stream) {
        buffer += utf8.decode(chunk);

        // Parse SSE data
        final lines = buffer.split('\n');
        buffer = lines.last; // Keep incomplete line in buffer

        for (final line in lines.take(lines.length - 1)) {
          if (line.startsWith('data: ')) {
            final data = line.substring(6);
            if (data == '[DONE]') break;

            try {
              final json = jsonDecode(data);
              final content =
                  json['choices']?[0]?['delta']?['content'] as String?;
              if (content != null) {
                yield content;
              }
            } catch (_) {
              // Skip malformed JSON
            }
          }
        }
      }
    } catch (e) {
      if (e is AIChatException) rethrow;
      throw AIChatException('Stream error: $e');
    }
  }

  /// Check if API key is configured
  bool get isConfigured {
    return WhiteLabelConfig.openRouterApiKey != 'YOUR_OPENROUTER_API_KEY' &&
        WhiteLabelConfig.openRouterApiKey.isNotEmpty;
  }
}

/// Custom exception for AI chat errors
class AIChatException implements Exception {
  final String message;

  AIChatException(this.message);

  @override
  String toString() => message;
}
