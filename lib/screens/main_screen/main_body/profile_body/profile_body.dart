import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import './widgets/profile_widget.dart';
import './widgets/last_login.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<LoginViewModel>(context).currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: SafeArea(
        child: currentUser == null
            ? const SizedBox.shrink() // SizedBox vacío si currentUser es null
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    ProfileWidget(),
                    const Divider(),
                    const LastLogin(),
                  ],
                ),
              ),
      ),
    );
  }
}
