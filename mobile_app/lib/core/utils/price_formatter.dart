import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/currency_provider.dart';

/// Price formatting utility that uses the selected currency with conversion
class PriceFormatter {
  final Currency currency;

  const PriceFormatter(this.currency);

  /// Format a price (in BDT) with conversion to current currency
  String format(double priceInBDT) {
    final converted = currency.convert(priceInBDT);
    return '${currency.symbol}${converted.toStringAsFixed(2)}';
  }

  /// Format a price without decimals
  String formatWhole(double priceInBDT) {
    final converted = currency.convert(priceInBDT);
    return '${currency.symbol}${converted.toStringAsFixed(0)}';
  }

  /// Convert price from BDT to current currency (for calculations)
  double convert(double priceInBDT) {
    return currency.convert(priceInBDT);
  }

  /// Get just the currency symbol
  String get symbol => currency.symbol;

  /// Get currency code for Stripe and APIs
  String get code => currency.code;
}

/// Provider for the price formatter
final priceFormatterProvider = Provider<PriceFormatter>((ref) {
  final currency = ref.watch(currencyProvider);
  return PriceFormatter(currency);
});
