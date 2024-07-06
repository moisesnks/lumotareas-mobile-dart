import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:logger/logger.dart';

class MenuFlotante extends StatelessWidget {
  final Logger _logger = Logger();
  final IconData mainIcon;
  final List<Map<String, dynamic>> items;

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

      _logger.i('Se agregó "${task['label']}" al menú flotante.');
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
