import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectsandtasks/core/constants/cache_consts.dart';
import 'package:projectsandtasks/features/tasks/data/models/task_model.dart';
import 'package:projectsandtasks/features/tasks/data/models/update_task_status_request.dart';
import 'package:projectsandtasks/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:projectsandtasks/features/tasks/domain/repositories/tasks_repository.dart';
import 'package:projectsandtasks/shared/services/localeServices/locale_services.dart';

sealed class MyTasksState {
  const MyTasksState();
}

class MyTasksInitial extends MyTasksState {
  const MyTasksInitial();
}

class MyTasksLoading extends MyTasksState {
  const MyTasksLoading();
}

class MyTasksLoaded extends MyTasksState {
  const MyTasksLoaded(this.tasks, {this.hasMore = false, this.isLoadingMore = false});
  final List<TaskModel> tasks;
  final bool hasMore;
  final bool isLoadingMore;
}

class MyTasksError extends MyTasksState {
  const MyTasksError(this.message);
  final String message;
}

class MyTasksCubit extends Cubit<MyTasksState> {
  MyTasksCubit({TasksRepository? repository})
      : _repository = repository ?? TasksRepositoryImpl(),
        super(const MyTasksInitial());

  final TasksRepository _repository;
  static const int _pageSize = 10;
  int _currentPage = 1;

  Future<void> loadMyTasks() async {
    final token = LocaleServices.getString(key: CacheConsts.accessToken);
    if (token == null || token.isEmpty) {
      emit(const MyTasksLoaded([], hasMore: false));
      return;
    }
    emit(const MyTasksLoading());
    try {
      _currentPage = 1;
      final tasks = await _repository.getMyTasks(page: 1, limit: _pageSize);
      final hasMore = tasks.length >= _pageSize;
      emit(MyTasksLoaded(tasks, hasMore: hasMore));
    } on TasksException catch (e) {
      emit(MyTasksError(e.message));
    } catch (e) {
      emit(MyTasksError(e.toString()));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! MyTasksLoaded || current.isLoadingMore || !current.hasMore) return;
    final token = LocaleServices.getString(key: CacheConsts.accessToken);
    if (token == null || token.isEmpty) return;
    emit(MyTasksLoaded(current.tasks, hasMore: current.hasMore, isLoadingMore: true));
    try {
      _currentPage++;
      final next = await _repository.getMyTasks(page: _currentPage, limit: _pageSize);
      final combined = [...current.tasks];
      for (final t in next) {
        if (!combined.any((e) => e.id == t.id)) combined.add(t);
      }
      final noNewItems = combined.length == current.tasks.length;
      final hasMore = !noNewItems && next.length >= _pageSize;
      emit(MyTasksLoaded(combined, hasMore: hasMore));
    } on TasksException catch (e) {
      _currentPage--;
      emit(MyTasksLoaded(current.tasks, hasMore: current.hasMore));
      emit(MyTasksError(e.message));
    } catch (e) {
      _currentPage--;
      emit(MyTasksLoaded(current.tasks, hasMore: current.hasMore));
    }
  }

  /// Update task status (open | completed). Refreshes list on success.
  Future<void> updateTaskStatus(int taskId, String status) async {
    final current = state;
    if (current is! MyTasksLoaded) return;
    try {
      final request = UpdateTaskStatusRequest(status: status);
      final updated = await _repository.updateTaskStatus(taskId, request);
      final newList = current.tasks
          .map((t) => t.id == taskId ? updated : t)
          .toList();
      emit(MyTasksLoaded(newList, hasMore: current.hasMore, isLoadingMore: current.isLoadingMore));
    } on TasksException catch (e) {
      emit(MyTasksError(e.message));
    } catch (e) {
      emit(MyTasksError(e.toString()));
    }
  }

  void refresh() {
    if (state is! MyTasksLoading) loadMyTasks();
  }
}
