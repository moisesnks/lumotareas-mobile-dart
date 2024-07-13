class Question {
  final String enunciado;
  final String tipo;
  final bool required;
  final List<dynamic> opciones;
  final int? maxLength;

  Question({
    required this.enunciado,
    required this.tipo,
    required this.required,
    this.opciones = const [],
    this.maxLength = 150,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      enunciado: map['enunciado'],
      tipo: map['tipo'],
      required: map['required'],
      opciones: map['opciones'],
      maxLength: map['maxLength'],
    );
  }

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
