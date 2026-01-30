import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectsandtasks/core/styles/Colors.dart';
import 'package:projectsandtasks/features/tasks/data/models/task_model.dart';
import 'package:projectsandtasks/features/tasks/presentation/cubit/my_tasks_cubit.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';
import 'package:projectsandtasks/shared/widgets/loader_widget.dart';

class MyTasksScreen extends StatelessWidget {
  const MyTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyTasksCubit>(
      create: (_) => MyTasksCubit()..loadMyTasks(),
      child: const _MyTasksView(),
    );
  }
}

class _MyTasksView extends StatelessWidget {
  const _MyTasksView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyTasksCubit, MyTasksState>(
      builder: (context, state) {
        if (state is MyTasksLoading) {
          return const Center(child: LoaderWidget(sizeLoader: 0.12));
        }
        if (state is MyTasksError) {
          return _ErrorView(message: state.message);
        }
        if (state is MyTasksLoaded) {
          return _MyTasksList(
            tasks: state.tasks,
            hasMore: state.hasMore,
            isLoadingMore: state.isLoadingMore,
          );
        }
        return Center(child: Text(AppLocalizations.of(context)?.trans('pull_to_load_tasks') ?? 'Pull to load your tasks'));
      },
    );
  }
}

class _MyTasksList extends StatefulWidget {
  const _MyTasksList({
    required this.tasks,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  final List<TaskModel> tasks;
  final bool hasMore;
  final bool isLoadingMore;

  @override
  State<_MyTasksList> createState() => _MyTasksListState();
}

class _MyTasksListState extends State<_MyTasksList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!widget.hasMore || widget.isLoadingMore) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (currentScroll >= maxScroll - 200) {
      context.read<MyTasksCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.tasks;
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt_outlined,
              size: 64,
              color: ColorConsts.gunmetalBlue.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)?.trans('no_tasks_assigned') ?? 'No tasks assigned to you',
              style: TextStyle(fontSize: 16, color: ColorConsts.textColor),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)?.trans('tasks_assigned_hint') ?? 'Tasks assigned to you will appear here',
              style: TextStyle(fontSize: 14, color: ColorConsts.warmGrey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
    final itemCount = tasks.length + (widget.hasMore && widget.isLoadingMore ? 1 : 0);
    return RefreshIndicator(
      onRefresh: () => context.read<MyTasksCubit>().loadMyTasks(),
      color: ColorConsts.gunmetalBlue,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index >= tasks.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: LoaderWidget(sizeLoader: 0.06)),
            );
          }
          return _MyTaskCard(task: tasks[index]);
        },
      ),
    );
  }
}

class _MyTaskCard extends StatelessWidget {
  const _MyTaskCard({required this.task});

  final TaskModel task;

  static Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'closed':
        return Colors.green;
      default:
        return ColorConsts.gunmetalBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(task.status);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    (task.status.toLowerCase() == 'completed' ||
                            task.status.toLowerCase() == 'closed')
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ColorConsts.gunmetalBlue,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (task.projectName.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.projectName,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConsts.warmGrey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                _StatusDropdown(
                  currentStatus: task.status,
                  onChanged: (newStatus) {
                    context.read<MyTasksCubit>().updateTaskStatus(task.id, newStatus);
                  },
                ),
              ],
            ),
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                task.description,
                style: TextStyle(
                  fontSize: 14,
                  color: ColorConsts.textColor,
                  height: 1.35,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusDropdown extends StatelessWidget {
  const _StatusDropdown({
    required this.currentStatus,
    required this.onChanged,
  });

  final String currentStatus;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isCompleted = currentStatus.toLowerCase() == 'completed' ||
        currentStatus.toLowerCase() == 'closed';
    return DropdownButton<String>(
      value: isCompleted ? 'completed' : 'open',
      isDense: true,
      underline: const SizedBox.shrink(),
      items: const [
        DropdownMenuItem(value: 'open', child: Text('Open')),
        DropdownMenuItem(value: 'completed', child: Text('Completed')),
      ],
      onChanged: (v) {
        if (v != null && v != currentStatus.toLowerCase()) {
          onChanged(v);
        }
      },
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: ColorConsts.gunmetalBlue,
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: ColorConsts.tomato),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: ColorConsts.gunmetalBlue),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () => context.read<MyTasksCubit>().loadMyTasks(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: TextButton.styleFrom(foregroundColor: ColorConsts.gunmetalBlue),
            ),
          ],
        ),
      ),
    );
  }
}
