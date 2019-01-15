import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/data/saved_repository.dart';
import 'package:news/message_notifier.dart';
import 'package:news/models/models.dart';

final StoreToken savedArticlesStoreToken = StoreToken(SavedArticlesStore());

class SavedArticlesStore extends Store {
  List<SavedArticle> _savedArticles = [];
  List<SavedArticle> get savedArticles => List<SavedArticle>.unmodifiable(_savedArticles);

  SavedArticlesStore() {
    triggerOnAction(loadSavedArticlesAction, (_) async {
      _savedArticles = await SavedRepository.internal().getAll();
    });

    triggerOnAction(saveArticleAction, (article) async {
      SavedArticle savedArticle = article.toSavedArticle();

      SavedRepository.internal().insert(savedArticle);
      _savedArticles.add(savedArticle);

      messageNotifier.post('Saved');
    });

    triggerOnAction(clearSavedArticlesAction, (_) async {
      SavedRepository.internal().removeAll();
      _savedArticles.clear();
    });

    triggerOnAction(removeSavedArticleAction, (savedArticle) async {
      SavedRepository.internal().remove(savedArticle);
      _savedArticles.remove(savedArticle);
    });
  }
}