import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:logger/logger.dart';
import './invite_members_screen.dart';

class FloatingButtonMenu extends StatelessWidget {
  final Logger _logger = Logger();

  FloatingButtonMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add, // Usa este para definir el ícono principal
      activeIcon: Icons.close,
      foregroundColor: Colors.white,
      backgroundColor: Colors.blue,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      spacing: 12.0,
      curve: Curves.easeInOut,
      spaceBetweenChildren: 8.0,
      children: [
        _buildSpeedDialChild(
          context: context,
          label: 'Agregar tarea',
          icon: Icons.task,
        ),
        _buildSpeedDialChild(
          context: context,
          label: 'Agregar proyecto',
          icon: Icons.folder,
        ),
        _buildSpeedDialChild(
          context: context,
          label: 'Invitar miembros',
          icon: Icons.person_add,
          screen: InviteMembersScreen(),
        ),
      ],
    );
  }

  SpeedDialChild _buildSpeedDialChild(
      {required BuildContext context,
      required IconData icon,
      required String label,
      Widget? screen}) {
    return SpeedDialChild(
        child: Icon(icon, color: Colors.white),
        backgroundColor: const Color(0xFF6C63FF),
        label: label,
        labelStyle: const TextStyle(color: Colors.white),
        onTap: () => {
              _logger.i('Navegando a la pantalla de $label'),
              if (screen != null)
                {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => screen),
                  )
                }
            });
  }
}
