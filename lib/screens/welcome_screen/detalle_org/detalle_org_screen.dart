import 'package:flutter/material.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/header.dart';
import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/widgets/titulo_widget.dart';
import 'widgets/descripcion_widget.dart';
import 'widgets/miembros_widget.dart';
import 'widgets/owner_widget.dart';
import 'widgets/auth_widget.dart';

class DetalleOrgScreen extends StatelessWidget {
  final String orgName;
  final Organization organization;

  const DetalleOrgScreen(
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
          child: Contenedor(
            direction: Axis.vertical,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Header(),
              const SizedBox(height: 16.0),
              const Text(
                'Su búsqueda ha coincido con:',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              Titulo(texto: orgName, minFontSize: 32, maxFontSize: 48),
              Contenedor(
                direction: Axis.vertical,
                children: [
                  DescriptionQuote(descripcion: organization.descripcion),
                  MiembrosField(miembros: organization.miembros),
                  OwnerField(owner: organization.owner.nombre),
                ],
              ),
              AuthButtons(
                  vacantes: organization.vacantes,
                  formulario: organization.formulario,
                  orgName: orgName),
            ],
          ),
        ),
      ),
    );
  }
}
