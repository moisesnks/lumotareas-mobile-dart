import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/organization/organizacion.dart';
import 'package:lumotareas/models/user/solicitudes.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/providers/user_data_provider.dart';
import 'package:lumotareas/screens/enviar_solicitud/enviar_solicitud_screen.dart';
import 'package:lumotareas/widgets/imagen.dart';
import 'package:lumotareas/widgets/secondary_header.dart';
import 'package:provider/provider.dart';

class OrganizacionDetalleScreen extends StatelessWidget {
  final Organizacion organizacion;

  const OrganizacionDetalleScreen({
    super.key,
    required this.organizacion,
  });

  @override
  Widget build(BuildContext context) {
    final Usuario? currentUser =
        Provider.of<UserDataProvider>(context).currentUser;
    if (currentUser == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('No se pudo cargar el usuario actual'),
            Text('Por favor, intenta de nuevo'),
          ],
        ),
      );
    }

    final bool yaSolicito = currentUser.solicitudes.any(
        (Solicitudes solicitud) => solicitud.orgName == organizacion.nombre);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Header(title: organizacion.nombre, isPoppable: true),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.12,
                        width: MediaQuery.of(context).size.height * 0.15,
                        child: Imagen(
                            fit: BoxFit.fill, imageUrl: organizacion.imageUrl),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            organizacion.nombre,
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Manrope',
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Row para los miembros y un icono
                          Row(
                            children: [
                              const Icon(Icons.people),
                              const SizedBox(width: 8),
                              const Text(
                                'Miembros: ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Manrope',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                organizacion.miembros.length.toString(),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Manrope',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text(
                                'Por ',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Manrope',
                                ),
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 200),
                                child: Text(
                                  organizacion.owner.nombre.split(' ')[0],
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w300,
                                    fontFamily: 'Manrope',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(organizacion.owner.photoURL),
                                radius: 10,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Text(
                    organizacion.descripcion,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Manrope',
                    ),
                  ),
                  if (organizacion.vacantes && !organizacion.formulario.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Vacantes disponibles',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300,
                              fontFamily: 'Manrope',
                            ),
                          ),
                          const SizedBox(height: 20),
                          OutlinedButton.icon(
                            onPressed: () {
                              Logger().i(
                                  'Formulario clicked ${organizacion.formulario}');
                              !yaSolicito
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EnviarSolicitudScreen(
                                          orgName: organizacion.nombre,
                                          formulario: organizacion.formulario,
                                        ),
                                      ),
                                    )
                                  : ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Ya solicitaste unirte a esta organización'),
                                      ),
                                    );
                            },
                            icon: yaSolicito
                                ? const Icon(Icons.done)
                                : const Icon(Icons.send),
                            label: yaSolicito
                                ? const Text('Ya solicitaste')
                                : const Text('Enviar solicitud'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
