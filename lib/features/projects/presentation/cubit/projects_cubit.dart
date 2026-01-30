import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectsandtasks/core/constants/cache_consts.dart';
import 'package:projectsandtasks/features/projects/data/models/create_project_request.dart';
import 'package:projectsandtasks/features/projects/data/models/create_project_with_tasks_request.dart';
import 'package:projectsandtasks/features/projects/data/models/create_project_with_tasks_response.dart';
import 'package:projectsandtasks/features/projects/data/models/project_model.dart';
import 'package:projectsandtasks/features/projects/data/repositories/projects_repository_impl.dart';
import 'package:projectsandtasks/features/projects/domain/repositories/projects_repository.dart';
import 'package:projectsandtasks/shared/services/localeServices/locale_services.dart';

sealed class ProjectsState {
  const ProjectsState();
}

class ProjectsInitial extends ProjectsState {
  const ProjectsInitial();
}

class ProjectsLoading extends ProjectsState {
  const ProjectsLoading();
}

class ProjectsLoaded extends ProjectsState {
  const ProjectsLoaded(this.projects, {this.hasMore = false, this.isLoadingMore = false});
  final List<ProjectModel> projects;
  final bool hasMore;
  final bool isLoadingMore;
}

class ProjectsError extends ProjectsState {
  const ProjectsError(this.message);
  final String message;
}

class ProjectsCubit extends Cubit<ProjectsState> {
  ProjectsCubit({ProjectsRepository? repository})
      : _repository = repository ?? ProjectsRepositoryImpl(),
        super(const ProjectsInitial());

  final ProjectsRepository _repository;
  static const int _pageSize = 10;
  int _currentPage = 1;

  Future<void> loadProjects() async {
    final token = LocaleServices.getString(key: CacheConsts.accessToken);
    if (token == null || token.isEmpty) {
      emit(const ProjectsLoaded([], hasMore: false));
      return;
    }
    emit(const ProjectsLoading());
    try {
      _currentPage = 1;
      final projects = await _repository.getProjects(page: 1, limit: _pageSize);
      final hasMore = projects.length >= _pageSize;
      emit(ProjectsLoaded(projects, hasMore: hasMore));
    } on ProjectsException catch (e) {
      emit(ProjectsError(e.message));
    } catch (e) {
      emit(ProjectsError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! ProjectsLoaded || current.isLoadingMore || !current.hasMore) return;
    final token = LocaleServices.getString(key: CacheConsts.accessToken);
    if (token == null || token.isEmpty) return;
    emit(ProjectsLoaded(current.projects, hasMore: current.hasMore, isLoadingMore: true));
    try {
      _currentPage++;
      final next = await _repository.getProjects(page: _currentPage, limit: _pageSize);
      final combined = [...current.projects];
      for (final p in next) {
        if (!combined.any((e) => e.id == p.id)) combined.add(p);
      }
      // If API doesn't support pagination it may return same/empty for page>1
      final noNewItems = combined.length == current.projects.length;
      final hasMore = !noNewItems && next.length >= _pageSize;
      emit(ProjectsLoaded(combined, hasMore: hasMore));
    } on ProjectsException catch (e) {
      _currentPage--;
      emit(ProjectsLoaded(current.projects, hasMore: current.hasMore));
      emit(ProjectsError(e.message));
    } catch (e) {
      _currentPage--;
      emit(ProjectsLoaded(current.projects, hasMore: current.hasMore));
    }
  }

  void refresh() {
    if (state is! ProjectsLoading) loadProjects();
  }

  /// Create project with optional tasks. Uses POST /project when no tasks, POST /projects/with-tasks otherwise. On success reloads projects.
  Future<CreateProjectWithTasksResponse?> createProjectWithTasks(
    CreateProjectWithTasksRequest request,
  ) async {
    try {
      if (request.tasks.isEmpty) {
        await _repository.createProject(CreateProjectRequest(
          name: request.name,
          description: request.description,
        ));
        await loadProjects();
        return const CreateProjectWithTasksResponse(
          projectId: 0,
          projectName: '',
          projectDescription: '',
          projectCreatedAt: '',
          tasks: [],
        );
      }
      final response = await _repository.createProjectWithTasks(request);
      await loadProjects();
      return response;
    } on ProjectsException catch (e) {
      emit(ProjectsError(e.message));
      return null;
    } catch (e) {
      emit(ProjectsError(e.toString()));
      return null;
    }
  }
}
