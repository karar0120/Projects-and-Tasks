import 'package:projectsandtasks/core/network/api_error_model.dart';
import 'package:projectsandtasks/features/tasks/data/datasources/tasks_remote_datasource.dart';
import 'package:projectsandtasks/features/tasks/data/models/assign_tasks_request.dart';
import 'package:projectsandtasks/features/tasks/data/models/create_tasks_request.dart';
import 'package:projectsandtasks/features/tasks/data/models/task_model.dart';
import 'package:projectsandtasks/features/tasks/data/models/update_task_status_request.dart';
import 'package:projectsandtasks/features/tasks/domain/repositories/tasks_repository.dart';

class TasksRepositoryImpl implements TasksRepository {
  TasksRepositoryImpl({TasksRemoteDataSource? remoteDataSource})
      : _remote = remoteDataSource ?? TasksRemoteDataSourceImpl();

  final TasksRemoteDataSource _remote;

  @override
  Future<List<TaskModel>> getProjectTasks(int projectId) async {
    final result = await _remote.getProjectTasks(projectId);
    return result.fold(
      (error) => throw TasksException(error),
      (list) => list,
    );
  }

  @override
  Future<List<TaskModel>> addTasks(int projectId, CreateTasksRequest request) async {
    final result = await _remote.addTasks(projectId, request);
    return result.fold(
      (error) => throw TasksException(error),
      (list) => list,
    );
  }

  @override
  Future<List<TaskModel>> assignTasks(AssignTasksRequest request) async {
    final result = await _remote.assignTasks(request);
    return result.fold(
      (error) => throw TasksException(error),
      (list) => list,
    );
  }

  @override
  Future<List<TaskModel>> getMyTasks({int? page, int? limit}) async {
    final result = await _remote.getMyTasks(page: page, limit: limit);
    return result.fold(
      (error) => throw TasksException(error),
      (list) => list,
    );
  }

  @override
  Future<TaskModel> updateTaskStatus(int taskId, UpdateTaskStatusRequest request) async {
    final result = await _remote.updateTaskStatus(taskId, request);
    return result.fold(
      (error) => throw TasksException(error),
      (task) => task,
    );
  }
}

class TasksException implements Exception {
  TasksException(this.apiError);
  final ApiErrorModel apiError;
  String get message => apiError.message ?? 'Tasks error';
}
