import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/user/solicitudes.dart';
import 'package:lumotareas/lib/screens/solicitud/solicitud_user_screen.dart';
import 'package:lumotareas/lib/widgets/icon_box.dart';
import 'package:lumotareas/lib/widgets/styled_list_tile.dart';

class UserRequestsButton extends StatelessWidget {
  final List<Solicitudes> solicitudes;

  const UserRequestsButton({super.key, required this.solicitudes});

  void showRequestsList(BuildContext context) {
    if (solicitudes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay solicitudes.'),
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
              final Solicitudes solicitud = solicitudes[index];
              return StyledListTile(
                index: index,
                leading: const Icon(Icons.business),
                title: Text(solicitud.orgName),
                subtitle: Text('Solicitud ID: ${solicitud.id}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestUserScreen(
                        solicitud: solicitud,
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
      label: 'Solicitudes',
      count: solicitudes.length,
      showCount: true,
      onTap: () => showRequestsList(context),
    );
  }
}
