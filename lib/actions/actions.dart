import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/models/models.dart';

final Action<String> loadNewsAction = Action();
final Action<String> reloadNewsAction = Action();
final Action<String> loadMoreNewsAction = Action();

final Action<String> searchNewsAction = Action();
final Action searchMoreNewsAction = Action();

final Action loadSearchHistoryAction = Action();
final Action<String> addSearchValueAction = Action();
final Action clearSearchHistoryAction = Action();
final Action undoClearSearchHistoryAction = Action();

final Action loadCountriesListAction = Action();
final Action<String> setCurrentCountryAction = Action();

final Action loadSavedArticlesAction = Action();
final Action<Article> saveArticleAction = Action();
final Action clearSavedArticlesAction = Action();
final Action<SavedArticle> removeSavedArticleAction = Action();
final Action undoRemoveSavedArticleAction = Action();
