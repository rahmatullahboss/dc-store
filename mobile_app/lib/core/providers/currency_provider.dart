import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Currency model representing supported currencies
class Currency {
  final String code;
  final String name;
  final String symbol;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
  });

  /// Default currency (BDT)
  static const Currency bdt = Currency(
    code: 'BDT',
    name: 'Bangladeshi Taka (৳)',
    symbol: '৳',
  );

  /// USD currency
  static const Currency usd = Currency(
    code: 'USD',
    name: 'US Dollar (\$)',
    symbol: '\$',
  );

  /// List of all supported currencies
  static const List<Currency> supportedCurrencies = [bdt, usd];

  /// Get currency by code
  static Currency fromCode(String code) {
    return supportedCurrencies.firstWhere(
      (c) => c.code == code,
      orElse: () => bdt,
    );
  }

  /// Get display text for settings tile
  String get displayText => '$code ($symbol)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Currency && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}

/// Currency provider using Notifier pattern (Riverpod 2.0+)
final currencyProvider = NotifierProvider<CurrencyNotifier, Currency>(
  CurrencyNotifier.new,
);

class CurrencyNotifier extends Notifier<Currency> {
  static const _key = 'currency_code';

  @override
  Currency build() {
    // Use microtask to ensure async loading happens after build
    Future.microtask(() => _loadCurrency());
    return Currency.bdt; // Default to BDT
  }

  Future<void> _loadCurrency() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null && code != state.code) {
      state = Currency.fromCode(code);
    }
  }

  Future<void> setCurrency(Currency currency) async {
    state = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, currency.code);
  }
}
