import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/data/api.dart';
import 'package:news/data/preferences.dart';
import 'package:news/models/models.dart';
import 'package:news/utils.dart';

final StoreToken newsStoreToken = StoreToken(NewsStore());

class Category {
  List<Article> _articles = [];
  List<Article> get articles => List<Article>.unmodifiable(_articles);
  
  int _page;

  bool _hasMore = true;
  bool get hasMore => _hasMore;
  
  bool _hasError = true;
  bool get hasError => _hasError;

  String _error = '';
  String get error => _error;

  bool _loadingFirst = true;
  bool get loadingFirst => _loadingFirst;
}

class NewsStore extends Store {
  Map<String, Category> _categoriesMap = {};
  
  List<Article> _searchResultArticles = [];
  List<Article> get searchResultArticles => List<Article>.unmodifiable(_searchResultArticles);

  int _searchResultPage;
  String _searchQuery;

  bool _searchResultHasMore = true;
  bool get searchResultHasMore => _searchResultHasMore;

  bool _searchLoadingFirst = true;
  bool get searchLoadingFirst => _searchLoadingFirst;

  NewsStore() {
    triggerOnAction(loadNewsAction, (category) async {
      if (getCategory(category)._articles.isEmpty) {
        reloadNewsAction.call(category);
      }
    });

    triggerOnAction(reloadNewsAction, (category) async {
      getCategory(category)._articles.clear();

      getCategory(category)._page = 1;
      await _loadNews(category);
    });
    
    triggerOnAction(loadMoreNewsAction, (category) async {
      getCategory(category)._page++;
      await _loadNews(category);
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
  
  Category getCategory(String category) {
    if (!_categoriesMap.containsKey(category)) {
      _categoriesMap[category] = new Category();
    }
    return _categoriesMap[category];
  }

  Future _loadNews(String category) async {
    getCategory(category)._hasError = false;
    getCategory(category)._error = '';

    String country = await Preferences.internal().readSelectedCountry();

    if (country == null || country.isEmpty) {
      country = await getCountryCode();
    }

    NewsResponse newsResponse = await Api.internal().fetchArticles(getCategory(category)._page, country, category);

    if (newsResponse.success) {
      getCategory(category)._hasMore = newsResponse.articles.isNotEmpty;
      getCategory(category)._articles.addAll(newsResponse.articles);
      getCategory(category)._loadingFirst = false;
    } else {
      getCategory(category)._hasError = true;
      getCategory(category)._error = newsResponse.error;
      getCategory(category)._hasMore = false;
      getCategory(category)._loadingFirst = false;
    }
  }

  Future _searchNews(String query) async {
    List<Article> articles = await Api.internal().searchArticles(query, _searchResultPage);

    _searchResultHasMore = articles.isNotEmpty;
    _searchResultArticles.addAll(articles);
    _searchLoadingFirst = false;
  }
}