import 'dart:convert';

import 'package:news/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedRepository {
  static SavedRepository _instance = SavedRepository.internal();
  SavedRepository.internal();
  factory SavedRepository() => _instance;

  void insert(SavedArticle article) async {
    final prefs = await SharedPreferences.getInstance();

    List<String> savedArticles = prefs.getStringList('saved_articles') ?? [];
    savedArticles.add(json.encode(article));

    prefs.setStringList('saved_articles', savedArticles);
  }

  Future<List<SavedArticle>> getAll() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> savedArticlesJson = prefs.getStringList('saved_articles') ?? [];
    List<SavedArticle> savedArticles = [];

    savedArticlesJson.forEach((articleJson) {
      savedArticles.add(SavedArticle.fromJson(json.decode(articleJson)));
    });

    return savedArticles;
  }

  void deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('saved_articles');
  }
}