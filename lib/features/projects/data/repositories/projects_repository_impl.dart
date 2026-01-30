import 'package:projectsandtasks/core/network/api_error_model.dart';
import 'package:projectsandtasks/features/projects/data/datasources/projects_remote_datasource.dart';
import 'package:projectsandtasks/features/projects/data/models/create_project_request.dart';
import 'package:projectsandtasks/features/projects/data/models/create_project_with_tasks_request.dart';
import 'package:projectsandtasks/features/projects/data/models/create_project_with_tasks_response.dart';
import 'package:projectsandtasks/features/projects/data/models/project_model.dart';
import 'package:projectsandtasks/features/projects/domain/repositories/projects_repository.dart';

class ProjectsRepositoryImpl implements ProjectsRepository {
  ProjectsRepositoryImpl({ProjectsRemoteDataSource? remoteDataSource})
      : _remote = remoteDataSource ?? ProjectsRemoteDataSourceImpl();

  final ProjectsRemoteDataSource _remote;

  @override
  Future<List<ProjectModel>> getProjects({int? page, int? limit}) async {
    final result = await _remote.getProjects(page: page, limit: limit);
    return result.fold(
      (error) => throw ProjectsException(error),
      (list) => list,
    );
  }

  @override
  Future<ProjectModel> createProject(CreateProjectRequest request) async {
    final result = await _remote.createProject(request);
    return result.fold(
      (error) => throw ProjectsException(error),
      (project) => project,
    );
  }

  @override
  Future<CreateProjectWithTasksResponse> createProjectWithTasks(
    CreateProjectWithTasksRequest request,
  ) async {
    final result = await _remote.createProjectWithTasks(request);
    return result.fold(
      (error) => throw ProjectsException(error),
      (response) => response,
    );
  }
}

class ProjectsException implements Exception {
  ProjectsException(this.apiError);
  final ApiErrorModel apiError;
  String get message => apiError.message ?? 'Projects error';
}
