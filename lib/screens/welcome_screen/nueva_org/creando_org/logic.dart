import 'package:lumotareas/models/organization.dart';

List<Map<String, dynamic>> getPreguntas(String orgName) {
  final preguntas = [
    {
      'titulo': 'Descripción',
      'enunciado': 'Descripción',
      'tipo': 'desarrollo',
      'required': true,
    },
    {
      'titulo': '¿Tiene vacantes?',
      'enunciado': '¿Tiene vacantes?',
      'tipo': 'booleano',
      'required': false,
    },
  ];

  if (orgName.isEmpty) {
    preguntas.insert(
      0,
      {
        'titulo': 'Nombre de la organización',
        'enunciado': 'Nombre de la organización',
        'tipo': 'desarrollo',
        'required': true,
        'max_length': 16,
      },
    );
  }

  return preguntas;
}

Organization createOrganizationFromResponses(
    String orgName, String? ownerUID, Map<String, dynamic> respuestas) {
  return Organization(
    nombre: respuestas['Nombre de la organización'] ?? orgName ?? '',
    owner: Owner(nombre: orgName, uid: ownerUID ?? ''),
    descripcion: respuestas['Descripción'] ?? '',
    vacantes: respuestas['¿Tiene vacantes?'] ?? "false",
    miembros: [ownerUID ?? ''],
    formulario: {},
  );
}
