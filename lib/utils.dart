import 'package:intl/intl.dart';
import "package:intl/intl_standalone.dart";

Future<String> getSystemLocale() async {
  return await findSystemLocale();
}

Future<String> getCountryCode() async {
  String locale = await findSystemLocale();
  return Future.value(locale.substring(locale.indexOf('_') + 1));
}

String formatDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  DateTime now = DateTime.now();

  String pattern = '';

  if (dateTime.day == now.day && dateTime.month == now.month && dateTime.year == now.year) {
    pattern = 'hh:mm a';
  } else {
    pattern = 'MM/dd/yy hh:mm a';
  }

  return DateFormat(pattern, 'en_US').format(dateTime);
}