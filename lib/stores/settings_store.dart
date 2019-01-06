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

  List<DropdownMenuItem<String>> _countriesDropdownItems = [];
  List<DropdownMenuItem<String>> get countriesDropdownItems => List<DropdownMenuItem<String>>.unmodifiable(_countriesDropdownItems);

  String _currentCountry;
  String get currentCountry => _currentCountry;

  bool get loaded => _countries.isNotEmpty;

  SettingsStore() {
    triggerOnAction(loadCountriesListAction, (_) async {
      _loadCountries();
    });

    triggerOnAction(setCurrentCountryAction, (value) async {
      _currentCountry = value;
      String currentCountryValue = _countries.keys.firstWhere((k) => _countries[k] == value, orElse: () => null);

      Preferences.internal().saveSelectedCountry(currentCountryValue);
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
}