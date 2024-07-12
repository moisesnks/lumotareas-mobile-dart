class RegisterForm {
  final String fullName;
  final String birthDate;
  final String orgName;
  Map<String, dynamic>? respuestas;
  bool isOwner;

  RegisterForm({
    required this.fullName,
    required this.birthDate,
    required this.orgName,
    this.respuestas,
    this.isOwner = false,
  });
}
