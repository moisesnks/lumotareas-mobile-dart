/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/models/firestore/solicitud.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/screens/solicitud/solicitud_org_screen.dart';
import 'package:lumotareas/widgets/icon_box.dart';
import 'package:lumotareas/widgets/styled_list_tile.dart';

class OrgRequestsButton extends StatelessWidget {
  final List<Solicitud> solicitudes;
  final Usuario currentUser;

  const OrgRequestsButton({
    super.key,
    required this.solicitudes,
    required this.currentUser,
  });

  void showRequestsList(BuildContext context) {
    if (solicitudes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay solicitudes en esta organización.'),
        ),
      );
    } else {
      showModalBottomSheet(
        backgroundColor: const Color.fromARGB(155, 56, 45, 93),
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
            itemCount: solicitudes.length,
            itemBuilder: (BuildContext context, int index) {
              final Solicitud solicitud = solicitudes[index];
              final String uid = solicitud.uid;
              return StyledListTile(
                index: index,
                leading: const Icon(Icons.person),
                title: Text('Solicitud de $uid'),
                subtitle: Text(
                    'Estado: ${solicitud.estado.toString().split('.').last}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestOrgScreen(
                        solicitudId: solicitud.id,
                        orgName: currentUser.currentOrg,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconBox(
      icon: Icons.request_page,
      label: 'Solicitudes de la organización',
      count: solicitudes.length,
      showCount: true,
      onTap: () => showRequestsList(context),
    );
  }
}
