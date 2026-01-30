import 'package:equatable/equatable.dart';

/// Task item from GET /api/projects/{id}/tasks and related endpoints.
class TaskModel extends Equatable {
  final int id;
  final int projectId;
  final String projectName;
  final String title;
  final String description;
  final String status;

  const TaskModel({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.title,
    required this.description,
    required this.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      projectId: json['projectId'] as int? ?? 0,
      projectName: json['projectName'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'open',
    );
  }

  @override
  List<Object?> get props => [id, projectId, projectName, title, description, status];
}
