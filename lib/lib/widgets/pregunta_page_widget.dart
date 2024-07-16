import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:lumotareas/lib/models/firestore/tareas.dart';
import 'package:lumotareas/lib/models/organization/pregunta.dart';

class PreguntaPage extends StatefulWidget {
  final Pregunta pregunta;
  final dynamic respuesta;
  final ValueChanged<dynamic> onChanged;

  const PreguntaPage({
    super.key,
    required this.pregunta,
    required this.respuesta,
    required this.onChanged,
  });

  @override
  PreguntaPageState createState() => PreguntaPageState();
}

class PreguntaPageState extends State<PreguntaPage> {
  late dynamic respuestaVisual; // Para manejar la respuesta visualmente
  late dynamic respuestaActual; // Para manejar la respuesta internamente

  @override
  void initState() {
    super.initState();
    initRespuestas();
  }

  void initRespuestas() {
    // Inicializar respuesta visual
    switch (widget.pregunta.tipo) {
      case 'seleccion_unica':
      case 'seleccion_multiple':
        respuestaVisual = widget.respuesta ?? [];
        break;
      case 'booleano':
        respuestaVisual = widget.respuesta is bool ? widget.respuesta : false;
        break;
      case 'desarrollo':
        respuestaVisual = widget.respuesta ?? '';
        break;
      case 'fecha':
        respuestaVisual =
            widget.respuesta != null && widget.respuesta is Timestamp
                ? (widget.respuesta as Timestamp).toDate()
                : DateTime.now();
        break;
      case 'subtareas':
        respuestaVisual = widget.respuesta != null
            ? (widget.respuesta as List)
                .map((e) => Subtarea.fromMap(e))
                .toList()
            : [];
        break;
      default:
        respuestaVisual = widget.respuesta ?? '';
    }

    // Inicializar respuesta actual (para el manejo interno)
    respuestaActual = widget.respuesta;
  }

  void addSubtarea() {
    setState(() {
      respuestaVisual.add(Subtarea(
        id: '',
        name: '',
        description: '',
        done: false,
      ));
    });
  }

  void updateSubtarea(Subtarea subtarea, int index) {
    setState(() {
      // Verificar si el índice es válido antes de actualizar
      if (index >= 0 && index < respuestaVisual.length) {
        respuestaVisual[index] = subtarea;
        respuestaActual = List.from(respuestaVisual);
      } else {
        return;
      }
    });
    widget.onChanged(respuestaActual);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.pregunta.enunciado}${widget.pregunta.required ? ' *' : ''}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        if (widget.pregunta.tipo == 'seleccion_unica')
          ...widget.pregunta.opciones!.map<Widget>((opcion) => RadioListTile(
                title: Text(opcion.label),
                value: widget.pregunta.returnLabel ? opcion.label : opcion.id,
                groupValue: respuestaVisual,
                onChanged: (value) {
                  setState(() {
                    respuestaVisual = value;
                    respuestaActual = value;
                  });
                  widget.onChanged(value);
                },
              )),
        if (widget.pregunta.tipo == 'seleccion_multiple')
          ...widget.pregunta.opciones!.map<Widget>((opcion) => CheckboxListTile(
                title: Text(opcion.label),
                value: widget.pregunta.returnLabel
                    ? respuestaVisual.contains(opcion.label)
                    : respuestaVisual.contains(opcion.id),
                onChanged: (checked) {
                  List<String> newRespuesta = List.from(respuestaActual ?? []);
                  if (checked!) {
                    widget.pregunta.returnLabel
                        ? newRespuesta.add(opcion.label)
                        : newRespuesta.add(opcion.id);
                  } else {
                    widget.pregunta.returnLabel
                        ? newRespuesta.remove(opcion.label)
                        : newRespuesta.remove(opcion.id);
                  }
                  setState(() {
                    respuestaVisual = newRespuesta;
                    respuestaActual = newRespuesta;
                  });
                  widget.onChanged(newRespuesta);
                },
              )),
        if (widget.pregunta.tipo == 'desarrollo')
          TextFormField(
            maxLines: null,
            maxLength: widget.pregunta.maxLength ?? 150,
            initialValue: respuestaVisual,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
            onChanged: (value) {
              setState(() {
                respuestaVisual = value;
                respuestaActual = value;
              });
              widget.onChanged(value);
            },
          ),
        if (widget.pregunta.tipo == 'booleano')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioListTile(
                title: const Text('Sí'),
                value: true,
                groupValue: respuestaVisual,
                onChanged: (value) {
                  setState(() {
                    respuestaVisual = value;
                    respuestaActual = value;
                  });
                  widget.onChanged(value);
                },
              ),
              RadioListTile(
                title: const Text('No'),
                value: false,
                groupValue: respuestaVisual,
                onChanged: (value) {
                  setState(() {
                    respuestaVisual = value;
                    respuestaActual = value;
                  });
                  widget.onChanged(value);
                },
              ),
            ],
          ),
        if (widget.pregunta.tipo == 'fecha')
          TextFormField(
            controller: TextEditingController(
              text: respuestaVisual is DateTime
                  ? DateFormat('yyyy-MM-dd').format(respuestaVisual)
                  : '',
            ),
            readOnly: true,
            onTap: () async {
              final DateTime? selectedDate = await showDatePicker(
                context: context,
                initialDate: respuestaVisual ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (selectedDate != null) {
                setState(() {
                  respuestaVisual = selectedDate;
                  respuestaActual = Timestamp.fromDate(selectedDate);
                });
                widget.onChanged(Timestamp.fromDate(selectedDate));
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            ),
          ),
        if (widget.pregunta.tipo == 'subtareas')
          SizedBox(
            height: 280,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ...respuestaVisual.map<Widget>((subtarea) => SubtareaWidget(
                        subtarea: subtarea,
                        onChanged: (updatedSubtarea) {
                          int index = respuestaVisual.indexOf(subtarea);
                          updateSubtarea(updatedSubtarea, index);
                        },
                      )),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: addSubtarea,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class SubtareaWidget extends StatelessWidget {
  final Subtarea subtarea;
  final ValueChanged<Subtarea> onChanged;

  const SubtareaWidget({
    super.key,
    required this.subtarea,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: subtarea.name,
          decoration: const InputDecoration(
            labelText: 'Nombre de la subtarea',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            onChanged(
              Subtarea(
                id: subtarea.id,
                name: value,
                description: subtarea.description,
                done: subtarea.done,
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: subtarea.description,
          decoration: const InputDecoration(
            labelText: 'Descripción de la subtarea',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            onChanged(
              Subtarea(
                id: subtarea.id,
                name: subtarea.name,
                description: value,
                done: subtarea.done,
              ),
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
