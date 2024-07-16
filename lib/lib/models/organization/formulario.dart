import 'pregunta.dart';

class Formulario {
  final String titulo;
  final List<Pregunta> preguntas;

  Formulario({
    required this.titulo,
    required this.preguntas,
  });

  factory Formulario.fromMap(Map<String, dynamic> map) {
    return Formulario(
      titulo: map['titulo'] ?? '',
      preguntas: (map['preguntas'] as List<dynamic>?)
              ?.map((pregunta) => Pregunta.fromMap(pregunta))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'titulo': titulo,
      'preguntas': preguntas.map((pregunta) => pregunta.toMap()).toList(),
    };
  }

  @override
  String toString() {
    return 'Formulario: $titulo, Preguntas: $preguntas';
  }
}
