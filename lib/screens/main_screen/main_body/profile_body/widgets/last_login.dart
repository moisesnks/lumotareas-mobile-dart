import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lumotareas/viewmodels/login_viewmodel.dart';
import 'package:lumotareas/utils/utils.dart';
import './history_list.dart';

class LastLogin extends StatelessWidget {
  const LastLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, child) {
        final history = loginViewModel.history;
        if (history.isEmpty) {
          return const Center(
              child: Text('No hay historial disponible.',
                  style: TextStyle(color: Colors.white)));
        } else {
          final latestHistoryItem = history.first;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Última vez conectado',
                    style: TextStyle(
                      fontSize: 18,
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
                        '${latestHistoryItem['userAgent']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Text(
                    'Fecha: ${Utils.formatToLocalTime(latestHistoryItem['created'])}',
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
