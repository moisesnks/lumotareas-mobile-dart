/// @nodoc
library;

import 'package:flutter/material.dart';
import 'package:lumotareas/models/firestore/comentarios.dart';
import 'package:lumotareas/models/user/usuario.dart';
import 'package:lumotareas/screens/tarea/widgets/comentario_bubble.dart';

class ComentariosContainer extends StatelessWidget {
  final Usuario currentUser;
  final List<Comentarios> comentarios;

  const ComentariosContainer({
    super.key,
    required this.comentarios,
    required this.currentUser,
  });

  @override
  Widget build(BuildContext context) {
    final List<Comentarios> ordenados = List<Comentarios>.from(comentarios);
    // mostrar los más recientes primero en la parte superior
    ordenados.sort((a, b) => b.fecha.compareTo(a.fecha));
    return SizedBox(
      height: 200,
      child: ListView.builder(
        itemCount: comentarios.length,
        itemBuilder: (context, index) => ComentarioBubble(
          comentario: ordenados[index],
          currentUser: currentUser,
        ),
      ),
    );
  }
}
