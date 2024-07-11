import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';

class HistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: true);

    // Llamar a getHistory aquí para asegurar que se cargue el historial
    if (loginViewModel.history.isEmpty) {
      // Llamar solo si la lista está vacía para evitar recargas innecesarias
      loginViewModel.getHistory(
          context, loginViewModel.currentUser?.email ?? '');
    }

    return loginViewModel.history.isEmpty
        ? Center(child: Text('No hay historial disponible'))
        : ListView.builder(
            itemCount: loginViewModel.history.length,
            itemBuilder: (context, index) {
              final historyItem = loginViewModel.history[index];
              return ListTile(
                title: Text('Email: ${historyItem['email']}'),
                subtitle: Text('User Agent: ${historyItem['userAgent']}'),
                trailing: Text('Fecha: ${historyItem['created']}'),
              );
            },
          );
  }
}
