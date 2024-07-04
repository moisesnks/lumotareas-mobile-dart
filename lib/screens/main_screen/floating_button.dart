import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:logger/logger.dart';
import './invite_members_screen.dart';
import 'package:lumotareas/models/user.dart';

class FloatingButtonMenu extends StatelessWidget {
  final Logger _logger = Logger();
  final Usuario currentUser;

  FloatingButtonMenu({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> tasks = [
      {
        'label': 'Agregar tarea',
        'icon': Icons.task,
        'requiredRole': TaskRole
            .member, // Puede ser visto por un miembro de la organización
      },
      {
        'label': 'Crear proyecto',
        'icon': Icons.folder,
        'requiredRole': TaskRole.owner, // Solo visible para dueños
      },
      {
        'label': 'Invitar miembros',
        'icon': Icons.person_add,
        'screen': InviteMembersScreen(),
        'requiredRole': TaskRole.owner, // Solo visible para dueños
      },
    ];

    List<SpeedDialChild> children = [];

    // Determinar si el usuario es dueño de alguna organización
    bool isOwnerOfAnyOrganization =
        currentUser.getOwnerOrganizationIds().isNotEmpty;

    // Determinar si el usuario es miembro de alguna organización
    bool isMemberOfAnyOrganization =
        currentUser.getMemberOrganizationIds().isNotEmpty;

    // Construir elementos del menú flotante
    for (var task in tasks) {
      TaskRole requiredRole = task['requiredRole'] ?? TaskRole.none;

      // Verificar si el usuario tiene permiso para ver esta tarea
      switch (requiredRole) {
        case TaskRole.any:
          children.add(_buildSpeedDialChild(
            context: context,
            label: task['label'],
            icon: task['icon'],
            screen: task['screen'],
          ));
          break;
        case TaskRole.owner:
          if (isOwnerOfAnyOrganization) {
            children.add(_buildSpeedDialChild(
              context: context,
              label: task['label'],
              icon: task['icon'],
              screen: task['screen'],
            ));
          }
          break;
        case TaskRole.member:
          if (isMemberOfAnyOrganization) {
            children.add(_buildSpeedDialChild(
              context: context,
              label: task['label'],
              icon: task['icon'],
              screen: task['screen'],
            ));
          }
          break;
        case TaskRole.none:
          // No se requiere ningún rol específico para esta tarea
          children.add(_buildSpeedDialChild(
            context: context,
            label: task['label'],
            icon: task['icon'],
            screen: task['screen'],
          ));
          break;
      }

      _logger.i('Se agregó "${task['label']}" al menú flotante.');
    }

    return SpeedDial(
      icon: Icons.add,
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

enum TaskRole {
  owner, // Solo visible para dueños
  member, // Solo visible para miembros
  any, // Puede ser visto por cualquier usuario
  none, // No se requiere ningún rol específico
}
