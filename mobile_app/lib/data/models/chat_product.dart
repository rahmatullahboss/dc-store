/// Product model parsed from AI chat responses
///
/// AI responses contain products in format:
/// [PRODUCT:slug:name:price:category:inStock:imageUrl]
class ChatProduct {
  final String slug;
  final String name;
  final double price;
  final String category;
  final bool inStock;
  final String? imageUrl;

  const ChatProduct({
    required this.slug,
    required this.name,
    required this.price,
    required this.category,
    required this.inStock,
    this.imageUrl,
  });

  /// Parse a single product from the [PRODUCT:...] format
  static ChatProduct? fromTag(String tag) {
    // Format: [PRODUCT:slug:name:price:category:inStock:imageUrl]
    final match = RegExp(
      r'\[PRODUCT:([^:]+):([^:]+):৳?(\d+):([^:]+):(true|false):([^\]]*)\]',
    ).firstMatch(tag);

    if (match == null) return null;

    return ChatProduct(
      slug: match.group(1)!,
      name: match.group(2)!,
      price: double.tryParse(match.group(3)!) ?? 0,
      category: match.group(4)!,
      inStock: match.group(5) == 'true',
      imageUrl: match.group(6)?.isNotEmpty == true ? match.group(6) : null,
    );
  }

  /// Parse all products from text content
  static List<ChatProduct> parseFromText(String text) {
    final regex = RegExp(
      r'\[PRODUCT:([^:]+):([^:]+):৳?(\d+):([^:]+):(true|false):([^\]]*)\]',
    );

    return regex.allMatches(text).map((match) {
      return ChatProduct(
        slug: match.group(1)!,
        name: match.group(2)!,
        price: double.tryParse(match.group(3)!) ?? 0,
        category: match.group(4)!,
        inStock: match.group(5) == 'true',
        imageUrl: match.group(6)?.isNotEmpty == true ? match.group(6) : null,
      );
    }).toList();
  }
}

/// Content segment type for interleaving text and products
sealed class ChatContentSegment {}

class TextSegment extends ChatContentSegment {
  final String content;
  TextSegment(this.content);
}

class ProductSegment extends ChatContentSegment {
  final ChatProduct product;
  ProductSegment(this.product);
}

/// Parse message content into segments (text and products interleaved)
List<ChatContentSegment> parseMessageContent(String text) {
  final regex = RegExp(
    r'\[PRODUCT:([^:]+):([^:]+):৳?(\d+):([^:]+):(true|false):([^\]]*)\]',
  );

  final segments = <ChatContentSegment>[];
  var lastIndex = 0;

  for (final match in regex.allMatches(text)) {
    // Add text before this product
    if (match.start > lastIndex) {
      final textBefore = text
          .substring(lastIndex, match.start)
          .replaceAll(RegExp(r'^\s*\*\s*$', multiLine: true), '')
          .replaceAll(RegExp(r'^\s*[-*]\s*$', multiLine: true), '')
          .replaceAll(RegExp(r'\*{2,}'), '')
          .replaceAll(RegExp(r'\n{3,}'), '\n\n')
          .trim();

      if (textBefore.isNotEmpty) {
        segments.add(TextSegment(textBefore));
      }
    }

    // Add the product
    final product = ChatProduct(
      slug: match.group(1)!,
      name: match.group(2)!,
      price: double.tryParse(match.group(3)!) ?? 0,
      category: match.group(4)!,
      inStock: match.group(5) == 'true',
      imageUrl: match.group(6)?.isNotEmpty == true ? match.group(6) : null,
    );
    segments.add(ProductSegment(product));

    lastIndex = match.end;
  }

  // Add remaining text after last product
  if (lastIndex < text.length) {
    final remaining = text
        .substring(lastIndex)
        .replaceAll(RegExp(r'\[PRODUCT:[^\]]+\]'), '')
        .replaceAll(RegExp(r'^\s*\*\s*$', multiLine: true), '')
        .replaceAll(RegExp(r'^\s*[-*]\s*$', multiLine: true), '')
        .replaceAll(RegExp(r'\*{2,}'), '')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .replaceAll(RegExp(r'^\n+'), '')
        .replaceAll(RegExp(r'\n+$'), '')
        .trim();

    if (remaining.isNotEmpty) {
      segments.add(TextSegment(remaining));
    }
  }

  return segments;
}
