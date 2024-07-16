class Pregunta {
  final String enunciado;
  final String tipo;
  final bool required;
  final List<Opcion>? opciones;
  final int? maxLength;
  bool returnLabel;

  Pregunta({
    required this.enunciado,
    required this.tipo,
    required this.required,
    this.opciones = const [],
    this.maxLength = 150,
    this.returnLabel = false,
  });

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

class Opcion {
  final String id;
  final String label;

  Opcion({
    required this.id,
    required this.label,
  });

  factory Opcion.fromMap(Map<String, dynamic> map) {
    return Opcion(
      id: map['id'] ?? '',
      label: map['label'] ?? '',
    );
  }

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
