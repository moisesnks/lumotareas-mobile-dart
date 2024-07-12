import 'package:intl/intl.dart';

class Utils {
  static String formatToLocalTime(String zuluTime) {
    DateTime dateTime = DateTime.parse(zuluTime);
    DateTime localTime = dateTime.toLocal();

    // Obtener la diferencia en horas y minutos
    Duration difference = DateTime.now().difference(localTime);
    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);

    // Verificar si la diferencia es menor que 12 horas
    if (hours < 12) {
      if (hours == 0 && minutes == 0) {
        return 'Hace menos de un minuto';
      } else if (hours == 0) {
        return 'Hace $minutes minuto${minutes != 1 ? 's' : ''}';
      } else if (hours == 1) {
        return 'Hace 1 hora y $minutes minuto${minutes != 1 ? 's' : ''}';
      } else {
        return 'Hace $hours horas y $minutes minuto${minutes != 1 ? 's' : ''}';
      }
    } else {
      // Formato por defecto si la diferencia es mayor o igual a 12 horas
      DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
      return formatter.format(localTime);
    }
  }
}
