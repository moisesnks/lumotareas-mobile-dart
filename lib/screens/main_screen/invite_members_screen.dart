import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/widgets/header.dart';

class InviteMembersScreen extends StatefulWidget {
  InviteMembersScreen({super.key});
  final Logger _logger = Logger();

  @override
  InviteMembersScreenState createState() => InviteMembersScreenState();
}

class InviteMembersScreenState extends State<InviteMembersScreen> {
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
                    const Text(
                      'Agregar miembros',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lexend',
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 12.0,
                            fontFamily: 'Manrope',
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    'Aquí puedes invitar a más de un miembro a tu organización. Solo necesitas '),
                            TextSpan(
                              text: 'agregar sus correos electrónicos',
                              // style underline
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: ' y presionar el botón de '),
                            TextSpan(
                              text: 'Agregar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: '.'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Ingresa el correo electrónico',
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 100, 102, 168),
                                        width: 2.0,
                                      ), // Borde cuando está inactivo
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 100, 102, 168),
                                        width: 2.0,
                                      ), // Borde cuando está activo
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: ElevatedButton(
                                    onPressed: _addEmail,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 100, 102, 168),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 13),
                                      child: Text(
                                        'Agregar',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Invitarás a los siguientes usuarios',
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 100, 102, 168),
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: SizedBox(
                              height:
                                  200, // Puedes ajustar esta altura según sea necesario
                              child: Scrollbar(
                                thumbVisibility:
                                    true, // Hace que la barra de desplazamiento sea visible mientras se desplaza
                                child: SingleChildScrollView(
                                  child: Wrap(
                                    spacing:
                                        8.0, // Espacio horizontal entre los chips
                                    runSpacing:
                                        4.0, // Espacio vertical entre las filas de chips
                                    children: _emails.map((email) {
                                      return Chip(
                                        label: Text(email),
                                        backgroundColor: const Color.fromARGB(
                                            255, 100, 102, 168),
                                        labelStyle: const TextStyle(
                                            color: Colors.white),
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
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _inviteMembers,
                      child: const Text('Agregar miembros'),
                    ),
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
