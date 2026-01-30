import 'package:projectsandtasks/features/tasks/data/models/assign_tasks_request.dart';
import 'package:projectsandtasks/features/tasks/data/models/create_tasks_request.dart';
import 'package:projectsandtasks/features/tasks/data/models/task_model.dart';
import 'package:projectsandtasks/features/tasks/data/models/update_task_status_request.dart';

abstract class TasksRepository {
  Future<List<TaskModel>> getProjectTasks(int projectId);
  Future<List<TaskModel>> addTasks(int projectId, CreateTasksRequest request);
  Future<List<TaskModel>> assignTasks(AssignTasksRequest request);
  Future<List<TaskModel>> getMyTasks({int? page, int? limit});
  Future<TaskModel> updateTaskStatus(int taskId, UpdateTaskStatusRequest request);
}
