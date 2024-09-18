import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _notificationsEnabled = true;
  bool _darkTheme = false;
  double _fontSize = 16.0;
  Locale _locale = Locale('en', '');

  bool get notificationsEnabled => _notificationsEnabled;
  bool get darkTheme => _darkTheme;
  double get fontSize => _fontSize;
  Locale get locale => _locale;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    _darkTheme = prefs.getBool('darkTheme') ?? false;
    _fontSize = prefs.getDouble('fontSize') ?? 16.0;
    String localeCode = prefs.getString('localeCode') ?? 'en';
    _locale = Locale(localeCode, '');
    notifyListeners();
  }

  Future<void> toggleNotifications(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = value;
    await prefs.setBool('notificationsEnabled', value);
    notifyListeners();
  }

  Future<void> toggleDarkTheme(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    _darkTheme = value;
    await prefs.setBool('darkTheme', value);
    notifyListeners();
  }

  Future<void> setFontSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    _fontSize = value;
    await prefs.setDouble('fontSize', value);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    _locale = locale;
    await prefs.setString('localeCode', locale.languageCode);
    notifyListeners();
  }

  ThemeData get themeData {
    return ThemeData(
      brightness: _darkTheme ? Brightness.dark : Brightness.light,
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: _fontSize),
        bodyMedium: TextStyle(fontSize: _fontSize),
      ),
    );
  }
}



