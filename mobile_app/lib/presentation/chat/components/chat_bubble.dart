import 'package:flutter/material.dart';
import '../../../data/models/chat_message.dart';
import '../../../data/models/chat_product.dart';
import '../../../core/config/white_label_config.dart';
import 'chat_product_card.dart';

/// Chat message bubble widget with product card support
class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback? onCopy;

  const ChatBubble({super.key, required this.message, this.onCopy});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisAlignment: isUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[_buildAvatar(isDark), const SizedBox(width: 8)],
          Flexible(
            child: GestureDetector(
              onLongPress: onCopy,
              child: _buildMessageContent(isUser, isDark),
            ),
          ),
          if (isUser) ...[const SizedBox(width: 8), _buildUserAvatar(isDark)],
        ],
      ),
    );
  }

  Widget _buildMessageContent(bool isUser, bool isDark) {
    // For user messages, just show plain text
    if (isUser) {
      return _buildTextBubble(message.content, isUser, isDark);
    }

    // For assistant messages, parse for products
    final segments = parseMessageContent(message.content);

    // If no products found, show plain text
    if (segments.isEmpty ||
        (segments.length == 1 && segments.first is TextSegment)) {
      return _buildTextBubble(message.content, isUser, isDark);
    }

    // Render segments (text and products)
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: segments.map((segment) {
        if (segment is TextSegment) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: _buildTextBubble(segment.content, isUser, isDark),
          );
        } else if (segment is ProductSegment) {
          return ChatProductCard(product: segment.product);
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }

  Widget _buildTextBubble(String text, bool isUser, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isUser
            ? WhiteLabelConfig.accentColor
            : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(18),
          topRight: const Radius.circular(18),
          bottomLeft: Radius.circular(isUser ? 18 : 4),
          bottomRight: Radius.circular(isUser ? 4 : 18),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          height: 1.4,
          color: isUser
              ? Colors.white
              : (isDark ? Colors.white : const Color(0xFF1E293B)),
        ),
      ),
    );
  }

  Widget _buildAvatar(bool isDark) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            WhiteLabelConfig.accentColor,
            WhiteLabelConfig.accentLightColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 18),
    );
  }

  Widget _buildUserAvatar(bool isDark) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF374151) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        Icons.person_rounded,
        color: isDark ? Colors.white70 : const Color(0xFF64748B),
        size: 18,
      ),
    );
  }
}
