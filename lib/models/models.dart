class NewsResponse {
  final String status;
  final bool success;
  final String error;
  final int totalResults;
  final List<Article> articles;

  NewsResponse({this.status, this.success, this.error, this.totalResults, this.articles});

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    List<Article> articles = new List<Article>();

    json["articles"].forEach((v) {
      articles.add(new Article.fromJson(v));
    });

    return NewsResponse(
      status: json['status'],
      success: true,
      error: null,
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

  bool hasImage() {
    return urlToImage != null && urlToImage.isNotEmpty;
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

class NameValue {
  final String name;
  final String value;

  NameValue({this.name, this.value});

  factory NameValue.fromJson(Map<String, dynamic> json) {
    return NameValue(
        name: json['name'],
        value: json['value']
    );
  }
}