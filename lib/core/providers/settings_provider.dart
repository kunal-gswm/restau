import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_prefs_provider.dart';

class SettingsState {
  final ThemeMode themeMode;
  final Locale locale;

  const SettingsState({
    this.themeMode = ThemeMode.light,
    this.locale = const Locale('en', 'US'),
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  static const _themeKey = 'app_theme';
  static const _localeCodeKey = 'app_locale_code';
  static const _localeCountryKey = 'app_locale_country';

  @override
  SettingsState build() {
    final prefs = ref.read(sharedPrefsProvider);
    
    // Load theme
    final themeString = prefs.getString(_themeKey);
    ThemeMode themeMode = ThemeMode.light;
    if (themeString == 'dark') themeMode = ThemeMode.dark;
    
    // Load locale
    final localeCode = prefs.getString(_localeCodeKey);
    final localeCountry = prefs.getString(_localeCountryKey);
    Locale locale = const Locale('en', 'US');
    if (localeCode != null && localeCountry != null) {
      locale = Locale(localeCode, localeCountry);
    }

    return SettingsState(themeMode: themeMode, locale: locale);
  }

  void updateTheme(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    final prefs = ref.read(sharedPrefsProvider);
    prefs.setString(_themeKey, mode == ThemeMode.dark ? 'dark' : 'light');
  }

  void updateLocale(Locale locale) {
    state = state.copyWith(locale: locale);
    final prefs = ref.read(sharedPrefsProvider);
    prefs.setString(_localeCodeKey, locale.languageCode);
    if (locale.countryCode != null) {
      prefs.setString(_localeCountryKey, locale.countryCode!);
    }
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
