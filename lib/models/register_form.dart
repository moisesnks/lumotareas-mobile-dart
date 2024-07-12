class RegisterForm {
  final String birthDate;
  final String orgName;
  Map<String, dynamic>? respuestas;
  bool isOwner;

  RegisterForm({
    required this.birthDate,
    this.orgName = '',
    this.respuestas,
    this.isOwner = false,
  });
}
