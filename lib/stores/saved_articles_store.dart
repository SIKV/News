import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/data/saved_repository.dart';
import 'package:news/models/models.dart';

final StoreToken savedArticlesStoreToken = StoreToken(SavedArticlesStore());

class SavedArticlesStore extends Store {
  List<SavedArticle> _savedArticles = [];
  List<SavedArticle> get savedArticles => List<SavedArticle>.unmodifiable(_savedArticles);

  SavedArticlesStore() {
    triggerOnAction(loadSavedArticles, (_) async {
      _savedArticles = await SavedRepository.internal().getAll();
    });
  }
}