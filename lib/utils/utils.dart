import 'package:intl/intl.dart';

class Utils {
  static String formatToLocalTime(String zuluTime) {
    DateTime dateTime = DateTime.parse(zuluTime);
    DateTime localTime = dateTime.toLocal();
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(localTime);
  }
}
