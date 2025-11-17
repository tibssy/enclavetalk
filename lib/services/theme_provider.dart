import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _themeModeKey = 'theme_mode';
const String _seedColorKey = 'seed_color';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;
  Color _seedColor = Colors.grey;

  ThemeMode get themeMode => _themeMode;
  Color get seedColor => _seedColor;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  ThemeProvider() {
    _loadPreferences();
  }

  // --- LOADING LOGIC ---
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final themeModeString =
        prefs.getString(_themeModeKey) ?? ThemeMode.dark.toString();
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.toString() == themeModeString,
    );

    final seedColorValue = prefs.getInt(_seedColorKey) ?? Colors.purple.value;
    _seedColor = Color(seedColorValue);

    _isLoading = false;
    notifyListeners();
  }

  // --- SAVING LOGIC ---
  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, _themeMode.toString());
    await prefs.setInt(_seedColorKey, _seedColor.toARGB32());
  }

  // --- PUBLIC METHODS ---
  void changeThemeMode(ThemeMode mode) {
    if (_themeMode == mode) return;
    _themeMode = mode;
    notifyListeners();
    _savePreferences();
  }

  void changeSeedColor(Color color) {
    if (_seedColor.toARGB32() == color.toARGB32()) return;
    _seedColor = color;
    notifyListeners();
    _savePreferences();
  }
}
