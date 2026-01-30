import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectsandtasks/features/tasks/data/models/assign_tasks_request.dart';
import 'package:projectsandtasks/features/tasks/data/models/create_tasks_request.dart';
import 'package:projectsandtasks/features/tasks/data/models/task_model.dart';
import 'package:projectsandtasks/features/tasks/data/models/update_task_status_request.dart';
import 'package:projectsandtasks/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:projectsandtasks/features/tasks/domain/repositories/tasks_repository.dart';

sealed class ProjectTasksState {
  const ProjectTasksState();
}

class ProjectTasksInitial extends ProjectTasksState {
  const ProjectTasksInitial();
}

class ProjectTasksLoading extends ProjectTasksState {
  const ProjectTasksLoading();
}

class ProjectTasksLoaded extends ProjectTasksState {
  const ProjectTasksLoaded(this.tasks);
  final List<TaskModel> tasks;
}

class ProjectTasksError extends ProjectTasksState {
  const ProjectTasksError(this.message);
  final String message;
}

class ProjectTasksCubit extends Cubit<ProjectTasksState> {
  ProjectTasksCubit({
    required int projectId,
    TasksRepository? repository,
  })  : _projectId = projectId,
        _repository = repository ?? TasksRepositoryImpl(),
        super(const ProjectTasksInitial());

  final int _projectId;
  final TasksRepository _repository;

  int get projectId => _projectId;

  Future<void> loadTasks() async {
    emit(const ProjectTasksLoading());
    try {
      final tasks = await _repository.getProjectTasks(_projectId);
      emit(ProjectTasksLoaded(tasks));
    } on TasksException catch (e) {
      emit(ProjectTasksError(e.message));
    } catch (e) {
      emit(ProjectTasksError(e.toString()));
    }
  }

  Future<void> addTasks(CreateTasksRequest request) async {
    try {
      await _repository.addTasks(_projectId, request);
      await loadTasks();
    } on TasksException catch (e) {
      emit(ProjectTasksError(e.message));
    } catch (e) {
      emit(ProjectTasksError(e.toString()));
    }
  }

  Future<void> assignTasks(AssignTasksRequest request) async {
    try {
      await _repository.assignTasks(request);
      await loadTasks();
    } on TasksException catch (e) {
      emit(ProjectTasksError(e.message));
    } catch (e) {
      emit(ProjectTasksError(e.toString()));
    }
  }

  /// Update task status via PUT /api/tasks/{taskId}/status. Status: "open" | "completed". Refreshes list on success.
  Future<void> updateTaskStatus(int taskId, String status) async {
    try {
      await _repository.updateTaskStatus(taskId, UpdateTaskStatusRequest(status: status));
      await loadTasks();
    } on TasksException catch (e) {
      emit(ProjectTasksError(e.message));
    } catch (e) {
      emit(ProjectTasksError(e.toString()));
    }
  }

  void refresh() {
    if (state is! ProjectTasksLoading) loadTasks();
  }
}
