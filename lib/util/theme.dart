import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFFFFFF),
    accentColor: Colors.blueAccent,
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    appBarTheme: const AppBarTheme(
        color: Color(0xFFFFFFFF),
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF000000)),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000))),
    cardTheme: const CardTheme(
      elevation: 0,
      color: Color(0xFFE7E7E7),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFFF0F0F0),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.blueAccent, elevation: 1),
    bottomAppBarColor: const Color(0xFFFFFFFF),
    accentTextTheme: const TextTheme(
        headline1: TextStyle(
          color: Colors.blueAccent,
        ),
        headline2: TextStyle(
          color: Color(0xFFE0E0E0),
        )),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: Colors.deepPurple),
      selectedLabelStyle: TextStyle(color: Colors.deepPurple),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Color(0xFFE5E5E5),
    ),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Color(0xFFFFFFFF)));

ThemeData dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF1A1A1F),
    accentColor: Colors.blueAccent[100],
    scaffoldBackgroundColor: const Color(0xFF1A1A1F),
    appBarTheme: const AppBarTheme(
        color: Color(0xFF1A1A1F),
        elevation: 0,
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFFFFFF))),
    cardTheme: const CardTheme(
      elevation: 0,
      color: Color(0xFF2A2A2F),
    ),
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF1A1A1F),
    ),
    accentTextTheme: TextTheme(
        headline1: TextStyle(
          color: Colors.blueAccent[100],
          backgroundColor: const Color(0xFFFFFFFF),
        ),
        headline2: TextStyle(
          color: Colors.grey[850],
        )),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(color: Colors.blueAccent),
      selectedLabelStyle: TextStyle(color: Colors.blueAccent),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      backgroundColor: Color(0xFF151517),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.blueAccent[100], elevation: 1),
    bottomAppBarColor: const Color(0xFF1A1A1F),
    bottomSheetTheme:
        const BottomSheetThemeData(modalBackgroundColor: Color(0xFF1A1A1F)));

class ThemeNotifier extends ChangeNotifier {
  final String key = 'valorTema';
  SharedPreferences prefs;
  bool _darkTheme;

  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = true;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    prefs.setBool(key, _darkTheme);
  }
}
