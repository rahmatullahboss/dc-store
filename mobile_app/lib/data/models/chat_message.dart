/// Chat message model for AI chatbot
class ChatMessage {
  final String id;
  final String content;
  final ChatRole role;
  final DateTime timestamp;
  final bool isLoading;
  final String? error;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    this.isLoading = false,
    this.error,
  });

  /// Create a user message
  factory ChatMessage.user(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      role: ChatRole.user,
      timestamp: DateTime.now(),
    );
  }

  /// Create an assistant message
  factory ChatMessage.assistant(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      role: ChatRole.assistant,
      timestamp: DateTime.now(),
    );
  }

  /// Create a loading placeholder message
  factory ChatMessage.loading() {
    return ChatMessage(
      id: 'loading_${DateTime.now().millisecondsSinceEpoch}',
      content: '',
      role: ChatRole.assistant,
      timestamp: DateTime.now(),
      isLoading: true,
    );
  }

  /// Create an error message
  factory ChatMessage.error(String errorMessage) {
    return ChatMessage(
      id: 'error_${DateTime.now().millisecondsSinceEpoch}',
      content: '',
      role: ChatRole.assistant,
      timestamp: DateTime.now(),
      error: errorMessage,
    );
  }

  /// Copy with new values
  ChatMessage copyWith({
    String? id,
    String? content,
    ChatRole? role,
    DateTime? timestamp,
    bool? isLoading,
    String? error,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp ?? this.timestamp,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Convert to JSON for API request
  Map<String, dynamic> toApiMessage() {
    return {
      'role': role == ChatRole.user ? 'user' : 'assistant',
      'content': content,
    };
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'role': role.name,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Create from JSON (storage)
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      role: ChatRole.values.byName(json['role'] as String),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

/// Chat message role
enum ChatRole { user, assistant, system }
