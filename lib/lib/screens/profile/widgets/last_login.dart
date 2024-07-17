/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/lib/providers/user_data_provider.dart';
import 'package:lumotareas/lib/utils/time.dart';
import 'package:provider/provider.dart';
import './history_list.dart';

class LastLogin extends StatelessWidget {
  const LastLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserDataProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userProvider.history.isEmpty && !userProvider.loadingHistory) {
        userProvider.fetchHistory(userProvider.currentUser!.email);
      }
    });

    return Consumer<UserDataProvider>(
      builder: (context, userProvider, _) {
        final history = userProvider.history;
        final loading = userProvider.loadingHistory;

        if (loading && history.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (history.isEmpty) {
          return const Center(
            child: Text('No hay registros de actividad'),
          );
        } else {
          final lastLogin = history.first;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Última vez conectado',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            color: const Color(0xFF111111),
                            child: const Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Text(
                                    'Historial de conexiones',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: HistoryList(),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Ver todo',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.phone_android, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        lastLogin.userAgent.split(' ')[0].split('/')[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Text(
                    Utils.formatToLocalTime(lastLogin.created),
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          );
        }
      },
    );
  }
}
