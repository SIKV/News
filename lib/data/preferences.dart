import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Preferences _instance = Preferences.internal();
  Preferences.internal();
  factory Preferences() => _instance;

  void saveSelectedCountry(String country) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('country', country);
  }

  Future<String> readSelectedCountry() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('country') ?? '';
  }

  void saveSearchHistory(List<String> searchHistoryList) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('search_history', searchHistoryList);
  }

  Future<List<String>> readSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('search_history') ?? [];
  }
}