import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/solicitud.dart';
import 'package:lumotareas/models/user.dart';
import 'package:lumotareas/widgets/icon_box_widget.dart';
import 'package:lumotareas/widgets/list_items_widget.dart';

class SolicitudesOrgButton extends StatelessWidget {
  final String orgName;
  final Usuario currentUser;
  final List<SolicitudOrg> solicitudes;
  final Logger _logger = Logger();

  SolicitudesOrgButton({
    super.key,
    required this.orgName,
    required this.currentUser,
    required this.solicitudes,
  });

  void _showIncomingRequests(BuildContext context) {
    if (solicitudes.isEmpty) {
      // Mostrar un SnackBar si no hay solicitudes
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay solicitudes entrantes.'),
        ),
      );
    } else {
      // Mostrar las solicitudes entrantes en un modal
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ListItems<SolicitudOrg>(
            items: solicitudes,
            itemBuilder: (context, solicitud) {
              return ListTile(
                title: Text(
                  solicitud.estado,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('Fecha: ${solicitud.fecha}'),
                onTap: () async {
                  // Lógica para manejar la solicitud al tocarla
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
    _logger.i('Construyendo el botón de solicitudes de la organización');
    _logger.d('Solicitudes: $solicitudes');
    return IconBox(
      icon: Icons.mark_email_unread,
      label: 'Solicitudes de la organización',
      onTap: () => _showIncomingRequests(context),
      count: solicitudes.length,
      showCount: true,
    );
  }
}
