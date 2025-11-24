import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModelProvider with ChangeNotifier {
  String? _selectedModelId;
  static const String _key = 'selected_model_id';

  String? get selectedModelId => _selectedModelId;

  ModelProvider() {
    _loadSelectedModel();
  }

  Future<void> _loadSelectedModel() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedModelId = prefs.getString(_key);
    notifyListeners();
  }

  Future<void> setSelectedModel(String modelId) async {
    _selectedModelId = modelId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, modelId);
    notifyListeners();
  }
}
