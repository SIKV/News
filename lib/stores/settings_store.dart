import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:news/actions/actions.dart';
import 'package:news/data/preferences.dart';
import 'package:news/models/models.dart';

final StoreToken settingsStoreToken = StoreToken(SettingsStore());

class SettingsStore extends Store {
  Map<String, String> _countries = {};
  Map<String, String> _categories = {};

  List<DropdownMenuItem<String>> _countriesDropdownItems = [];
  List<DropdownMenuItem<String>> get countriesDropdownItems => List<DropdownMenuItem<String>>.unmodifiable(_countriesDropdownItems);

  String _currentCountry;
  String get currentCountry => _currentCountry;

  List<DropdownMenuItem<String>> _categoriesDropdownItems = [];
  List<DropdownMenuItem<String>> get categoriesDropdownItems => List<DropdownMenuItem<String>>.unmodifiable(_categoriesDropdownItems);

  String _currentCategory;
  String get currentCategory => _currentCategory;

  bool get loaded => _countries.isNotEmpty && _categories.isNotEmpty;

  SettingsStore() {
    triggerOnAction(loadCountriesListAction, (_) async {
      _loadCountries();
    });

    triggerOnAction(loadCategoriesListAction, (_) async {
      _loadCategories();
    });

    triggerOnAction(setCurrentCountryAction, (value) async {
      _currentCountry = value;
      String currentCountryValue = _countries.keys.firstWhere((k) => _countries[k] == value, orElse: () => null);

      Preferences.internal().saveSelectedCountry(currentCountryValue);
    });

    triggerOnAction(setCurrentCategoryAction, (value) async {
      _currentCategory = value;
      String currentCategoryValue = _categories.keys.firstWhere((k) => _categories[k] == value, orElse: () => null);

      Preferences.internal().saveSelectedCategory(currentCategoryValue);
    });
  }

  void _loadCountries() async {
    await rootBundle.loadStructuredData<List<Map<String, dynamic>>>('countries.json', (jsonStr) async {
      var jsonDecoded = json.decode(jsonStr);

      _countries = {};

      jsonDecoded.forEach((v) {
        NameValue nameValue = NameValue.fromJson(v);
        _countries[nameValue.value] = nameValue.name;
      });
    });

    List<DropdownMenuItem<String>> items = new List();

    _countries.forEach((k, v) => items.add(
        new DropdownMenuItem(
            value: v,
            child: new Text(v)
        ))
    );

    _countriesDropdownItems = items;

    Preferences.internal().readSelectedCountry().then((value) {
      if (value.isNotEmpty) {
        _currentCountry = _countries[value];
      } else {
        _currentCountry = _countriesDropdownItems[0].value;
      }
    });
  }

  void _loadCategories() async {
    await rootBundle.loadStructuredData<List<Map<String, dynamic>>>('categories.json', (jsonStr) async {
      var jsonDecoded = json.decode(jsonStr);

      _categories = {};

      jsonDecoded.forEach((v) {
        NameValue nameValue = NameValue.fromJson(v);
        _categories[nameValue.value] = nameValue.name;
      });
    });

    List<DropdownMenuItem<String>> items = new List();

    _categories.forEach((k, v) => items.add(
        new DropdownMenuItem(
            value: v,
            child: new Text(v)
        ))
    );

    _categoriesDropdownItems = items;

    Preferences.internal().readSelectedCategory().then((value) {
      if (value.isNotEmpty) {
        _currentCategory = _categories[value];
      } else {
        _currentCategory = _categoriesDropdownItems[0].value;
      }
    });
  }
}