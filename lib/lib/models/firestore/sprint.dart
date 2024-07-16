import 'package:cloud_firestore/cloud_firestore.dart';

class SprintFirestore {
  final String id;
  final String name;
  final String description;
  final Timestamp startDate;
  final Timestamp endDate;
  final String projectId;
  final List<String> tasks;
  final List<String> members;
  final String createdBy;

  SprintFirestore({
    required this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.projectId,
    required this.tasks,
    required this.members,
    required this.createdBy,
  });

  factory SprintFirestore.fromMap(Map<String, dynamic> map) {
    return SprintFirestore(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      startDate: map['startDate'] ?? '',
      endDate: map['endDate'] ?? '',
      projectId: map['projectId'] ?? '',
      tasks: (map['tasks'] as List<dynamic>?)
              ?.map((task) => task.toString())
              .toList() ??
          [],
      members: (map['members'] as List<dynamic>?)
              ?.map((member) => member.toString())
              .toList() ??
          [],
      createdBy: map['createdBy'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'projectId': projectId,
      'tasks': tasks,
      'members': members,
      'createdBy': createdBy,
    };
  }

  @override
  String toString() {
    return 'SprintFirestore: $id, Name: $name, Description: $description, Start Date: $startDate, End Date: $endDate, Project ID: $projectId, Tasks: $tasks, Members: $members';
  }

  @override
  factory SprintFirestore.empty() {
    return SprintFirestore(
      id: '',
      name: '',
      description: '',
      startDate: Timestamp.fromDate(DateTime.now()),
      endDate: Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
      projectId: '',
      tasks: [],
      members: [],
      createdBy: '',
    );
  }

  factory SprintFirestore.onlyId(String id) {
    return SprintFirestore(
      id: id,
      name: '',
      description: '',
      startDate: Timestamp.fromDate(DateTime.now()),
      endDate: Timestamp.fromDate(DateTime.now().add(const Duration(days: 7))),
      projectId: '',
      tasks: [],
      members: [],
      createdBy: '',
    );
  }
}
