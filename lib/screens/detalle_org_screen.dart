import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/header.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/organization.dart'; // Importa el modelo de Organization
import './detalle_org/descripcion_widget.dart';
import './detalle_org/miembros_widget.dart';
import './detalle_org/owner_widget.dart';
import './detalle_org/auth_widget.dart';

class DetalleOrgScreen extends StatelessWidget {
  final String orgName;
  final Organization
      organization; // Cambiado a Organization en lugar de Map<String, dynamic>
  final Logger _logger = Logger(); // Instancia del Logger

  DetalleOrgScreen(
      {super.key, required this.orgName, required this.organization});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/new_org.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Header(
                onTap: () {
                  _logger.d('Tapped on header'); // Logging onTap event
                  // Additional logic can be added here
                },
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Su búsqueda ha coincido con:',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                child: Text(
                  orgName,
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lexend',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    DescriptionQuote(descripcion: organization.descripcion),
                    MiembrosField(miembros: organization.miembros),
                    OwnerField(owner: organization.owner.nombre),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
                child: AuthButtons(
                    vacantes: organization.vacantes,
                    formulario: organization.formulario,
                    orgName: orgName),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
