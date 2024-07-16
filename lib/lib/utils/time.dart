import 'package:cloud_firestore/cloud_firestore.dart';
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
      } else if (hours < 23) {
        return 'Hace $hours horas y $minutes minuto${minutes != 1 ? 's' : ''}';
      }
    }

    // Si la diferencia es mayor o igual a 12 horas, formatear como fecha completa
    return DateFormat('d MMMM, y').format(localTime);
  }

  static String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    var format = DateFormat.yMMMd('es_CL');
    return format.format(dateTime);
  }

  static String formatDifference(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(dateTime);

    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);

    if (hours == 0 && minutes == 0) {
      return 'Hace menos de un minuto';
    } else if (hours == 0) {
      return 'Hace $minutes minuto${minutes != 1 ? 's' : ''}';
    } else if (hours == 1) {
      return 'Hace 1 hora y $minutes minuto${minutes != 1 ? 's' : ''}';
    } else if (hours < 24) {
      return 'Hace $hours horas y $minutes minuto${minutes != 1 ? 's' : ''}';
    } else if (hours >= 24 && hours <= 47) {
      return 'Hace ${hours ~/ 24} día${hours ~/ 24 != 1 ? 's' : ''}';
    } else {
      return DateFormat('dd MMMM, y').format(dateTime);
    }
  }

  static String formatTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat.jm().format(dateTime);
  }
}
