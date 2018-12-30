import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/data/api.dart';
import 'package:news/models/models.dart';

final StoreToken newsStoreToken = StoreToken(NewsStore());

class NewsStore extends Store {
  List<Article> _articles = [];
  int _page;
  bool _hasMore = true;
  bool _loadingFirst = true;

  List<Article> get articles => List<Article>.unmodifiable(_articles);
  bool get hasMore => _hasMore;
  bool get loadingFirst => _loadingFirst;

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
  }

  Future _loadNews() async {
    List<Article> articles = await Api.internal().fetchArticles(_page);

    _hasMore = articles.isNotEmpty;
    _articles.addAll(articles);
    _loadingFirst = false;
  }
}