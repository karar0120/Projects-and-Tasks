import 'package:equatable/equatable.dart';

/// Single task item for POST add_tasks body.
class CreateTaskItem extends Equatable {
  final String title;
  final String description;
  final String status;

  const CreateTaskItem({
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

/// Request body for POST /api/projects/{projectId}/add_tasks
class CreateTasksRequest extends Equatable {
  final List<CreateTaskItem> tasks;

  const CreateTasksRequest({required this.tasks});

  Map<String, dynamic> toJson() => {
        'tasks': tasks.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [tasks];
}
