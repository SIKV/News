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

  void saveSelectedCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('category', category);
  }

  Future<String> readSelectedCategory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('category') ?? '';
  }
}