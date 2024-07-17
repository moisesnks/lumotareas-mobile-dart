library;

import 'package:flutter/material.dart';
import 'package:lumotareas/models/organization/organizacion.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/screens/home/widgets/app_requests_user.dart';
import 'package:lumotareas/widgets/flexible_wrap.dart';
import 'app_members.dart';
import 'app_projects_org.dart';
import 'app_requests_org.dart';

class AppsMenu extends StatelessWidget {
  final Usuario currentUser;
  final Organizacion? currentOrg;

  const AppsMenu({
    super.key,
    required this.currentUser,
    required this.currentOrg,
  });

  List<Widget> _buildOrgApps(Usuario currentUser, Organizacion currentOrg) {
    return [
      MembersButton(miembros: currentOrg.miembros),
      ProjectsOrgButton(
        currentUser: currentUser,
        proyectos: currentOrg.proyectos,
        miembros: currentOrg.miembros,
      ),
      OrgRequestsButton(solicitudes: currentOrg.solicitudes),
    ];
  }

  Widget _buildNoOrgText() {
    return const Column(
      children: [
        Text(
          'Actualmente, no estás afiliado a ninguna organización. Puedes crear tu propia organización o explorar otras existentes para enviar solicitudes de afiliación.',
          style: TextStyle(
            fontSize: 12.0,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w300,
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlexibleWrap(
      color: Colors.transparent,
      spacing: 8.0,
      children: [
        if (currentUser.currentOrg.isEmpty) ...[_buildNoOrgText()],
        UserRequestsButton(solicitudes: currentUser.solicitudes),
        if (currentOrg != null) ..._buildOrgApps(currentUser, currentOrg!),
      ],
    );
  }
}
