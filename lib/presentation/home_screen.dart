import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/presentation/news_tab.dart';
import 'package:news/presentation/saved_tab.dart';
import 'package:news/presentation/search_tab.dart';
import 'package:news/presentation/settings_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return new CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: Theme.of(context).accentColor,
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.collections)
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search)
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.bookmark)
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gear)
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return NewsTab();
              },
            );
            break;
          case 1:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return SearchTab();
              },
            );
            break;
          case 2:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return SavedTab();
              },
            );
            break;
          case 3:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return SettingsTab();
              },
            );
            break;
        }
        return null;
      },
    );
  }
}