import 'package:equatable/equatable.dart';
import 'package:projectsandtasks/features/tasks/data/models/task_model.dart';

/// Response from POST /api/projects/with-tasks.
class CreateProjectWithTasksResponse extends Equatable {
  final int projectId;
  final String projectName;
  final String projectDescription;
  final String projectCreatedAt;
  final List<TaskModel> tasks;

  const CreateProjectWithTasksResponse({
    required this.projectId,
    required this.projectName,
    required this.projectDescription,
    required this.projectCreatedAt,
    required this.tasks,
  });

  factory CreateProjectWithTasksResponse.fromJson(Map<String, dynamic> json) {
    final tasksList = json['tasks'] as List<dynamic>? ?? [];
    return CreateProjectWithTasksResponse(
      projectId: json['projectId'] as int? ?? 0,
      projectName: json['projectName'] as String? ?? '',
      projectDescription: json['projectDescription'] as String? ?? '',
      projectCreatedAt: json['projectCreatedAt'] as String? ?? '',
      tasks: tasksList
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [projectId, projectName, projectDescription, projectCreatedAt, tasks];
}
