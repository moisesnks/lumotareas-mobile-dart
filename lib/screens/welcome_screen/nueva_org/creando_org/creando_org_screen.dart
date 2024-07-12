import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/widgets/form_widget.dart';
import 'package:lumotareas/models/organization.dart';
import 'logic.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';

class CreandoOrgScreen extends StatefulWidget {
  final String orgName;
  final String? ownerUID;
  final String? username;

  const CreandoOrgScreen({
    super.key,
    this.orgName = '',
    this.ownerUID,
    this.username,
  });

  @override
  CreandoOrgScreenState createState() => CreandoOrgScreenState();
}

class CreandoOrgScreenState extends State<CreandoOrgScreen> {
  late String _initializedOwnerUID;
  late String _initializedUsername;

  @override
  void initState() {
    super.initState();
    _initializedOwnerUID = initializeOwnerUID();
    _initializedUsername = initializeUsername();
  }

  String initializeOwnerUID() {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    String ownerUID = widget.ownerUID ?? loginViewModel.currentUser?.uid ?? '';
    if (ownerUID.isNotEmpty) {
      return ownerUID;
    } else {
      Navigator.of(context).pop();
      return '';
    }
  }

  String initializeUsername() {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    String username =
        widget.username ?? loginViewModel.currentUser?.nombre ?? '';
    if (username.isNotEmpty) {
      return username;
    } else {
      Navigator.of(context).pop();
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final preguntas = getPreguntas(widget.orgName);

    // Verificar si _initializedOwnerUID o _initializedUsername están vacíos y manejar la lógica correspondiente
    if (_initializedOwnerUID.isEmpty || _initializedUsername.isEmpty) {
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
        _initializedUsername, widget.orgName, _initializedOwnerUID, respuestas);

    await Provider.of<LoginViewModel>(context, listen: false)
        .createOrganization(context, newOrg);
  }
}
