import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/chat_message.dart';
import '../../../services/ai_chat_service.dart';

/// Provider for the AI chat service
final aiChatServiceProvider = Provider<AIChatService>((ref) {
  return AIChatService();
});

/// Provider for chat messages state
final chatMessagesProvider = NotifierProvider<ChatMessagesNotifier, ChatState>(
  ChatMessagesNotifier.new,
);

/// Chat state containing messages and loading status
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const ChatState({
    this.messages = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// State notifier for managing chat messages
class ChatMessagesNotifier extends Notifier<ChatState> {
  static const String _storageKey = 'chat_history';

  @override
  ChatState build() {
    _loadHistory();
    return const ChatState();
  }

  AIChatService get _chatService => ref.read(aiChatServiceProvider);

  /// Load chat history from storage
  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getString(_storageKey);
      if (historyJson != null) {
        final List<dynamic> decoded = jsonDecode(historyJson);
        final messages = decoded
            .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
            .toList();
        state = state.copyWith(messages: messages);
      }
    } catch (e) {
      // Ignore errors loading history
    }
  }

  /// Save chat history to storage
  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = jsonEncode(
        state.messages
            .where((m) => !m.isLoading && m.error == null)
            .map((m) => m.toJson())
            .toList(),
      );
      await prefs.setString(_storageKey, historyJson);
    } catch (e) {
      // Ignore errors saving history
    }
  }

  /// Send a message to the AI assistant
  Future<void> sendMessage(String content) async {
    if (content.trim().isEmpty) return;
    if (state.isLoading) return;

    // Add user message
    final userMessage = ChatMessage.user(content.trim());
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
      error: null,
    );

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

      // Save history
      await _saveHistory();
    } on AIChatException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Something went wrong. Please try again.',
      );
    }
  }

  /// Clear all chat messages
  Future<void> clearChat() async {
    state = const ChatState();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }
}
