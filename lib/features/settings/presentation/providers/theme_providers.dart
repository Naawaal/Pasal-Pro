import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pasal_pro/features/settings/presentation/providers/settings_providers.dart';

/// Convert app theme mode string to Flutter ThemeMode
ThemeMode _stringToThemeMode(String mode) {
  return switch (mode) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system, // default to system
  };
}

/// Provides the current theme mode as a Flutter ThemeMode
final appThemeModeProvider = Provider<ThemeMode>((ref) {
  final settingsAsync = ref.watch(settingsNotifierProvider);

  return settingsAsync.maybeWhen(
    data: (settings) => _stringToThemeMode(settings.themeMode),
    orElse: () => ThemeMode.system,
  );
});
