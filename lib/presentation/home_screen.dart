import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/presentation/headlines_tab.dart';
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
            icon: Icon(Icons.language, color: Colors.black26),
            activeIcon: Icon(Icons.language, color: Colors.lightBlue),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.black26),
            activeIcon: Icon(Icons.search, color: Colors.lightBlue),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border, color: Colors.black26),
            activeIcon: Icon(Icons.bookmark_border, color: Colors.lightBlue),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.black26),
            activeIcon: Icon(Icons.settings, color: Colors.lightBlue),
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (BuildContext context) {
                return HeadlinesTab();
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