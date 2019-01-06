import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/presentation/news_tab.dart';

class HeadlinesTab extends StatefulWidget {
  @override
  _HeadlinesTabState createState() => _HeadlinesTabState();
}

class _HeadlinesTabState extends State<HeadlinesTab> with StoreWatcherMixin<HeadlinesTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Headlines'),
          centerTitle: true,
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Business'),
              Tab(text: 'Entertainment'),
              Tab(text: 'General'),
              Tab(text: 'Health'),
              Tab(text: 'Science'),
              Tab(text: 'Sports'),
              Tab(text: 'Technology'),
            ],
          ),
        ),
        backgroundColor: Colors.grey.shade100,
        body: TabBarView(
          children: <Widget>[
            NewsTab(category: 'all'),
            NewsTab(category: 'business'),
            NewsTab(category: 'entertainment'),
            NewsTab(category: 'general'),
            NewsTab(category: 'health'),
            NewsTab(category: 'science'),
            NewsTab(category: 'sports'),
            NewsTab(category: 'technology'),
          ],
        )
      ),
    );
  }
}