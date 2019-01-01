import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/data/api.dart';
import 'package:news/models/models.dart';

final StoreToken searchStoreToken = StoreToken(SearchStore());

class SearchStore extends Store {
  List<Article> _articles = [];
  int _page;
  bool _hasMore = true;
  bool _loadingFirst = true;

  String _query;

  List<Article> get articles => List<Article>.unmodifiable(_articles);
  bool get hasMore => _hasMore;
  bool get loadingFirst => _loadingFirst;

  SearchStore() {
    triggerOnAction(searchNewsAction, (query) async {
      _articles.clear();
      _loadingFirst = true;
      _query = query;

      _page = 1;
      await _searchNews(query);
    });

    triggerOnAction(searchMoreNewsAction, (_) async {
      _page++;
      await _searchNews(_query);
    });
  }

  Future _searchNews(String query) async {
    List<Article> articles = await Api.internal().searchArticles(query, _page);

    _hasMore = articles.isNotEmpty;
    _articles.addAll(articles);
    _loadingFirst = false;
  }
}