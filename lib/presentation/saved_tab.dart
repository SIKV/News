import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/models/models.dart';
import 'package:news/stores/saved_articles_store.dart';
import 'package:url_launcher/url_launcher.dart';

class SavedTab extends StatefulWidget {
  @override
  _SavedTabState createState() {
    return new _SavedTabState();
  }
}

class _SavedTabState extends State<SavedTab> with StoreWatcherMixin<SavedTab> {
  SavedArticlesStore savedArticlesStore;

  @override
  void initState() {
    savedArticlesStore = listenToStore(savedArticlesStoreToken);

    loadSavedArticlesAction.call();

    super.initState();
  }

  void _openArticle(SavedArticle article) async {
    if (await canLaunch(article.url)) {
      await launch(article.url);
    } else {
      throw 'Could not launch ${article.url}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Saved'),
          centerTitle: true,
          elevation: 0.5,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () {
                clearSavedArticlesAction.call();
              },
            )
          ],
        ),
        body: _savedArticlesList()
    );
  }

  Widget _savedArticlesList() {
    return Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.white),
        child: ListView.builder(
            itemCount: savedArticlesStore.savedArticles.length,
            itemBuilder: (context, i) {

              SavedArticle article = savedArticlesStore.savedArticles[i];

              return ListTile(
                contentPadding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
                title: Text(
                  article.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    article.sourceName,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(
                    Icons.clear,
                    size: 18,
                  ),
                  onPressed: () {
                    removeSavedArticleAction.call(article);
                  },
                ),
                onTap: () {
                  _openArticle(article);
                },
              );
            }
        )
    );
  }
}