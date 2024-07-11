import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/utils/utils.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        return FutureBuilder<void>(
          future: loginViewModel.fetchUserHistoryIfNotFetched(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final history = loginViewModel.history;
              if (history.isEmpty) {
                return const Center(
                    child: Text('No hay historial disponible.'));
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final historyItem = history[index];
                      return ListTile(
                        title: Text('Email: ${historyItem['email']}'),
                        subtitle:
                            Text('User Agent: ${historyItem['userAgent']}'),
                        trailing: Text(
                            'Fecha: ${Utils.formatToLocalTime(historyItem['created'])}'),
                      );
                    },
                  ),
                );
              }
            }
          },
        );
      },
    );
  }
}
