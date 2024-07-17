/// @nodoc
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumotareas/lib/models/firestore/comentarios.dart';
import 'package:lumotareas/lib/models/firestore/small_user.dart';
import 'package:lumotareas/lib/models/firestore/subtarea.dart';
import 'package:lumotareas/lib/models/firestore/tareas.dart';
import 'package:lumotareas/lib/models/user/usuario.dart';
import 'package:lumotareas/lib/providers/project_data_provider.dart';
import 'package:lumotareas/lib/screens/tarea/widgets/subtarea_checkbox.dart';
import 'package:lumotareas/lib/screens/tarea/widgets/subtarea_submit_dialog.dart';
import 'package:lumotareas/lib/screens/tarea/widgets/tarea_titulo.dart';
import 'package:lumotareas/lib/widgets/secondary_header.dart';
import 'package:provider/provider.dart';

import 'widgets/comentarios_container.dart';
import 'comentarios_screen.dart';

class TareaScreen extends StatefulWidget {
  final TareaFirestore tarea;
  final Usuario currentUser;

  const TareaScreen({
    super.key,
    required this.tarea,
    required this.currentUser,
  });

  @override
  TareaScreenState createState() => TareaScreenState();
}

class TareaScreenState extends State<TareaScreen> {
  late List<Subtarea> _subtareas;
  late List<Comentarios> _comentariosSorted;
  ScrollController scrollController = ScrollController();
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _subtareas = List<Subtarea>.from(widget.tarea.subtareas);
    _comentariosSorted = List<Comentarios>.from(widget.tarea.comentarios);
    _comentariosSorted.sort((a, b) => a.fecha.compareTo(b.fecha));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    commentController.dispose();
    super.dispose();
  }

  void sendComment(String comment) async {
    setState(() {
      _comentariosSorted.add(Comentarios(
        message: comment,
        user: SmallUser(
          nombre: widget.currentUser.nombre,
          photoUrl: widget.currentUser.photoURL,
          uid: widget.currentUser.uid,
        ),
        fecha: Timestamp.fromDate(DateTime.now()),
      ));
    });

    // Crear una copia de la tarea actual y agregar el comentario
    TareaFirestore updatedTarea = TareaFirestore(
      createdBy: widget.currentUser.uid,
      id: widget.tarea.id,
      name: widget.tarea.name,
      description: widget.tarea.description,
      startDate: widget.tarea.startDate,
      endDate: widget.tarea.endDate,
      subtareas: widget.tarea.subtareas,
      asignados: widget.tarea.asignados,
      comentarios: _comentariosSorted,
      sprintId: widget.tarea.sprintId,
      projectId: widget.tarea.projectId,
    );

    // Actualizar la tarea en Firestore
    await Provider.of<ProjectDataProvider>(context, listen: false)
        .updateTarea(updatedTarea);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  void handleDeleteButton() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar tarea'),
        content: const Text('¿Estás seguro de que deseas eliminar esta tarea?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ProjectDataProvider>(context, listen: false)
                  .deleteTarea(context, widget.tarea, widget.currentUser);
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentUserAssigned =
        widget.tarea.asignados.contains(widget.currentUser.uid);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Header(title: 'Detalles de la tarea', isPoppable: true),
            TituloTask(
                tarea: widget.tarea,
                onTap: handleDeleteButton,
                userId: widget.currentUser.uid),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _subtareas.length,
                itemBuilder: (context, index) => SubtareaCheckbox(
                  subtarea: _subtareas[index],
                  onChanged: isCurrentUserAssigned
                      ? (bool? value) {
                          if (value != null) {
                            _handleSubtareaCheck(
                              context,
                              _subtareas[index],
                              value,
                            );
                          }
                        }
                      : null,
                ),
              ),
            ),
            ComentariosContainer(
              comentarios: _comentariosSorted,
              currentUser: widget.currentUser,
            ),
            GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.comment),
                        const SizedBox(width: 8.0),
                        Text(
                          _comentariosSorted.length.toString(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    const Text('Agregar un comentario'),
                    const Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComentariosScreen(
                      comentarios: _comentariosSorted,
                      currentUser: widget.currentUser,
                      onSendComment: sendComment,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubtareaCheck(
    BuildContext context,
    Subtarea subtarea,
    bool done,
  ) async {
    showDialog(
      context: context,
      builder: (context) => SubtareaConfirmationDialog(
        subtarea: subtarea,
        done: done,
        onConfirm: () async {
          setState(() {
            subtarea.done = done;
          });
          handleUpdateSubtarea(subtarea, widget.currentUser);
          Navigator.pop(context);
        },
      ),
    );
  }

  void handleUpdateSubtarea(Subtarea subtarea, Usuario currentUser) async {
    // Crear una copia de la tarea actual y actualizar la subtarea

    Subtarea updatedSubtarea = Subtarea(
      id: subtarea.id,
      name: subtarea.name,
      done: subtarea.done,
      completedBy: subtarea.done ? currentUser.uid : '',
      description: subtarea.description,
    );

    // Crear una lista de subtareas actualizada
    List<Subtarea> updatedSubtareas = _subtareas.map((subtarea) {
      if (subtarea.id == updatedSubtarea.id) {
        return updatedSubtarea;
      }
      return subtarea;
    }).toList();

    TareaFirestore updatedTarea = TareaFirestore(
      createdBy: widget.currentUser.uid,
      id: widget.tarea.id,
      name: widget.tarea.name,
      description: widget.tarea.description,
      startDate: widget.tarea.startDate,
      endDate: widget.tarea.endDate,
      subtareas: updatedSubtareas,
      asignados: widget.tarea.asignados,
      comentarios: widget.tarea.comentarios,
      sprintId: widget.tarea.sprintId,
      projectId: widget.tarea.projectId,
    );

    // Actualizar la tarea en Firestore
    await Provider.of<ProjectDataProvider>(context, listen: false)
        .updateTarea(updatedTarea);
  }
}
