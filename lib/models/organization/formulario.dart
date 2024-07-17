//Modelo de Formulario en la organización
library;

import 'pregunta.dart';

/// Clase que representa un formulario con un título y una lista de preguntas.
class Formulario {
  final String titulo;
  final List<Pregunta> preguntas;

  /// Constructor para crear una instancia de [Formulario].
  ///
  /// [titulo] es el título del formulario.
  /// [preguntas] es una lista de instancias de [Pregunta] que componen el formulario.
  Formulario({
    required this.titulo,
    required this.preguntas,
  });

  /// Crea una instancia de [Formulario] a partir de un mapa.
  ///
  /// [map] es el mapa que contiene los datos del formulario.
  factory Formulario.fromMap(Map<String, dynamic> map) {
    return Formulario(
      titulo: map['titulo'] ?? '',
      preguntas: (map['preguntas'] as List<dynamic>?)
              ?.map((pregunta) => Pregunta.fromMap(pregunta))
              .toList() ??
          [],
    );
  }

  /// Convierte una instancia de [Formulario] a un mapa.
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
