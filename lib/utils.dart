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

  Duration difference = now.difference(dateTime);

  if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours <= 48) {
    return '${difference.inHours}h ago';
  } else {
    return DateFormat('MM/dd/yy hh:mm a', 'en_US').format(dateTime);
  }
}