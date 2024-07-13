import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lumotareas/models/question.dart';
import 'package:lumotareas/models/project.dart';
import 'package:lumotareas/services/preferences_service.dart';
import 'package:lumotareas/services/organization_service.dart';

class CreateProjectLogic {
  List<Question> preguntasCrearProyecto = [];
  final Logger _logger = Logger();
  final Future<String?> currentOrganizationId =
      PreferenceService.getCurrentOrganization();

  final Future<List<Map<String, dynamic>>> usuarios =
      PreferenceService.getMiembros();

  CreateProjectLogic() {
    _initPreguntasCrearProyecto();
  }

  Future<void> _initPreguntasCrearProyecto() async {
    final List<Map<String, dynamic>> usuarios =
        await PreferenceService.getMiembros();

    preguntasCrearProyecto = [
      Question(
        enunciado: 'Nombre del Proyecto',
        tipo: 'desarrollo',
        required: true,
        maxLength: 16,
      ),
      Question(
        enunciado: 'Descripción del Proyecto',
        tipo: 'desarrollo',
        required: true,
      ),
      Question(
        enunciado: 'Miembros Asignados',
        tipo: 'seleccion_multiple',
        opciones: usuarios
            .map((usuario) => Opcion(
                  id: usuario['uid'],
                  label: usuario['nombre'],
                ))
            .toList(),
        required: true,
      ),
    ];
  }

  // Método público para inicializar preguntas
  Future<void> initPreguntasCrearProyecto() async {
    await _initPreguntasCrearProyecto();
  }

// // Crear un proyecto dentro de la organización
//   Future<Map<String, dynamic>> createProject(
//       String orgName, Project project) async {
//     try {
//       // Convertir el objeto Project a un mapa para almacenarlo
//       Map<String, dynamic> data = project.toMap();

//       final result = await _firestoreService.addDocument(
//           'organizaciones/$orgName/proyectos', project.id, data);

//       if (result['success']) {
//         return {
//           'success': true,
//           'message': 'Proyecto creado correctamente',
//           'ref': result['documentId'],
//         };
//       } else {
//         return {
//           'success': false,
//           'message': 'Error al crear el proyecto',
//         };
//       }
//     } catch (e) {
//       return {
//         'success': false,
//         'message': 'Error al crear el proyecto: $e',
//       };
//     }
//   }
  void createProject(BuildContext context, Project project) async {
    final String? orgId = await currentOrganizationId;
    if (orgId != null) {
      // Pushear una ventana emergente de carga
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      final Map<String, dynamic> response =
          await OrganizationService().createProject(orgId, project);
      _logger.i('Respuesta de la creación del proyecto: $response');
      // Popear el indicador de carga
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      if (response['success']) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Proyecto creado correctamente'),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al crear el proyecto'),
            ),
          );
        }
      }
    } else {
      _logger.e('No se pudo obtener el ID de la organización actual');
    }
    // Esperar un segundo antes de cerrar la pantalla
    await Future.delayed(const Duration(seconds: 1));
    if (context.mounted) {
      // navega a main recargando la pantalla
      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
    }
  }

  Future<List<Map<String, dynamic>>> getUsuarios() async {
    return await PreferenceService.getMiembros();
  }

  void logSubmit(BuildContext context, Map<String, dynamic> respuestas) {
    _logger.i('Respuestas del formulario: $respuestas');
    final Project project = Project(
      nombre: respuestas['Nombre del Proyecto'],
      descripcion: respuestas['Descripción del Proyecto'],
      asignados: respuestas['Miembros Asignados'],
    );
    _logger.i('Proyecto a crear: $project');
    createProject(context, project);
  }
}
