import 'package:equatable/equatable.dart';

/// Single task input for POST /api/projects/with-tasks.
class ProjectTaskInput extends Equatable {
  final String title;
  final String description;
  final String status;

  const ProjectTaskInput({
    required this.title,
    required this.description,
    this.status = 'open',
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'status': status,
      };

  @override
  List<Object?> get props => [title, description, status];
}

/// Request body for POST /api/projects/with-tasks (create project + tasks in one flow).
class CreateProjectWithTasksRequest extends Equatable {
  final String name;
  final String description;
  final List<ProjectTaskInput> tasks;

  const CreateProjectWithTasksRequest({
    required this.name,
    required this.description,
    required this.tasks,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'tasks': tasks.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [name, description, tasks];
}
