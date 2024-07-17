//Modelo de Pregunta en el formulario
library;

/// Clase que representa una pregunta dentro de un formulario.
class Pregunta {
  final String enunciado; // Enunciado de la pregunta
  final String
      tipo; // Tipo de la pregunta (por ejemplo: texto, selección, etc.)
  final bool required; // Indica si la pregunta es obligatoria
  final List<Opcion>? opciones; // Lista de opciones para preguntas de selección
  final int? maxLength; // Longitud máxima permitida para la respuesta
  bool
      returnLabel; // Indica si se debe devolver la etiqueta de la opción seleccionada

  /// Constructor para crear una instancia de [Pregunta].
  ///
  /// [enunciado] es el enunciado de la pregunta.
  /// [tipo] es el tipo de la pregunta.
  /// [required] indica si la pregunta es obligatoria.
  /// [opciones] es una lista de opciones para preguntas de selección.
  /// [maxLength] es la longitud máxima permitida para la respuesta.
  /// [returnLabel] indica si se debe devolver la etiqueta de la opción seleccionada.
  Pregunta({
    required this.enunciado,
    required this.tipo,
    required this.required,
    this.opciones = const [],
    this.maxLength = 150,
    this.returnLabel = false,
  });

  /// Crea una instancia de [Pregunta] a partir de un mapa.
  ///
  /// [map] es el mapa que contiene los datos de la pregunta.
  factory Pregunta.fromMap(Map<String, dynamic> map) {
    return Pregunta(
      enunciado: map['enunciado'] ?? '',
      tipo: map['tipo'] ?? '',
      required: map['required'] ?? false,
      opciones: (map['opciones'] as List<dynamic>?)
              ?.map((opcion) => Opcion.fromMap(opcion))
              .toList() ??
          [],
      maxLength: map['maxLength'] ?? 150,
      returnLabel: map['returnLabel'] ?? false,
    );
  }

  /// Convierte una instancia de [Pregunta] a un mapa.
  Map<String, dynamic> toMap() {
    return {
      'enunciado': enunciado,
      'tipo': tipo,
      'required': required,
      'opciones': opciones?.map((opcion) => opcion.toMap()).toList(),
      'maxLength': maxLength,
      'returnLabel': returnLabel,
    };
  }

  @override
  String toString() {
    return 'Pregunta: $enunciado, Tipo: $tipo, Requerida: $required, Opciones: $opciones, MaxLength: $maxLength';
  }
}

/// Clase que representa una opción dentro de una pregunta de selección.
class Opcion {
  final String id; // Identificador único de la opción
  final String label; // Etiqueta de la opción

  /// Constructor para crear una instancia de [Opcion].
  ///
  /// [id] es el identificador único de la opción.
  /// [label] es la etiqueta de la opción.
  Opcion({
    required this.id,
    required this.label,
  });

  /// Crea una instancia de [Opcion] a partir de un mapa.
  ///
  /// [map] es el mapa que contiene los datos de la opción.
  factory Opcion.fromMap(Map<String, dynamic> map) {
    return Opcion(
      id: map['id'] ?? '',
      label: map['label'] ?? '',
    );
  }

  /// Convierte una instancia de [Opcion] a un mapa.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
    };
  }

  @override
  String toString() {
    return 'Opción: $id, Label: $label';
  }
}
