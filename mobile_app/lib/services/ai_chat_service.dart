import 'dart:convert';
import 'package:dio/dio.dart';
import '../core/config/white_label_config.dart';
import '../data/models/chat_message.dart';

/// AI Chat Service using the backend API
///
/// Connects to the existing Next.js API route at /api/chat
/// which uses Vercel AI SDK with streamText and toUIMessageStreamResponse
class AIChatService {
  final Dio _dio;

  AIChatService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = WhiteLabelConfig.apiBaseUrl;
    _dio.options.headers = {'Content-Type': 'application/json'};
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
    // Important: Accept the stream response type
    _dio.options.responseType = ResponseType.plain;
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
      // Build message list in the format expected by the Vercel AI SDK
      final apiMessages = <Map<String, dynamic>>[
        // Add previous messages for context (limit to last 10)
        ...messages
            .skip(messages.length > 10 ? messages.length - 10 : 0)
            .map(
              (m) => ({
                'role': m.role == ChatRole.user ? 'user' : 'assistant',
                'content': m.content,
              }),
            ),
        // Add new user message
        {'role': 'user', 'content': userMessage},
      ];

      final response = await _dio.post(
        '/api/chat',
        data: {'messages': apiMessages},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        // Parse the Vercel AI SDK stream response
        if (data is String) {
          return _parseVercelAIStreamResponse(data);
        }

        return 'Sorry, I could not generate a response.';
      } else {
        throw AIChatException('Failed to get response: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 500) {
        final errorData = e.response?.data;
        if (errorData is String) {
          try {
            final parsed = jsonDecode(errorData);
            if (parsed is Map && parsed['error'] != null) {
              throw AIChatException(parsed['error'] as String);
            }
          } catch (_) {}
        }
        if (errorData is Map && errorData['error'] != null) {
          throw AIChatException(errorData['error'] as String);
        }
        throw AIChatException('Server error. Please try again later.');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw AIChatException(
          'Connection timeout. Please check your internet.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw AIChatException(
          'Cannot connect to server. Please check your internet.',
        );
      } else {
        throw AIChatException('Network error. Please try again.');
      }
    } catch (e) {
      if (e is AIChatException) rethrow;
      throw AIChatException('Unexpected error: $e');
    }
  }

  /// Parse Vercel AI SDK stream response (toUIMessageStreamResponse format)
  ///
  /// The format uses specific prefixes:
  /// - "0:" for text content
  /// - "e:" for finish reason/metadata
  /// - "d:" for done signal
  String _parseVercelAIStreamResponse(String data) {
    final buffer = StringBuffer();
    final lines = data.split('\n');

    for (final line in lines) {
      if (line.isEmpty) continue;

      // Handle Vercel AI SDK stream format
      // Text chunks are prefixed with "0:"
      if (line.startsWith('0:')) {
        final content = line.substring(2);
        try {
          // Content is JSON encoded string
          final decoded = jsonDecode(content);
          if (decoded is String) {
            buffer.write(decoded);
          }
        } catch (_) {
          // If not JSON, just use the raw content
          buffer.write(content);
        }
      }
      // Handle older SSE format (data: prefix)
      else if (line.startsWith('data: ')) {
        final content = line.substring(6);
        if (content == '[DONE]') break;

        try {
          final json = jsonDecode(content);
          final text =
              json['text'] ??
              json['content'] ??
              json['delta']?['content'] ??
              json['choices']?[0]?['delta']?['content'];
          if (text != null) {
            buffer.write(text);
          }
        } catch (_) {
          // Ignore parsing errors for non-JSON lines
        }
      }
    }

    final result = buffer.toString().trim();
    return result.isNotEmpty
        ? result
        : 'Sorry, I could not generate a response.';
  }

  /// Check if the service is available
  bool get isConfigured => true; // Always true since we use backend API
}

/// Custom exception for AI chat errors
class AIChatException implements Exception {
  final String message;

  AIChatException(this.message);

  @override
  String toString() => message;
}
