import 'package:flutter/material.dart';
import 'package:toolbox/repositories/preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  String get themeValue => themeMode.toString().split('.').last;

  final Map themeModes = {
    'dark': 'ThemeMode.dark',
    'light': 'ThemeMode.light',
    'system': 'ThemeMode.system'
  };
  final List<String> themes = ['dark', 'light', 'system'];

  set themeValue(value) => setTheme(value);

  ThemeProvider() {
    loadTheme();
  }

  Future<void> loadTheme() async {
    final themeString = await Preferences.themeMode;

    _themeMode = switch (themeString) {
      'ThemeMode.dark' => ThemeMode.dark,
      'ThemeMode.light' => ThemeMode.light,
      _ => ThemeMode.system
    };

    notifyListeners();
  }

  ThemeMode themeModeFromValue(String value) => switch (value) {
        'ThemeMode.dark' => ThemeMode.dark,
        'ThemeMode.light' => ThemeMode.light,
        _ => ThemeMode.system
      };

  Future<void> setTheme(ThemeMode themeMode) async {
    _themeMode = themeMode;
    Preferences.setThemeMode(themeMode.toString());
    notifyListeners();
  }

  setThemeValue(String value) =>
      setTheme(themeModeFromValue(themeModes[value]));
}
