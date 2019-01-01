import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/data/preferences.dart';

final StoreToken searchHistoryStoreToken = StoreToken(SearchHistoryStore());

class SearchHistoryStore extends Store {
  Set<String> _searchHistory = Set();
  List<String> get searchHistory => List<String>.unmodifiable(_searchHistory.toList());

  Set<String> _clearedSearchHistory = Set();

  SearchHistoryStore() {
    triggerOnAction(loadSearchHistoryAction, (_) async {
      List<String> searchHistoryList = await Preferences.internal().readSearchHistory();
      _searchHistory = searchHistoryList.toSet();
    });

    triggerOnAction(addSearchValueAction, (value) async {
      _searchHistory.add(value);
      Preferences.internal().saveSearchHistory(searchHistory);
    });

    triggerOnAction(clearSearchHistoryAction, (_) async {
      _clearedSearchHistory = Set.of(_searchHistory);
      _searchHistory.clear();

      Preferences.internal().saveSearchHistory([]);
    });

    triggerOnAction(undoClearSearchHistoryAction, (_) async {
      _searchHistory = Set.of(_clearedSearchHistory);
      _clearedSearchHistory.clear();

      Preferences.internal().saveSearchHistory(searchHistory);
    });
  }
}