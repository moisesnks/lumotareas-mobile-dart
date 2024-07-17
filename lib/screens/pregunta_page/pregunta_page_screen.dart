import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lumotareas/models/firestore/subtarea.dart';
import 'package:lumotareas/models/organization/pregunta.dart';

import 'widgets/formulario_list.dart';
import 'widgets/subtareas_list.dart';

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
      case 'formulario':
        respuestaVisual =
            widget.respuesta != null ? (widget.respuesta as List<dynamic>) : [];
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

  void addPregunta() {
    setState(() {
      respuestaVisual.add(Pregunta(
        enunciado: '',
        tipo: 'desarrollo',
        required: false,
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

  void updatePregunta(Pregunta pregunta, int index) {
    setState(() {
      // Verificar si el índice es válido antes de actualizar
      if (index >= 0 && index < respuestaVisual.length) {
        respuestaVisual[index] = pregunta;
      } else {
        return;
      }
    });
    widget.onChanged(respuestaVisual); // Enviar respuesta como List<Pregunta>
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
            widget.pregunta.tipo == 'formulario'
                ? ''
                : widget.pregunta.enunciado,
            style: const TextStyle(fontSize: 18)),
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
          SwitchListTile(
            title: Text(widget.pregunta.enunciado),
            value: respuestaVisual,
            onChanged: (value) {
              setState(() {
                respuestaVisual = value;
                respuestaActual = value;
              });
              widget.onChanged(value);
            },
          ),
        if (widget.pregunta.tipo == 'fecha')
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: respuestaVisual as DateTime,
                    firstDate: DateTime(2015, 8),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != respuestaVisual) {
                    setState(() {
                      respuestaVisual = picked;
                      respuestaActual = Timestamp.fromDate(picked);
                    });
                    widget.onChanged(Timestamp.fromDate(picked));
                  }
                },
                child: Text(
                  'Seleccionar fecha: ${respuestaVisual.toString().substring(0, 10)}',
                ),
              ),
            ],
          ),
        if (widget.pregunta.tipo == 'subtareas')
          SizedBox(
            height: 400,
            width: MediaQuery.of(context).size.width,
            child: SubtareasListWidget(
              respuestaVisual: respuestaVisual,
              updateSubtarea: updateSubtarea,
              addSubtarea: addSubtarea,
            ),
          ),
        if (widget.pregunta.tipo == 'formulario')
          FormularioListWidget(
            respuestaVisual: respuestaVisual,
            updatePregunta: updatePregunta,
            addPregunta: addPregunta,
          ),
        const SizedBox(height: 20),
      ],
    );
  }
}
