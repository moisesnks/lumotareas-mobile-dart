import 'package:flutter/material.dart';
import 'package:lumotareas/models/user.dart';
import 'children/invite_members.dart/screen.dart';
import 'children/create_project/screen.dart';
import 'package:lumotareas/screens/welcome_screen/nueva_org/creando_org/creando_org_screen.dart';

List<Map<String, dynamic>> getFloatingButtonItems(
    Usuario currentUser, String currentPage) {
  List<Map<String, dynamic>> homeTasks = [];
  List<Map<String, dynamic>> discoverTasks = [];
  List<Map<String, dynamic>> profileTasks = [];

  // Opciones para la página de Home
  if (currentUser.isOwner()) {
    homeTasks.add({
      'label': 'Añadir proyecto',
      'icon': Icons.folder,
      'screen': const CreateProjectScreen(),
      'requiredRole': TaskRole.owner,
    });
    homeTasks.add({
      'label': 'Invitar miembros',
      'icon': Icons.person_add,
      'screen': InvitarMiembros(),
      'requiredRole': TaskRole.owner,
    });
  }

  // Opciones para la página de Descubrir
  if (currentUser.isMember() || currentUser.isOwner()) {
    discoverTasks.add({
      'label': 'Añadir publicación',
      'icon': Icons.post_add,
      'screen': null,
      'requiredRole': TaskRole.any,
    });
  }

  // Opciones para la página de Perfil
  profileTasks.add({
    'label': 'Cambiar foto de perfil',
    'icon': Icons.photo_camera,
    'screen': null,
    'requiredRole': TaskRole.any,
  });
  profileTasks.add({
    'label': 'Cambiar nombre',
    'icon': Icons.edit,
    'screen': null,
    'requiredRole': TaskRole.any,
  });

  // Opciones para usuarios sin organización
  List<Map<String, dynamic>> noOrganizationTasks = [
    {
      'label': 'Crear organización',
      'icon': Icons.group,
      'screen': const CreandoOrgScreen(),
    }
  ];

  List<Map<String, dynamic>> allItems = [];

  // Determinar si el usuario es dueño o miembro de alguna organización
  bool hasOrganization = currentUser.getOwnerOrganizationIds().isNotEmpty ||
      currentUser.getMemberOrganizationIds().isNotEmpty;

  // Construir elementos del menú flotante dependiendo de la página actual y el estado del usuario
  if (currentPage == 'home') {
    if (hasOrganization) {
      allItems.addAll(homeTasks);
    } else {
      allItems.addAll(noOrganizationTasks);
    }
  } else if (currentPage == 'descubrir') {
    if (hasOrganization) {
      allItems.addAll(discoverTasks);
    }
  } else if (currentPage == 'perfil') {
    allItems.addAll(profileTasks);
  }

  return allItems;
}

enum TaskRole {
  owner,
  member,
  any,
}

extension on Usuario {
  bool isOwner() => getOwnerOrganizationIds().isNotEmpty;
  bool isMember() => getMemberOrganizationIds().isNotEmpty;
}
