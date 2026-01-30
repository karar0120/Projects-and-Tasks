/// API constants for the Projects and Tasks projects endpoints.
class ProjectsApiConstants {
  ProjectsApiConstants._();

  static const String baseUrl = 'http://redfaire.ddns.net:8080/api';
  static const String projectsEndpoint = 'projects';
  /// POST single project (no tasks)
  static const String projectEndpoint = 'project';
  /// POST project with tasks in one flow
  static const String projectsWithTasksEndpoint = 'projects/with-tasks';
}
