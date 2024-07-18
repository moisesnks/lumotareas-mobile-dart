import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/providers/request_data_provider.dart';
import 'package:lumotareas/providers/user_data_provider.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/models/firestore/solicitud.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/screens/solicitud/widgets/preguntas_list.dart';
import 'package:lumotareas/widgets/secondary_header.dart';
import 'package:lumotareas/widgets/styled_list_tile.dart';

class RequestOrgScreen extends StatefulWidget {
  final String solicitudId;
  final String orgName;

  const RequestOrgScreen({
    super.key,
    required this.solicitudId,
    required this.orgName,
  });

  @override
  RequestOrgScreenState createState() => RequestOrgScreenState();
}

class RequestOrgScreenState extends State<RequestOrgScreen> {
  late RequestDataProvider _requestDataProvider;
  late Usuario? _currentUser;
  String _mensaje = '';

  @override
  void initState() {
    super.initState();
    _requestDataProvider =
        Provider.of<RequestDataProvider>(context, listen: false);
    _currentUser =
        Provider.of<UserDataProvider>(context, listen: false).currentUser;
    if (_currentUser != null) {
      _requestDataProvider.fetchSolicitud(
          context, widget.solicitudId, widget.orgName);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUser == null) {
      return const Scaffold(
        body: Center(
          child: Text('No hay usuario logueado'),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: ChangeNotifierProvider.value(
          value: _requestDataProvider,
          child: Consumer<RequestDataProvider>(
            builder: (context, dataProvider, _) {
              final solicitud = dataProvider.solicitud;
              if (solicitud == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final isOwner = _currentUser!.isOwnerOf(_currentUser!.currentOrg);

              if (!isOwner) {
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Usted no tiene permiso para ver esta pantalla, si cree que esto es un error, por favor contacte al administrador de la organización.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Volver'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final fecha = DateTime.parse(solicitud.fecha);

              final Color color = solicitud.estado == EstadoSolicitud.aceptada
                  ? Colors.green
                  : solicitud.estado == EstadoSolicitud.rechazada
                      ? Colors.red
                      : Colors.orange;

              return Column(
                children: <Widget>[
                  const Header(
                    title: 'Detalles de la Solicitud',
                    isPoppable: true,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          StyledListTile(
                            index: 0,
                            title: const Row(children: [
                              Icon(Icons.perm_identity),
                              SizedBox(width: 8.0),
                              Text('Solicitud ID'),
                            ]),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(solicitud.id),
                            ),
                          ),
                          StyledListTile(
                            index: 1,
                            title: const Row(
                              children: [
                                Icon(Icons.person),
                                SizedBox(width: 8.0),
                                Text('Estado de la solicitud'),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                solicitud.estado.toString().split('.').last,
                                style: TextStyle(color: color),
                              ),
                            ),
                          ),
                          StyledListTile(
                            index: 2,
                            title: const Row(
                              children: [
                                Icon(Icons.calendar_today),
                                SizedBox(width: 8.0),
                                Text('Fecha de la solicitud'),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${fecha.day}/${fecha.month}/${fecha.year} a las ${fecha.hour}:${fecha.minute}',
                              ),
                            ),
                          ),
                          StyledListTile(
                            index: 3,
                            title: const Row(
                              children: [
                                Icon(Icons.person),
                                SizedBox(width: 8.0),
                                Text('Solicitante'),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(solicitud.email),
                            ),
                          ),
                          StyledListTile(
                            index: 4,
                            title: const Row(
                              children: [
                                Icon(Icons.description),
                                SizedBox(width: 8.0),
                                Text('Formulario'),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  '${solicitud.solicitud.length} preguntas'),
                            ),
                          ),
                          SizedBox(
                            height: 200, // Ajusta la altura según sea necesario
                            child:
                                PreguntasList(preguntas: solicitud.solicitud),
                          ),
                          if (solicitud.estado == EstadoSolicitud.pendiente)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Aceptar solicitud'),
                                          content: const Text(
                                            'Estás seguro de que quieres aceptar esta solicitud?',
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancelar'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                dataProvider.updateSolicitud(
                                                  context,
                                                  solicitud.copyWith(
                                                    estado: EstadoSolicitud
                                                        .aceptada,
                                                  ),
                                                  _currentUser!,
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Aceptar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.check,
                                      color: Colors.white),
                                  label: const Text(
                                    'Aceptar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Rechazar solicitud'),
                                          content: const Text(
                                            'Estás seguro de que quieres rechazar esta solicitud?',
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancelar'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                dataProvider.updateSolicitud(
                                                  context,
                                                  solicitud.copyWith(
                                                    estado: EstadoSolicitud
                                                        .rechazada,
                                                  ),
                                                  _currentUser!,
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Rechazar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  label: const Text(
                                    'Rechazar',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (solicitud.respuesta.isNotEmpty)
                                ElevatedButton.icon(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Mensaje'),
                                          content: Text(solicitud.respuesta),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cerrar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.message,
                                      color: Colors.white),
                                  label: const Text(
                                    'Ver mensaje',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Dejar mensaje'),
                                        content: TextField(
                                          decoration: const InputDecoration(
                                            hintText: 'Escribe tu mensaje aquí',
                                          ),
                                          onChanged: (value) {
                                            setState(() {
                                              _mensaje = value;
                                            });
                                          },
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancelar'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Logger().d('Mensaje: $_mensaje');
                                              dataProvider.updateSolicitud(
                                                context,
                                                solicitud.copyWith(
                                                  respuesta: _mensaje,
                                                ),
                                                _currentUser!,
                                              );
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Enviar'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.message,
                                    color: Colors.white),
                                label: const Text(
                                  'Enviar mensaje',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
