/// Representa una pregunta con atributos específicos.
///
/// Una pregunta tiene un [enunciado], un [tipo] de respuesta, un indicador de si es [required] responderla,
/// una lista de [opciones] posibles (opcional) y una longitud máxima de caracteres [maxLength] (opcional).
class Question {
  final String enunciado;
  final String tipo;
  final bool required;
  final List<dynamic> opciones;
  final int? maxLength;

  /// Constructor para inicializar una pregunta con los atributos requeridos y opcionales.
  Question({
    required this.enunciado,
    required this.tipo,
    required this.required,
    this.opciones = const [],
    this.maxLength = 150,
  });

  /// Constructor de fábrica que crea un objeto [Question] a partir de un mapa [Map<String, dynamic>].
  ///
  /// Utiliza las claves del mapa para asignar valores a los atributos de la pregunta.
  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      enunciado: map['enunciado'],
      tipo: map['tipo'],
      required: map['required'],
      opciones: map['opciones'],
      maxLength: map['maxLength'],
    );
  }

  /// Convierte el objeto [Question] en un mapa [Map<String, dynamic>].
  ///
  /// Cada atributo de la pregunta se convierte en una entrada en el mapa.
  Map<String, dynamic> toMap() {
    return {
      'enunciado': enunciado,
      'tipo': tipo,
      'required': required,
      'opciones': opciones,
      'maxLength': maxLength,
    };
  }
}
