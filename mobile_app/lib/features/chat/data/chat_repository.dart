import 'package:dio/dio.dart';
import '../../../core/config/white_label_config.dart';
import '../../../data/models/chat_message.dart';

/// Chat repository for server-side persistence
///
/// Handles saving messages and loading history from:
/// - POST /api/save-chat
/// - GET /api/chat-history
class ChatRepository {
  final Dio _dio;

  ChatRepository({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = WhiteLabelConfig.apiBaseUrl;
    _dio.options.headers = {'Content-Type': 'application/json'};
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  /// Save a message to the server
  ///
  /// [sessionId] - Unique session identifier
  /// [userId] - Optional user ID for logged-in users
  /// [message] - The message to save (role + content)
  Future<void> saveMessage({
    required String sessionId,
    String? userId,
    required ChatMessage message,
  }) async {
    try {
      await _dio.post(
        '/api/save-chat',
        data: {
          'sessionId': sessionId,
          'userId': userId,
          'message': {
            'role': message.role == ChatRole.user ? 'user' : 'assistant',
            'content': message.content,
          },
        },
      );
    } catch (e) {
      // Silently fail - don't block chat experience
      // ignore: avoid_print
      print('ChatRepository.saveMessage error: $e');
    }
  }

  /// Load chat history from the server
  ///
  /// Returns a [ChatHistory] containing messages and optional guest info.
  Future<ChatHistory> loadHistory(String sessionId) async {
    try {
      final response = await _dio.get(
        '/api/chat-history',
        queryParameters: {'sessionId': sessionId},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final messages = <ChatMessage>[];
        if (data['messages'] != null) {
          for (final msg in data['messages']) {
            messages.add(
              ChatMessage(
                id: msg['id'] as String,
                content: msg['content'] as String,
                role: msg['role'] == 'user'
                    ? ChatRole.user
                    : ChatRole.assistant,
                timestamp: msg['createdAt'] != null
                    ? DateTime.tryParse(msg['createdAt'].toString()) ??
                          DateTime.now()
                    : DateTime.now(),
              ),
            );
          }
        }

        return ChatHistory(
          messages: messages,
          guestName: data['guestInfo']?['name'] as String?,
          guestPhone: data['guestInfo']?['phone'] as String?,
        );
      }
    } catch (e) {
      // ignore: avoid_print
      print('ChatRepository.loadHistory error: $e');
    }

    return const ChatHistory(messages: []);
  }
}

/// Chat history response from server
class ChatHistory {
  final List<ChatMessage> messages;
  final String? guestName;
  final String? guestPhone;

  const ChatHistory({
    this.messages = const [],
    this.guestName,
    this.guestPhone,
  });
}
