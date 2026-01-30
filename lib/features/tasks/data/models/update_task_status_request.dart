import 'package:equatable/equatable.dart';

/// Request body for PUT /api/tasks/{taskId}/status. Status: "open" | "completed".
class UpdateTaskStatusRequest extends Equatable {
  final String status;

  const UpdateTaskStatusRequest({required this.status});

  Map<String, dynamic> toJson() => {'status': status};

  @override
  List<Object?> get props => [status];
}
