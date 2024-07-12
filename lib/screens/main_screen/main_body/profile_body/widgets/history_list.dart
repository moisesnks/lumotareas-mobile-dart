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
        final history = loginViewModel.history;
        final loading = loginViewModel.loading;

        if (loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (history.isEmpty) {
          return const Center(child: Text('No hay historial disponible.'));
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: history.length,
          itemBuilder: (context, index) {
            final historyItem = history[index];
            return ListTile(
              title: Text(historyItem['email']),
              subtitle: Text(historyItem['userAgent'].split(' ')[0]),
              trailing: Text(
                Utils.formatToLocalTime(historyItem['created']),
              ),
            );
          },
        );
      },
    );
  }
}
