/// @nodoc
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/firestore/comentarios.dart';
import 'package:lumotareas/lib/models/firestore/small_user.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/screens/tarea/widgets/comentario_bubble.dart';
import 'package:lumotareas/lib/widgets/secondary_header.dart';

import 'widgets/comentario_input.dart';

class ComentariosScreen extends StatefulWidget {
  final List<Comentarios> comentarios;
  final Usuario currentUser;
  final dynamic Function(String) onSendComment;

  const ComentariosScreen({
    super.key,
    required this.comentarios,
    required this.currentUser,
    required this.onSendComment,
  });

  @override
  ComentariosScreenState createState() => ComentariosScreenState();
}

class ComentariosScreenState extends State<ComentariosScreen> {
  late TextEditingController commentController;
  List<Comentarios> comentariosLocal = [];

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    comentariosLocal.addAll(widget.comentarios);
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Header(
              title: 'Comentarios (${widget.comentarios.length})',
              isPoppable: true,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: comentariosLocal.length,
                itemBuilder: (context, index) => ComentarioBubble(
                  comentario: comentariosLocal[index],
                  currentUser: widget.currentUser,
                ),
              ),
            ),
            CommentInputWidget(
              commentController: commentController,
              onSendComment: (comment) {
                setState(() {
                  comentariosLocal.add(Comentarios(
                    message: comment,
                    user: SmallUser(
                      nombre: widget.currentUser.nombre,
                      photoUrl: widget.currentUser.photoURL,
                      uid: widget.currentUser.uid,
                    ),
                    fecha: Timestamp.fromDate(DateTime.now()),
                  ));
                });
                widget.onSendComment(comment);
              },
              currentUser: widget.currentUser,
            ),
          ],
        ),
      ),
    );
  }
}
