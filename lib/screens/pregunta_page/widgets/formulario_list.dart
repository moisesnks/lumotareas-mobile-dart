import 'package:flutter/material.dart';
import 'package:lumotareas/models/organization/pregunta.dart';
import 'pregunta_widget.dart';

class FormularioListWidget extends StatefulWidget {
  final List<dynamic> respuestaVisual;
  final Function(Pregunta, int) updatePregunta;
  final VoidCallback addPregunta;

  const FormularioListWidget({
    super.key,
    required this.respuestaVisual,
    required this.updatePregunta,
    required this.addPregunta,
  });

  @override
  FormularioListWidgetState createState() => FormularioListWidgetState();
}

class FormularioListWidgetState extends State<FormularioListWidget> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400, // Altura fija para el contenedor
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.respuestaVisual.length + 1,
        itemBuilder: (context, index) {
          if (index < widget.respuestaVisual.length) {
            return PreguntaWidget(
              pregunta: widget.respuestaVisual[index] as Pregunta,
              onChanged: (pregunta) => widget.updatePregunta(pregunta, index),
            );
          } else {
            return Center(
              child: TextButton(
                onPressed: widget.addPregunta,
                child: const Text('Agregar Pregunta'),
              ),
            );
          }
        },
      ),
    );
  }
}
