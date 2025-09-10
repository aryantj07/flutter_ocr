import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllergenProvider with ChangeNotifier {
  List<String> _selectedAllergens = [];

  List<String> get selectedAllergens => _selectedAllergens;

  AllergenProvider() {
    _loadAllergens();
  }

  void _loadAllergens() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedAllergens = prefs.getStringList('allergens') ?? [];
    notifyListeners();
  }

  void addAllergen(String allergen) async {
    if (!_selectedAllergens.contains(allergen)) {
      _selectedAllergens.add(allergen);
      await _saveAllergens();
    }
    notifyListeners();
  }

  void removeAllergen(String allergen) async {
    _selectedAllergens.remove(allergen);
    await _saveAllergens();
    notifyListeners();
  }

  Future<void> _saveAllergens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('allergens', _selectedAllergens);
  }

  bool isAllergenSelected(String allergen) {
    return _selectedAllergens.contains(allergen);
  }
}