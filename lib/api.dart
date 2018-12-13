import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:news/models.dart';

class Api {
  static Api _instance = new Api.internal();
  Api.internal();
  factory Api() => _instance;

  Future<List<Article>> fetchArticles() async {
    final Secret secret = await SecretLoader(secretPath: 'secrets.json').load();
    final response = await http.get('https://newsapi.org/v2/top-headlines?country=us&apiKey=${secret.apiKey}');

    if (response.statusCode == 200) {
      return NewsResponse.fromJson(json.decode(response.body)).articles;
    } else {
      throw Exception('Failed');
    }
  }
}

class Secret {
  final String apiKey;

  Secret({this.apiKey = ''});

  factory Secret.fromJson(Map<String, dynamic> json) {
    return new Secret(apiKey: json['api_key']);
  }
}

class SecretLoader {
  final String secretPath;

  SecretLoader({this.secretPath});

  Future<Secret> load() {
    return rootBundle.loadStructuredData<Secret>(this.secretPath, (jsonStr) async {
      final secret = Secret.fromJson(json.decode(jsonStr));
      return secret;
    });
  }
}