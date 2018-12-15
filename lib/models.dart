import 'package:intl/intl.dart';

class NewsResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;

  NewsResponse({this.status, this.totalResults, this.articles});

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    List<Article> articles = new List<Article>();

    json["articles"].forEach((v) {
      articles.add(new Article.fromJson(v));
    });

    return NewsResponse(
      status: json['status'],
      totalResults: json['totalResults'],
      articles: articles
    );
  }
}

class Article {
  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

  Article({this.source, this.author, this.title, this.description,
    this.url, this.urlToImage, this.publishedAt, this.content});

  String getTitle() {
    int indexOf = title.lastIndexOf('-');

    if (indexOf != -1) {
      return title.substring(0, indexOf);
    } else {
      return title;
    }
  }

  String getPublishedAt() {
    DateTime dateTime = DateTime.parse(publishedAt);
    DateTime now = DateTime.now();

    String pattern = '';

    if (dateTime.day == now.day && dateTime.month == now.month && dateTime.year == now.year) {
      pattern = 'hh:mm a';
    } else {
      pattern = 'MM/dd/yy hh:mm a';
    }
    return DateFormat(pattern).format(dateTime);
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      source: Source.fromJson(json['source']),
      author: json['author'],
      title: json['title'],
      description: json['description'] == null ? "" : json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'] == null ? "" : json['urlToImage'],
      publishedAt: json['publishedAt'],
      content: json['content']
    );
  }
}

class Source {
  final String id;
  final String name;

  Source({this.id, this.name});

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      name: json['name'] == null ? "" : json['name']
    );
  }
}