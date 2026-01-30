/// API constants for the Tasks endpoints.
class TasksApiConstants {
  TasksApiConstants._();

  static const String baseUrl = 'http://redfaire.ddns.net:8080/api';

  static String projectTasksEndpoint(int projectId) => 'projects/$projectId/tasks';
  static String addTasksEndpoint(int projectId) => 'projects/$projectId/add_tasks';
  static const String assignEndpoint = 'tasks/assign';
  /// GET tasks assigned to the current user (Bearer token identifies user). Change to your backend path if different (e.g. 'my-tasks').
  static const String myTasksEndpoint = 'tasks/assigned';
  static String taskStatusEndpoint(int taskId) => 'tasks/$taskId/status';
}
