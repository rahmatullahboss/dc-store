import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Language model representing supported languages
class Language {
  final String code;
  final String name;
  final String flag;
  final Locale locale;

  const Language({
    required this.code,
    required this.name,
    required this.flag,
    required this.locale,
  });

  /// English (US)
  static const Language english = Language(
    code: 'en',
    name: 'English (US)',
    flag: '🇺🇸',
    locale: Locale('en'),
  );

  /// Bengali
  static const Language bengali = Language(
    code: 'bn',
    name: 'বাংলা (Bengali)',
    flag: '🇧🇩',
    locale: Locale('bn'),
  );

  /// List of all supported languages
  static const List<Language> supportedLanguages = [english, bengali];

  /// Get language by code
  static Language fromCode(String code) {
    return supportedLanguages.firstWhere(
      (l) => l.code == code,
      orElse: () => english,
    );
  }

  /// Get display text for settings tile
  String get displayText => name;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Language && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}

/// Locale provider using Notifier pattern (Riverpod 2.0+)
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  LocaleNotifier.new,
);

/// Selected language provider for UI display
final selectedLanguageProvider = Provider<Language>((ref) {
  final locale = ref.watch(localeProvider);
  return Language.supportedLanguages.firstWhere(
    (l) => l.locale.languageCode == locale.languageCode,
    orElse: () => Language.english,
  );
});

class LocaleNotifier extends Notifier<Locale> {
  static const _key = 'locale_code';

  @override
  Locale build() {
    _loadLocale();
    return const Locale('en'); // Default to English
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code != null) {
      state = Locale(code);
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }

  Future<void> setLanguage(Language language) async {
    await setLocale(language.locale);
  }
}
