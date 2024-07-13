/// Representa un formulario de registro con atributos específicos.
///
/// El formulario de registro contiene información como la [birthDate] (fecha de nacimiento),
/// el nombre de la organización [orgName], las [respuestas] a las preguntas del formulario (opcional)
/// y un indicador de si el usuario es propietario [isOwner] de la organización.
class RegisterForm {
  final String birthDate;
  final String orgName;
  Map<String, dynamic>? respuestas;
  bool isOwner;

  /// Constructor para inicializar un formulario de registro con los atributos requeridos y opcionales.
  RegisterForm({
    required this.birthDate,
    this.orgName = '',
    this.respuestas,
    this.isOwner = false,
  });
}
