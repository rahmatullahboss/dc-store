import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App Settings State
class AppSettings {
  final String language;
  final String languageCode;
  final String currency;
  final String currencySymbol;

  const AppSettings({
    required this.language,
    required this.languageCode,
    required this.currency,
    required this.currencySymbol,
  });

  factory AppSettings.defaults() => const AppSettings(
    language: 'English (US)',
    languageCode: 'en',
    currency: 'BDT',
    currencySymbol: '৳',
  );

  AppSettings copyWith({
    String? language,
    String? languageCode,
    String? currency,
    String? currencySymbol,
  }) {
    return AppSettings(
      language: language ?? this.language,
      languageCode: languageCode ?? this.languageCode,
      currency: currency ?? this.currency,
      currencySymbol: currencySymbol ?? this.currencySymbol,
    );
  }
}

/// Language option model
class LanguageOption {
  final String name;
  final String code;
  final String nativeName;

  const LanguageOption({
    required this.name,
    required this.code,
    required this.nativeName,
  });
}

/// Currency option model
class CurrencyOption {
  final String code;
  final String symbol;
  final String name;

  const CurrencyOption({
    required this.code,
    required this.symbol,
    required this.name,
  });
}

/// Available languages
const availableLanguages = [
  LanguageOption(name: 'English (US)', code: 'en', nativeName: 'English'),
  LanguageOption(name: 'English (UK)', code: 'en-GB', nativeName: 'English'),
  LanguageOption(name: 'বাংলা', code: 'bn', nativeName: 'Bengali'),
  LanguageOption(name: 'हिंदी', code: 'hi', nativeName: 'Hindi'),
  LanguageOption(name: 'العربية', code: 'ar', nativeName: 'Arabic'),
];

/// Available currencies
const availableCurrencies = [
  CurrencyOption(code: 'BDT', symbol: '৳', name: 'Bangladeshi Taka'),
  CurrencyOption(code: 'USD', symbol: '\$', name: 'US Dollar'),
  CurrencyOption(code: 'EUR', symbol: '€', name: 'Euro'),
  CurrencyOption(code: 'GBP', symbol: '£', name: 'British Pound'),
  CurrencyOption(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
];

/// Settings Provider
final settingsProvider = NotifierProvider<SettingsNotifier, AppSettings>(
  SettingsNotifier.new,
);

class SettingsNotifier extends Notifier<AppSettings> {
  static const _languageKey = 'app_language';
  static const _languageCodeKey = 'app_language_code';
  static const _currencyKey = 'app_currency';
  static const _currencySymbolKey = 'app_currency_symbol';

  @override
  AppSettings build() {
    _loadSettings();
    return AppSettings.defaults();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString(_languageKey);
    final languageCode = prefs.getString(_languageCodeKey);
    final currency = prefs.getString(_currencyKey);
    final currencySymbol = prefs.getString(_currencySymbolKey);

    if (language != null) {
      state = state.copyWith(
        language: language,
        languageCode: languageCode ?? 'en',
        currency: currency ?? 'BDT',
        currencySymbol: currencySymbol ?? '৳',
      );
    }
  }

  Future<void> setLanguage(LanguageOption option) async {
    state = state.copyWith(language: option.name, languageCode: option.code);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, option.name);
    await prefs.setString(_languageCodeKey, option.code);
  }

  Future<void> setCurrency(CurrencyOption option) async {
    state = state.copyWith(
      currency: option.code,
      currencySymbol: option.symbol,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currencyKey, option.code);
    await prefs.setString(_currencySymbolKey, option.symbol);
  }
}
