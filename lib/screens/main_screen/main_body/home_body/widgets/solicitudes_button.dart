import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/icon_box_widget.dart';
import 'package:lumotareas/widgets/list_items_widget.dart';
import 'package:lumotareas/services/organization_service.dart';
import 'package:lumotareas/models/user.dart';

class SolicitudesButton extends StatelessWidget {
  final List<Solicitud> solicitudes;
  final OrganizationService _organizationService = OrganizationService();

  SolicitudesButton({
    super.key,
    required this.solicitudes,
  });

  void _showRequestList(BuildContext context) async {
    if (solicitudes.isNotEmpty) {
      try {
        if (context.mounted) {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ListItems<Solicitud>(
                items: solicitudes,
                itemBuilder: (context, solicitud) {
                  return ListTile(
                    title: Text(
                      solicitud.organizationId,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('id: ${solicitud.id}'),
                    onTap: () async {
                      Map<String, dynamic> response =
                          await _organizationService.getSolicitud(
                        solicitud.organizationId,
                        solicitud.id,
                      );
                      if (response['success']) {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Solicitud'),
                                content: Text(
                                    'Respuestas: ${response['solicitud']}'),
                              );
                            },
                          );
                        }
                      } else {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: Text(
                                    'Error al obtener la solicitud: ${response['message']}'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    },
                  );
                },
              );
            },
          );
        }
      } catch (e) {
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error'),
                content: Text('Error al obtener las solicitudes: $e'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay solicitudes pendientes.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconBox(
      icon: Icons.email,
      label: 'Solicitudes',
      count: solicitudes.length,
      showCount: true,
      onTap: () => _showRequestList(context),
    );
  }
}
