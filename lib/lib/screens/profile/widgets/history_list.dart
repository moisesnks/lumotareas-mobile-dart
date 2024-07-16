import 'package:flutter/material.dart';
import 'package:lumotareas/lib/services/access_service.dart';
import 'package:lumotareas/lib/utils/time.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/lib/providers/user_data_provider.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, userProvider, _) {
        final List<Logs> history = userProvider.history;
        return history.isEmpty
            ? const Center(
                child: Text('No hay registros de actividad'),
              )
            : ListView.builder(
                shrinkWrap: true,
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final historyItem = history[index];
                  return ListTile(
                    title: Text(historyItem.email),
                    subtitle: Text(historyItem.userAgent.split(' ')[0]),
                    trailing: Text(
                      Utils.formatToLocalTime(historyItem.created),
                    ),
                  );
                },
              );
      },
    );
  }
}
