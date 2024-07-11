import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/widgets/button_widget.dart';
import 'package:lumotareas/widgets/contenedor_widget.dart';
import 'package:lumotareas/widgets/header.dart';
import 'package:lumotareas/widgets/parrafo_widget.dart';
import 'package:lumotareas/widgets/titulo_widget.dart';
import 'package:lumotareas/widgets/box_label_widget.dart';
import 'package:lumotareas/widgets/entrada_texto_boton_widget.dart';

class InvitarMiembros extends StatefulWidget {
  InvitarMiembros({super.key});
  final Logger _logger = Logger();

  @override
  InvitarMiembrosState createState() => InvitarMiembrosState();
}

class InvitarMiembrosState extends State<InvitarMiembros> {
  final TextEditingController _emailController = TextEditingController();
  final List<String> _emails = [];

  void _addEmail() {
    String email = _emailController.text.trim();
    if (email.isNotEmpty && !_emails.contains(email)) {
      setState(() {
        _emails.add(email);
        _emailController.clear();
      });
    }
  }

  void _removeEmail(String email) {
    setState(() {
      _emails.remove(email);
    });
  }

  void _inviteMembers() {
    // Aquí implementarías la lógica para enviar las invitaciones
    // a los correos electrónicos almacenados en _emails
    // TODO: Implementar la lógica para enviar las invitaciones
    widget._logger.i('Invitando a miembros: $_emails');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/invite.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Header(
                isPoppable: true,
              ),
              Container(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Titulo(
                      texto: 'Invitar miembros',
                      fontFamily: 'Manrope',
                    ),
                    const Parrafo(
                      texto:
                          'Aquí puedes invitar a más de un miembro a tu organización. Solo necesitas agregar sus correos electrónicos y presionar el botón de Agregar.',
                      boldTexts: [
                        'agregar sus correos electrónicos',
                        'Agregar'
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    EntradaTextoConBoton(
                      controller: _emailController,
                      labelText: 'Correo electrónico',
                      onPressed: _addEmail,
                      buttonText: 'Agregar',
                      fontColor: Colors.white,
                    ),
                    const SizedBox(height: 16.0),
                    BoxLabel(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      labelText: 'Miembros a invitar',
                      borderColor: const Color.fromARGB(255, 100, 102, 168),
                      labelBackgroundColor: const Color.fromARGB(255, 7, 8, 29),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.width,
                        child: Scrollbar(
                          thumbVisibility: true,
                          child: SingleChildScrollView(
                            child: Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: _emails.map((email) {
                                return Chip(
                                  label: Text(email),
                                  backgroundColor:
                                      const Color.fromARGB(255, 100, 102, 168),
                                  labelStyle:
                                      const TextStyle(color: Colors.white),
                                  deleteIcon: const Icon(Icons.clear,
                                      color: Colors.white),
                                  onDeleted: () => _removeEmail(email),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Contenedor(color: Colors.transparent, children: [
                      Button(
                        onPressed: _inviteMembers,
                        text: 'Invitar miembros',
                        icon: const Icon(Icons.send),
                      ),
                    ])
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
