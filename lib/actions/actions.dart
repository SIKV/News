import 'package:flutter_flux/flutter_flux.dart';

final Action loadNewsAction = Action();
final Action loadMoreNewsAction = Action();

final Action<String> searchNewsAction = Action();
final Action searchMoreNewsAction = Action();

final Action loadSearchHistoryAction = Action();
final Action<String> addSearchValueAction = Action();
final Action clearSearchHistoryAction = Action();
final Action undoClearSearchHistoryAction = Action();

final Action loadCountriesListAction = Action();
final Action<String> setCurrentCountryAction = Action();
final Action loadCategoriesListAction = Action();
final Action<String> setCurrentCategoryAction = Action();