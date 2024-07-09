import 'package:flutter/material.dart';
import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/services/organization_service.dart';

class CreandoOrgScreen extends StatefulWidget {
  final String orgName;
  final String ownerUID;

  const CreandoOrgScreen({
    super.key,
    required this.orgName,
    required this.ownerUID,
  });

  @override
  CreandoOrgScreenState createState() => CreandoOrgScreenState();
}

class CreandoOrgScreenState extends State<CreandoOrgScreen> {
  final OrganizationService _organizationService = OrganizationService();
  final _formKey = GlobalKey<FormState>();
  bool _vacantes = false;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _preguntas = [
    {
      'titulo': 'Descripción',
      'controller': TextEditingController(),
      'validator': (value) {
        return null; // Puedes agregar validaciones adicionales si es necesario
      },
      'field': 'descripcion',
    },
    {
      'titulo': '¿Tiene vacantes?',
      'controller': TextEditingController(),
      'field': 'vacantes',
    },
  ];

  @override
  void dispose() {
    for (var pregunta in _preguntas) {
      pregunta['controller'].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Organización'),
      ),
      floatingActionButton: _currentPage < _preguntas.length - 1
          ? FloatingActionButton.extended(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _currentPage++;
                  });
                }
              },
              label: const Text('Siguiente'),
              icon: const Icon(Icons.arrow_forward),
            )
          : FloatingActionButton.extended(
              onPressed: () {
                _crearOrganizacion(context);
              },
              label: const Text('Crear Organización'),
              icon: const Icon(Icons.check),
            ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Creando la organización: ${widget.orgName}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                _preguntas[_currentPage]['titulo'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (_preguntas[_currentPage]['field'] == 'vacantes')
                CheckboxListTile(
                  title: const Text('¿Tiene vacantes?'),
                  value: _vacantes,
                  onChanged: (newValue) {
                    setState(() {
                      _vacantes = newValue ?? false;
                    });
                  },
                ),
              if (_preguntas[_currentPage]['field'] != 'vacantes')
                TextFormField(
                  controller: _preguntas[_currentPage]['controller'],
                  decoration: InputDecoration(
                    labelText: _preguntas[_currentPage]['titulo'],
                  ),
                  validator: _preguntas[_currentPage]['validator'],
                  maxLines: _preguntas[_currentPage]['field'] == 'descripcion'
                      ? 3
                      : 1,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _crearOrganizacion(BuildContext context) async {
    // Crear objeto Organization con los datos del formulario y los parámetros recibidos
    Organization newOrg = Organization(
      nombre: widget.orgName,
      owner: Owner(nombre: widget.orgName, uid: widget.ownerUID),
      descripcion: _preguntas[0]['controller'].text,
      vacantes: _vacantes,
      miembros: 1, // El owner es el primer miembro
      formulario: {},
    );

    // Llamar al servicio para crear la organización
    final result = await _organizationService.createOrganization(newOrg);

    // Mostrar el resultado en un AlertDialog
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text(result['success'] ? 'Éxito' : 'Error'),
            content: Text(result['message']),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  if (result['success']) {
                    // Navegar a la pantalla de inicio que es '/main'
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      '/main',
                      (route) => false,
                    );
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
