import 'package:dartz/dartz.dart';
import 'package:projectsandtasks/core/network/api_error_model.dart';
import 'package:projectsandtasks/core/network/dio_consumer.dart';
import 'package:projectsandtasks/features/projects/data/constants/projects_api_constants.dart';
import 'package:projectsandtasks/features/projects/data/models/create_project_request.dart';
import 'package:projectsandtasks/features/projects/data/models/create_project_with_tasks_request.dart';
import 'package:projectsandtasks/features/projects/data/models/create_project_with_tasks_response.dart';
import 'package:projectsandtasks/features/projects/data/models/project_model.dart';

/// Remote data source for projects API.
/// Uses Bearer token via default headers (getRequestHeadersApplication).
/// Supports optional pagination via [page] and [limit] query params.
abstract class ProjectsRemoteDataSource {
  Future<Either<ApiErrorModel, List<ProjectModel>>> getProjects({int? page, int? limit});
  Future<Either<ApiErrorModel, ProjectModel>> createProject(CreateProjectRequest request);
  Future<Either<ApiErrorModel, CreateProjectWithTasksResponse>> createProjectWithTasks(
    CreateProjectWithTasksRequest request,
  );
}

class ProjectsRemoteDataSourceImpl implements ProjectsRemoteDataSource {
  static const int defaultPageSize = 10;

  @override
  Future<Either<ApiErrorModel, List<ProjectModel>>> getProjects({int? page, int? limit}) async {
    Map<String, dynamic>? query;
    if (page != null && limit != null) {
      query = {'page': page, 'limit': limit};
    }
    final response = await WebService.getNoLang(
      controller: ProjectsApiConstants.baseUrl,
      endpoint: ProjectsApiConstants.projectsEndpoint,
      headers: WebService.getRequestHeadersApplication(),
      query: query,
    );

    return response.fold(
      (error) => left(error),
      (res) {
        final data = res.data;
        if (data is! List) {
          return left(const ApiErrorModel(message: 'Invalid response'));
        }
        final list = data
            .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(list);
      },
    );
  }

  @override
  Future<Either<ApiErrorModel, ProjectModel>> createProject(CreateProjectRequest request) async {
    final response = await WebService.postNoLang(
      controller: ProjectsApiConstants.baseUrl,
      endpoint: ProjectsApiConstants.projectEndpoint,
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
        return right(ProjectModel.fromJson(data));
      },
    );
  }

  @override
  Future<Either<ApiErrorModel, CreateProjectWithTasksResponse>> createProjectWithTasks(
    CreateProjectWithTasksRequest request,
  ) async {
    final response = await WebService.postNoLang(
      controller: ProjectsApiConstants.baseUrl,
      endpoint: ProjectsApiConstants.projectsWithTasksEndpoint,
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
        return right(CreateProjectWithTasksResponse.fromJson(data));
      },
    );
  }
}
