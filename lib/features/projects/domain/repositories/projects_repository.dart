import 'package:projectsandtasks/features/projects/data/models/create_project_request.dart';
import 'package:projectsandtasks/features/projects/data/models/create_project_with_tasks_request.dart';
import 'package:projectsandtasks/features/projects/data/models/create_project_with_tasks_response.dart';
import 'package:projectsandtasks/features/projects/data/models/project_model.dart';

/// Abstract projects repository (domain layer).
/// [getProjects] supports optional pagination; when [page] and [limit] are provided, API may return a page of results.
abstract class ProjectsRepository {
  Future<List<ProjectModel>> getProjects({int? page, int? limit});
  /// POST /api/project - create project only.
  Future<ProjectModel> createProject(CreateProjectRequest request);
  /// POST /api/projects/with-tasks - create project and tasks in one flow.
  Future<CreateProjectWithTasksResponse> createProjectWithTasks(
    CreateProjectWithTasksRequest request,
  );
}
