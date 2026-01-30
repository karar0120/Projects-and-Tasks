import 'package:dartz/dartz.dart';
import 'package:projectsandtasks/core/network/api_error_model.dart';
import 'package:projectsandtasks/core/network/dio_consumer.dart';
import 'package:projectsandtasks/features/tasks/data/constants/tasks_api_constants.dart';
import 'package:projectsandtasks/features/tasks/data/models/assign_tasks_request.dart';
import 'package:projectsandtasks/features/tasks/data/models/create_tasks_request.dart';
import 'package:projectsandtasks/features/tasks/data/models/task_model.dart';
import 'package:projectsandtasks/features/tasks/data/models/update_task_status_request.dart';

abstract class TasksRemoteDataSource {
  Future<Either<ApiErrorModel, List<TaskModel>>> getProjectTasks(int projectId);
  Future<Either<ApiErrorModel, List<TaskModel>>> addTasks(int projectId, CreateTasksRequest request);
  Future<Either<ApiErrorModel, List<TaskModel>>> assignTasks(AssignTasksRequest request);
  Future<Either<ApiErrorModel, List<TaskModel>>> getMyTasks({int? page, int? limit});
  Future<Either<ApiErrorModel, TaskModel>> updateTaskStatus(int taskId, UpdateTaskStatusRequest request);
}

class TasksRemoteDataSourceImpl implements TasksRemoteDataSource {
  @override
  Future<Either<ApiErrorModel, List<TaskModel>>> getProjectTasks(int projectId) async {
    final response = await WebService.getNoLang(
      controller: TasksApiConstants.baseUrl,
      endpoint: TasksApiConstants.projectTasksEndpoint(projectId),
      headers: WebService.getRequestHeadersApplication(),
    );

    return response.fold(
      (error) => left(error),
      (res) {
        final data = res.data;
        if (data is! List) {
          return left(const ApiErrorModel(message: 'Invalid response'));
        }
        final list = data
            .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(list);
      },
    );
  }

  @override
  Future<Either<ApiErrorModel, List<TaskModel>>> addTasks(int projectId, CreateTasksRequest request) async {
    final response = await WebService.postNoLang(
      controller: TasksApiConstants.baseUrl,
      endpoint: TasksApiConstants.addTasksEndpoint(projectId),
      headers: WebService.getRequestHeadersApplication(),
      body: request.toJson(),
    );

    return response.fold(
      (error) => left(error),
      (res) {
        final data = res.data;
        if (data is! List) {
          return left(const ApiErrorModel(message: 'Invalid response'));
        }
        final list = data
            .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(list);
      },
    );
  }

  @override
  Future<Either<ApiErrorModel, List<TaskModel>>> assignTasks(AssignTasksRequest request) async {
    final response = await WebService.putNoLang(
      controller: TasksApiConstants.baseUrl,
      endpoint: TasksApiConstants.assignEndpoint,
      headers: WebService.getRequestHeadersApplication(),
      body: request.toJson(),
    );

    return response.fold(
      (error) => left(error),
      (res) {
        final data = res.data;
        if (data is! List) {
          return left(const ApiErrorModel(message: 'Invalid response'));
        }
        final list = data
            .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(list);
      },
    );
  }

  @override
  Future<Either<ApiErrorModel, List<TaskModel>>> getMyTasks({int? page, int? limit}) async {
    Map<String, dynamic>? query;
    if (page != null && limit != null) {
      query = {'page': page, 'limit': limit};
    }
    final response = await WebService.getNoLang(
      controller: TasksApiConstants.baseUrl,
      endpoint: TasksApiConstants.myTasksEndpoint,
      headers: WebService.getRequestHeadersApplication(),
      query: query,
    );

    return response.fold(
      (error) {
        // 404 = endpoint not implemented or no resource: show empty "My Tasks" list
        if (error.code == 404) {
          return right(<TaskModel>[]);
        }
        return left(error);
      },
      (res) {
        final data = res.data;
        if (data is! List) {
          return left(const ApiErrorModel(message: 'Invalid response'));
        }
        final list = data
            .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(list);
      },
    );
  }

  @override
  Future<Either<ApiErrorModel, TaskModel>> updateTaskStatus(
    int taskId,
    UpdateTaskStatusRequest request,
  ) async {
    final response = await WebService.putNoLang(
      controller: TasksApiConstants.baseUrl,
      endpoint: TasksApiConstants.taskStatusEndpoint(taskId),
      headers: WebService.getRequestHeadersApplication(),
      body: request.toJson(),
    );

    return response.fold(
      (error) => left(error),
      (res) {
        final data = res.data;
        if (data is! Map<String, dynamic>) {
          return left(const ApiErrorModel(message: 'Invalid response'));
        }
        return right(TaskModel.fromJson(data));
      },
    );
  }
}
