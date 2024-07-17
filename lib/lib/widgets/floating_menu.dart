//Widget que crea un menú flotante de acciones utilizando [SpeedDial].
library;

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:logger/logger.dart';

/// Un widget que crea un menú flotante de acciones utilizando [SpeedDial].
class MenuFlotante extends StatelessWidget {
  final Logger _logger = Logger();
  final IconData mainIcon; // Icono principal del botón de acción flotante
  final List<Map<String, dynamic>> items; // Lista de ítems del menú flotante

  /// Constructor para crear una instancia de [MenuFlotante].
  ///
  /// [mainIcon] es el icono principal del botón de acción flotante.
  /// [items] es la lista de ítems del menú flotante.
  MenuFlotante({super.key, required this.mainIcon, required this.items});

  @override
  Widget build(BuildContext context) {
    List<SpeedDialChild> children = [];

    for (var task in items) {
      children.add(_buildSpeedDialChild(
        context: context,
        label: task['label'],
        icon: task['icon'],
        screen: task['screen'],
      ));
    }

    return SpeedDial(
      icon: mainIcon,
      activeIcon: Icons.close,
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      spacing: 12.0,
      curve: Curves.easeInOut,
      spaceBetweenChildren: 8.0,
      children: children,
    );
  }

  /// Crea un ítem del menú flotante.
  ///
  /// [context] es el contexto de la aplicación.
  /// [icon] es el icono del ítem del menú.
  /// [label] es la etiqueta del ítem del menú.
  /// [screen] es la pantalla a la que se navegará cuando se seleccione el ítem.
  SpeedDialChild _buildSpeedDialChild({
    required BuildContext context,
    required IconData icon,
    required String label,
    Widget? screen,
  }) {
    return SpeedDialChild(
      child: Icon(icon, color: Colors.white),
      backgroundColor: const Color(0xFF6C63FF),
      label: label,
      labelStyle: const TextStyle(color: Colors.white),
      onTap: () {
        _logger.i('Navegando a la pantalla de $label');
        if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        }
      },
    );
  }
}
