import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/data/api.dart';
import 'package:news/models/models.dart';

final StoreToken newsStoreToken = StoreToken(NewsStore());

class NewsStore extends Store {
  List<Article> _articles = [];
  List<Article> get articles => List<Article>.unmodifiable(_articles);

  int _page;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  bool _loadingFirst = true;
  bool get loadingFirst => _loadingFirst;

  List<Article> _searchResultArticles = [];
  List<Article> get searchResultArticles => List<Article>.unmodifiable(_searchResultArticles);

  int _searchResultPage;
  String _searchQuery;

  bool _searchResultHasMore = true;
  bool get searchResultHasMore => _searchResultHasMore;

  bool _searchLoadingFirst = true;
  bool get searchLoadingFirst => _searchLoadingFirst;

  NewsStore() {
    triggerOnAction(loadNewsAction, (_) async {
      _articles.clear();

      _page = 1;
      await _loadNews();
    });
    
    triggerOnAction(loadMoreNewsAction, (_) async {
      _page++;
      await _loadNews();
    });

    triggerOnAction(searchNewsAction, (query) async {
      _searchResultArticles.clear();
      _searchLoadingFirst = true;
      _searchQuery = query;

      _searchResultPage = 1;
      await _searchNews(query);
    });

    triggerOnAction(searchMoreNewsAction, (_) async {
      _searchResultPage++;
      await _searchNews(_searchQuery);
    });
  }

  Future _loadNews() async {
    List<Article> articles = await Api.internal().fetchArticles(_page);

    _hasMore = articles.isNotEmpty;
    _articles.addAll(articles);
    _loadingFirst = false;
  }

  Future _searchNews(String query) async {
    List<Article> articles = await Api.internal().searchArticles(query, _searchResultPage);

    _searchResultHasMore = articles.isNotEmpty;
    _searchResultArticles.addAll(articles);
    _searchLoadingFirst = false;
  }
}