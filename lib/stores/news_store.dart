import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/data/api.dart';
import 'package:news/data/preferences.dart';
import 'package:news/models/models.dart';
import 'package:news/utils.dart';

final StoreToken newsStoreToken = StoreToken(NewsStore());

class _Category {
  List<Article> _articles = [];
  int _page;

  bool _hasMore = true;
  bool _hasError = true;

  String _error = '';

  bool _loadingFirst = true;
}

class NewsStore extends Store {
  String _category;
  bool get categoryExists => _category != null && _category.isNotEmpty;

  Map<String, _Category> _categoriesMap = {};
  _Category get _currentCategory => _categoriesMap[_category];

  List<Article> get articles => List<Article>.unmodifiable(_currentCategory._articles);

  bool get hasMore => _currentCategory._hasMore;
  bool get hasError => _currentCategory._hasError;

  String get error => _currentCategory._error;

  bool get loadingFirst => _currentCategory._loadingFirst;

  List<Article> _searchResultArticles = [];
  List<Article> get searchResultArticles => List<Article>.unmodifiable(_searchResultArticles);

  int _searchResultPage;
  String _searchQuery;

  bool _searchResultHasMore = true;
  bool get searchResultHasMore => _searchResultHasMore;

  bool _searchLoadingFirst = true;
  bool get searchLoadingFirst => _searchLoadingFirst;

  NewsStore() {
    triggerOnAction(setCurrentCategoryAction, (category) async {
      _category = category;
      _checkIfCategoryExists(_category);
    });

    triggerOnAction(loadNewsAction, (_) async {
      _currentCategory._articles.clear();
      _currentCategory._loadingFirst = true;

      _currentCategory._page = 1;
      await _loadNews(_category);
    });
    
    triggerOnAction(loadMoreNewsAction, (_) async {
      _currentCategory._page++;
      await _loadNews(_category);
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

  void _checkIfCategoryExists(String category) {
    if (!_categoriesMap.containsKey(category)) {
      _categoriesMap[category] = _Category();
    }
  }

  Future _loadNews(String category) async {
    _currentCategory._hasError = false;
    _currentCategory._error = '';

    String country = await Preferences.internal().readSelectedCountry();

    if (country == null || country.isEmpty) {
      country = await getCountryCode();
    }

    NewsResponse newsResponse = await Api.internal().fetchArticles(_currentCategory._page, country, category);

    if (newsResponse.success) {
      _currentCategory._hasMore = newsResponse.articles.isNotEmpty;
      _currentCategory._articles.addAll(newsResponse.articles);
      _currentCategory._loadingFirst = false;
    } else {
      _currentCategory._hasError = true;
      _currentCategory._error = newsResponse.error;
      _currentCategory._hasMore = false;
      _currentCategory._loadingFirst = false;
    }
  }

  Future _searchNews(String query) async {
    List<Article> articles = await Api.internal().searchArticles(query, _searchResultPage);

    _searchResultHasMore = articles.isNotEmpty;
    _searchResultArticles.addAll(articles);
    _searchLoadingFirst = false;
  }
}