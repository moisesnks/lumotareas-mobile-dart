class Solicitudes {
  final String id;
  final String orgName;

  Solicitudes({
    required this.id,
    required this.orgName,
  });

  factory Solicitudes.fromMap(Map<String, dynamic> map) {
    return Solicitudes(
      id: map['id'] ?? '',
      orgName: map['orgName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'orgName': orgName,
    };
  }

  @override
  String toString() {
    return 'Solicitudes{id: $id, orgName: $orgName}';
  }
}
