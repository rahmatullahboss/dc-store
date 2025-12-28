import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/chat_message.dart';
import '../../../services/ai_chat_service.dart';
import '../data/chat_repository.dart';

/// Provider for the AI chat service
final aiChatServiceProvider = Provider<AIChatService>((ref) {
  return AIChatService();
});

/// Provider for the chat repository
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository();
});

/// Provider for chat messages state
final chatMessagesProvider = NotifierProvider<ChatMessagesNotifier, ChatState>(
  ChatMessagesNotifier.new,
);

/// Chat state containing messages, loading status, and session info
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final String? sessionId;
  final bool historyLoaded;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
    this.sessionId,
    this.historyLoaded = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    String? sessionId,
    bool? historyLoaded,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      sessionId: sessionId ?? this.sessionId,
      historyLoaded: historyLoaded ?? this.historyLoaded,
    );
  }
}

/// State notifier for managing chat messages with server sync
class ChatMessagesNotifier extends Notifier<ChatState> {
  static const String _sessionKey = 'chat_session_id';
  static const String _localHistoryKey = 'chat_history_local';

  @override
  ChatState build() {
    _initSession();
    return const ChatState();
  }

  AIChatService get _chatService => ref.read(aiChatServiceProvider);
  ChatRepository get _chatRepo => ref.read(chatRepositoryProvider);

  /// Initialize session and load history
  Future<void> _initSession() async {
    final prefs = await SharedPreferences.getInstance();

    // Get or create session ID
    var sessionId = prefs.getString(_sessionKey);
    if (sessionId == null) {
      sessionId = _generateSessionId();
      await prefs.setString(_sessionKey, sessionId);
    }

    state = state.copyWith(sessionId: sessionId);

    // Load history from server
    await _loadServerHistory(sessionId);
  }

  /// Generate unique session ID
  String _generateSessionId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(999999).toString().padLeft(6, '0');
    return 'chat_${timestamp}_$random';
  }

  /// Load chat history from server
  Future<void> _loadServerHistory(String sessionId) async {
    try {
      final history = await _chatRepo.loadHistory(sessionId);

      if (history.messages.isNotEmpty) {
        state = state.copyWith(messages: history.messages, historyLoaded: true);
      } else {
        // Fall back to local storage
        await _loadLocalHistory();
      }
    } catch (e) {
      // Fall back to local storage on error
      await _loadLocalHistory();
    }
  }

  /// Load chat history from local storage (fallback)
  Future<void> _loadLocalHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_localHistoryKey);
      if (historyJson != null) {
        final List<dynamic> decoded = jsonDecode(historyJson);
        final messages = decoded
            .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
            .toList();
        state = state.copyWith(messages: messages, historyLoaded: true);
      } else {
        state = state.copyWith(historyLoaded: true);
      }
    } catch (e) {
      state = state.copyWith(historyLoaded: true);
    }
  }

  /// Save chat history to local storage (backup)
  Future<void> _saveLocalHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = jsonEncode(
        state.messages
            .where((m) => !m.isLoading && m.error == null)
            .map((m) => m.toJson())
            .toList(),
      );
      await prefs.setString(_localHistoryKey, historyJson);
    } catch (e) {
      // Ignore errors
    }
  }

  /// Send a message to the AI assistant
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;
    if (state.isLoading) return;

    final sessionId = state.sessionId;
    if (sessionId == null) return;

    // Add user message
    final userMessage = ChatMessage.user(content.trim());
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

    // Save user message to server (async, don't await)
    _chatRepo.saveMessage(sessionId: sessionId, message: userMessage);

    try {
      // Check if API key is configured
      if (!_chatService.isConfigured) {
        throw AIChatException(
          'AI chat is not configured. Please set your OpenRouter API key.',
        );
      }

      // Get AI response
      final response = await _chatService.sendMessage(
        state.messages.where((m) => !m.isLoading && m.error == null).toList(),
        content.trim(),
      );

      // Add assistant message
      final assistantMessage = ChatMessage.assistant(response);
      state = state.copyWith(
        messages: [...state.messages, assistantMessage],
        isLoading: false,
      );

      // Save assistant message to server (async, don't await)
      _chatRepo.saveMessage(sessionId: sessionId, message: assistantMessage);

      // Save local backup
      await _saveLocalHistory();
    } on AIChatException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Something went wrong. Please try again.',
      );
    }
  }

  /// Clear all chat messages and start new session
  Future<void> clearChat() async {
    final prefs = await SharedPreferences.getInstance();

    // Generate new session
    final newSessionId = _generateSessionId();
    await prefs.setString(_sessionKey, newSessionId);
    await prefs.remove(_localHistoryKey);

    state = ChatState(sessionId: newSessionId, historyLoaded: true);
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }
}
