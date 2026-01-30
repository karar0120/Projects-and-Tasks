import 'package:equatable/equatable.dart';

/// Project item from GET /api/projects
class ProjectModel extends Equatable {
  final int id;
  final String name;
  final String description;
  final String createdAt;

  const ProjectModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, description, createdAt];
}
