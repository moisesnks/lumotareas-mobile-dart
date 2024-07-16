import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/firestore/tareas.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/utils/time.dart';

class ComentarioBubble extends StatelessWidget {
  final Comentarios comentario;
  final Usuario currentUser;

  const ComentarioBubble({
    super.key,
    required this.comentario,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    bool isCurrentUser = comentario.user.uid == currentUser.uid;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue : Colors.green[800],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: isCurrentUser
                  ? [
                      Text(
                        '${Utils.formatTimestamp(comentario.fecha)}  ${Utils.formatTime(comentario.fecha)}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: Text(
                              comentario.user.nombre,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(comentario.user.photoUrl),
                            radius: 10,
                          ),
                        ],
                      ),
                    ]
                  : [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(comentario.user.photoUrl),
                            radius: 12,
                          ),
                          const SizedBox(width: 8),
                          Container(
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: Text(
                              comentario.user.nombre,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${Utils.formatTimestamp(comentario.fecha)}  ${Utils.formatTime(comentario.fecha)}',
                        style: const TextStyle(
                            fontSize: 10, color: Colors.black54),
                      ),
                    ],
            ),
            const SizedBox(height: 4),
            Text(
              comentario.message,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
