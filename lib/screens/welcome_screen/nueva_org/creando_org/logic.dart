import 'package:lumotareas/models/organization.dart';
import 'package:lumotareas/models/question.dart';

List<Question> getPreguntas(String orgName) {
  final List<Question> preguntas = [
    Question(
      enunciado: 'Descripción',
      tipo: 'desarrollo',
      required: true,
    ),
    Question(
      enunciado: '¿Tiene vacantes?',
      tipo: 'booleano',
      required: false,
    )
  ];

  if (orgName.isEmpty) {
    preguntas.insert(
      0,
      Question(
        enunciado: 'Nombre de la organización',
        tipo: 'desarrollo',
        required: true,
      ),
    );
  }

  return preguntas;
}

Organization createOrganizationFromResponses(String username, String orgName,
    String? ownerUID, Map<String, dynamic> respuestas) {
  return Organization(
    nombre: respuestas['Nombre de la organización'] ?? orgName ?? '',
    owner: Owner(nombre: username, uid: ownerUID ?? ''),
    descripcion: respuestas['Descripción'] ?? '',
    vacantes: respuestas['¿Tiene vacantes?'] ?? "false",
    miembros: [ownerUID ?? ''],
    formulario: {},
  );
}
