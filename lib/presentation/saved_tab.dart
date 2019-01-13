import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/stores/saved_articles_store.dart';

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
              return ListTile(
                title: Text(savedArticlesStore.savedArticles[i].title)
              );
            }
        )
    );
  }
}