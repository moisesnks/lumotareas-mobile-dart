/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/providers/user_data_provider.dart';
import 'widgets/last_login.dart';
import 'widgets/profile_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(builder: (context, userProvider, _) {
      final Usuario? currentUser = userProvider.currentUser;
      if (currentUser == null) {
        return const SizedBox.shrink();
      }
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ProfileWidget(currentUser: currentUser),
            const SizedBox(height: 24),
            const LastLogin(),
          ],
        ),
      );
    });
  }
}

class ChangeNameDialog extends StatefulWidget {
  final Usuario currentUser;

  const ChangeNameDialog({super.key, required this.currentUser});

  @override
  ChangeNameDialogState createState() => ChangeNameDialogState();
}

class ChangeNameDialogState extends State<ChangeNameDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentUser.nombre);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cambiar nombre'),
      content: TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Nombre',
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            final updatedUser = Usuario(
              uid: widget.currentUser.uid,
              nombre: _nameController.text,
              email: widget.currentUser.email,
              birthdate: widget.currentUser.birthdate,
              photoURL: widget.currentUser.photoURL,
              currentOrg: widget.currentUser.currentOrg,
              organizaciones: widget.currentUser.organizaciones,
              solicitudes: widget.currentUser.solicitudes,
            );
            Provider.of<UserDataProvider>(context, listen: false)
                .updateUserData(context, updatedUser);
            Navigator.of(context).pop();
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
