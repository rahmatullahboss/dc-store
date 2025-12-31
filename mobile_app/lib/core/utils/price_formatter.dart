import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/currency_provider.dart';

/// Price formatting utility that uses the selected currency
class PriceFormatter {
  final Currency currency;

  const PriceFormatter(this.currency);

  /// Format a price with the current currency symbol
  String format(double price) {
    return '${currency.symbol}${price.toStringAsFixed(2)}';
  }

  /// Format a price without decimals
  String formatWhole(double price) {
    return '${currency.symbol}${price.toStringAsFixed(0)}';
  }

  /// Get just the currency symbol
  String get symbol => currency.symbol;
}

/// Provider for the price formatter
final priceFormatterProvider = Provider<PriceFormatter>((ref) {
  final currency = ref.watch(currencyProvider);
  return PriceFormatter(currency);
});
