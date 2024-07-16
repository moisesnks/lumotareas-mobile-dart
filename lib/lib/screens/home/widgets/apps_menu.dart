import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/organization/organizacion.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
// import 'package:lumotareas/lib/screens/home/widgets/app_projects_user.dart';
import 'package:lumotareas/lib/screens/home/widgets/app_requests_user.dart';
import 'package:lumotareas/lib/widgets/flexible_wrap.dart';
import 'app_members.dart';
import 'app_projects_org.dart';
import 'app_requests_org.dart';

class AppsMenu extends StatelessWidget {
  final Usuario currentUser;
  final Organizacion currentOrg;

  const AppsMenu(
      {super.key, required this.currentUser, required this.currentOrg});

  @override
  Widget build(BuildContext context) {
    return FlexibleWrap(
      color: Colors.transparent,
      spacing: 8.0,
      children: [
        MembersButton(miembros: currentOrg.miembros),
        ProjectsOrgButton(
            currentUser: currentUser,
            proyectos: currentOrg.proyectos,
            miembros: currentOrg.miembros),
        // ProjectsUserButton(
        //     proyectos: currentOrg.proyectos,
        //     currentUser: currentUser,
        //     miembros: currentOrg.miembros),
        OrgRequestsButton(solicitudes: currentOrg.solicitudes),
        UserRequestsButton(solicitudes: currentUser.solicitudes),
      ],
    );
  }
}
