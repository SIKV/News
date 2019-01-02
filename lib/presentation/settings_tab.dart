import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/stores/search_history_store.dart';
import 'package:news/stores/settings_store.dart';

class SettingsTab extends StatefulWidget {
  @override
  SettingsTabState createState() {
    return new SettingsTabState();
  }
}

class SettingsTabState extends State<SettingsTab> with StoreWatcherMixin<SettingsTab> {
  SettingsStore settingsStore;
  SearchHistoryStore searchHistoryStore;

  @override
  void initState() {
    settingsStore = listenToStore(settingsStoreToken);
    searchHistoryStore = listenToStore(searchHistoryStoreToken);

    loadCountriesListAction.call();
    loadCategoriesListAction.call();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text('Settings'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Stack(
            children: <Widget>[
              settingsStore.loaded ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Country',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800
                    ),
                  ),
                  Container(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                      value: settingsStore.currentCountry,
                      items: settingsStore.countriesDropdownItems,
                      onChanged: (value) {
                        setCurrentCountryAction.call(value);
                      },
                    ),
                  ),
                  Container(
                    height: 24,
                  ),
                  Text(
                    'Category',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800
                    ),
                  ),
                  Container(
                    height: 8,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: DropdownButton(
                      value: settingsStore.currentCategory,
                      items: settingsStore.categoriesDropdownItems,
                      onChanged: (value) {
                        setCurrentCategoryAction.call(value);
                      },
                    ),
                  ),
                  Container(
                    height: 24,
                  ),
                  Text(
                    'Search History',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800
                    ),
                  ),
                  Container(
                    height: 8,
                  ),
                  Builder(
                    builder: (context) => FlatButton(
                      child: Text(
                        'Clear Search History',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 15
                        ),
                      ),
                      onPressed: () {
                        clearSearchHistoryAction.call().then((_) {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Search History cleared.'),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    undoClearSearchHistoryAction.call();
                                  },
                                ),
                              )
                          );
                        });
                      },
                      textColor: Theme.of(context).accentColor,
                      color: Colors.grey.shade50,
                    ),
                  ),
                ],
              ) : Container(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  'Powered by NewsAPI.org',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.normal
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}