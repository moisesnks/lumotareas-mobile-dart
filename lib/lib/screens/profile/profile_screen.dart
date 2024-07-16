import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/lib/providers/user_data_provider.dart';
import './widgets/last_login.dart';
import './widgets/profile_widget.dart';

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
