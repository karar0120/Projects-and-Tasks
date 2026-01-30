import 'package:equatable/equatable.dart';

/// Request body for PUT /api/tasks/assign
class AssignTasksRequest extends Equatable {
  final int userId;
  final List<int> taskIds;

  const AssignTasksRequest({
    required this.userId,
    required this.taskIds,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'taskIds': taskIds,
      };

  @override
  List<Object?> get props => [userId, taskIds];
}
