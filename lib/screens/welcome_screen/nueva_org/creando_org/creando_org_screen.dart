import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/widgets/form_widget.dart';
import 'package:lumotareas/models/organization.dart';
import 'logic.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';

class CreandoOrgScreen extends StatefulWidget {
  final String orgName;
  final String? ownerUID;

  const CreandoOrgScreen({
    super.key,
    this.orgName = '',
    this.ownerUID,
  });

  @override
  CreandoOrgScreenState createState() => CreandoOrgScreenState();
}

class CreandoOrgScreenState extends State<CreandoOrgScreen> {
  late String _initializedOwnerUID;

  @override
  void initState() {
    super.initState();
    _initializedOwnerUID = initializeOwnerUID();
  }

  String initializeOwnerUID() {
    // Si el ownerUID no se ha pasado como argumento, se obtiene del loginViewModel
    // Si no se encuentra, se asigna un string vacío
    // Si se asigna un string vacío, se retorna una cadena vacía para manejarlo en el build

    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    String ownerUID = widget.ownerUID ?? loginViewModel.currentUser?.uid ?? '';
    if (ownerUID.isNotEmpty) {
      return ownerUID;
    } else {
      Navigator.of(context).pop();
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final preguntas = getPreguntas(widget.orgName);

    // Verificar si _initializedOwnerUID está vacío y manejar la lógica correspondiente
    if (_initializedOwnerUID.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Organización'),
      ),
      body: FormWidget(
        preguntas: preguntas,
        onSubmit: (respuestas) => _crearOrganizacion(context, respuestas),
      ),
    );
  }

  Future<void> _crearOrganizacion(
      BuildContext context, Map<String, dynamic> respuestas) async {
    Organization newOrg = createOrganizationFromResponses(
        widget.orgName, _initializedOwnerUID, respuestas);

    await Provider.of<LoginViewModel>(context, listen: false)
        .createOrganization(context, newOrg);
  }
}
