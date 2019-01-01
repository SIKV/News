import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/data/preferences.dart';

final StoreToken searchHistoryStoreToken = StoreToken(SearchHistoryStore());

class SearchHistoryStore extends Store {
  Set<String> _searchHistory = Set();
  List<String> get searchHistory => List<String>.unmodifiable(_searchHistory.toList());

  SearchHistoryStore() {
    triggerOnAction(loadSearchHistoryAction, (_) async {
      List<String> searchHistoryList = await Preferences.internal().readSearchHistory();
      _searchHistory = searchHistoryList.toSet();
    });

    triggerOnAction(addSearchValueAction, (value) async {
      _searchHistory.add(value);
      Preferences.internal().saveSearchHistory(searchHistory);
    });
  }
}