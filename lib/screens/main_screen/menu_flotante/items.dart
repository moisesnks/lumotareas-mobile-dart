import 'package:flutter/material.dart';
import 'package:lumotareas/models/user.dart';
import './invitar_miembros/invitar_miembros.dart';

List<Map<String, dynamic>> getFloatingButtonItems(Usuario currentUser) {
  List<Map<String, dynamic>> tasks = [
    {
      'label': 'Agregar tarea',
      'icon': Icons.task,
      'screen': null,
      'requiredRole': TaskRole.any,
    },
    {
      'label': 'Crear proyecto',
      'icon': Icons.folder,
      'screen': null,
      'requiredRole': TaskRole.owner,
    },
    {
      'label': 'Invitar miembros',
      'icon': Icons.person_add,
      'screen': InvitarMiembros(),
      'requiredRole': TaskRole.owner,
    }
  ];

  List<Map<String, dynamic>> noOrganizationTasks = [
    {
      'label': 'Crear organización',
      'icon': Icons.group,
      'screen': null,
    }
  ];

  List<Map<String, dynamic>> allItems = [];

  // Determinar si el usuario es dueño o miembro de alguna organización
  bool hasOrganization = currentUser.getOwnerOrganizationIds().isNotEmpty ||
      currentUser.getMemberOrganizationIds().isNotEmpty;

  // Construir elementos del menú flotante para usuarios con organización
  if (hasOrganization) {
    allItems.addAll(tasks);
  } else {
    // Construir elementos del menú flotante para usuarios sin organización
    allItems.addAll(noOrganizationTasks);
  }

  return allItems;
}

enum TaskRole {
  owner,
  member,
  any,
}
