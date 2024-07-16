/// Representa una pregunta con atributos específicos.
///
/// Una pregunta tiene un [enunciado], un [tipo] de respuesta, un indicador de si es [required] responderla,
/// una lista de [opciones] posibles (opcional) y una longitud máxima de caracteres [maxLength] (opcional).
class Question {
  final String enunciado;
  final String tipo;
  final bool required;
  final List<Opcion> opciones;
  final int? maxLength;
  final bool returnLabel;

  /// Constructor para inicializar una pregunta con los atributos requeridos y opcionales.
  Question({
    required this.enunciado,
    required this.tipo,
    required this.required,
    this.opciones = const [],
    this.maxLength = 150,
    this.returnLabel = false,
  });

  /// Constructor de fábrica que crea un objeto [Question] a partir de un mapa [Map<String, dynamic>].
  ///
  /// Utiliza las claves del mapa para asignar valores a los atributos de la pregunta.
  factory Question.fromMap(Map<String, dynamic> map) {
    List<dynamic> opciones = map['opciones'] ?? [];
    List<Opcion> parsedOpciones = opciones
        .map((opcion) => Opcion.fromMap(opcion))
        .toList(); // Cambio: Parsear cada opción a objeto Opcion
    return Question(
      enunciado: map['enunciado'] ?? '',
      tipo: map['tipo'] ?? '',
      required: map['required'] ?? false,
      opciones: parsedOpciones,
      maxLength: map['maxLength'] ?? 150,
      returnLabel: map['returnLabel'] ?? false,
    );
  }

  /// Convierte el objeto [Question] en un mapa [Map<String, dynamic>].
  ///
  /// Cada atributo de la pregunta se convierte en una entrada en el mapa.
  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> mappedOpciones = opciones
        .map((opcion) => opcion.toMap())
        .toList(); // Cambio: Convertir cada opción a un mapa
    return {
      'enunciado': enunciado,
      'tipo': tipo,
      'required': required,
      'opciones': mappedOpciones,
      'maxLength': maxLength,
      'returnLabel': returnLabel,
    };
  }

  @override
  String toString() {
    return 'Question{enunciado: $enunciado, tipo: $tipo, required: $required, opciones: $opciones, maxLength: $maxLength}';
  }
}

/// Clase que representa una opción de respuesta para una pregunta.
class Opcion {
  final String id;
  final String label;

  Opcion({
    required this.id,
    required this.label,
  });

  /// Constructor de fábrica que crea un objeto [Opcion] a partir de un mapa [Map<String, dynamic>].
  ///
  /// Utiliza las claves del mapa para asignar valores a los atributos de la opción.
  factory Opcion.fromMap(Map<String, dynamic> map) {
    return Opcion(
      id: map['id'] ?? '',
      label: map['label'] ?? '',
    );
  }

  /// Convierte el objeto [Opcion] en un mapa [Map<String, dynamic>].
  ///
  /// Cada atributo de la opción se convierte en una entrada en el mapa.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
    };
  }

  @override
  String toString() {
    return 'Opcion{id: $id, label: $label}';
  }
}
