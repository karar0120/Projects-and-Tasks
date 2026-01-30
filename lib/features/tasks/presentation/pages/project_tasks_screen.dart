import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectsandtasks/core/styles/Colors.dart';
import 'package:projectsandtasks/features/tasks/data/models/assign_tasks_request.dart';
import 'package:projectsandtasks/features/tasks/data/models/create_tasks_request.dart';
import 'package:projectsandtasks/features/tasks/data/models/task_model.dart';
import 'package:projectsandtasks/features/tasks/presentation/cubit/project_tasks_cubit.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';
import 'package:projectsandtasks/shared/widgets/GeneralComponents.dart';
import 'package:projectsandtasks/shared/widgets/drop_down_widget.dart';
import 'package:projectsandtasks/shared/widgets/form_field_widget.dart';
import 'package:projectsandtasks/shared/widgets/loader_widget.dart';

class ProjectTasksScreen extends StatelessWidget {
  const ProjectTasksScreen({
    super.key,
    required this.projectId,
    required this.projectName,
  });

  final int projectId;
  final String projectName;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectTasksCubit>(
      create: (_) => ProjectTasksCubit(projectId: projectId)..loadTasks(),
      child: _ProjectTasksView(projectName: projectName),
    );
  }
}

class _ProjectTasksView extends StatelessWidget {
  const _ProjectTasksView({required this.projectName});

  final String projectName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GeneralAppBar(
        title: Text(projectName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: AppLocalizations.of(context)?.trans('assign_user_tooltip') ?? 'Assign user to tasks',
            onPressed: () => _showAssignSheet(context),
          ),
        ],
      ),
      body: BlocBuilder<ProjectTasksCubit, ProjectTasksState>(
        builder: (context, state) {
          if (state is ProjectTasksLoading) {
            return const Center(child: LoaderWidget(sizeLoader: 0.12));
          }
          if (state is ProjectTasksError) {
            return _ErrorView(message: state.message);
          }
          if (state is ProjectTasksLoaded) {
            return _TasksList(
              tasks: state.tasks,
              onAssignTask: (taskId) => _showAssignSheet(context, initialTaskIds: [taskId]),
              onStatusChanged: (taskId, newStatus) => context.read<ProjectTasksCubit>().updateTaskStatus(taskId, newStatus),
            );
          }
          return Center(
            child: Text(AppLocalizations.of(context)?.trans('pull_to_load_tasks_screen') ?? 'Pull to load tasks'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateTaskSheet(context),
        backgroundColor: ColorConsts.gunmetalBlue,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateTaskSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _CreateTaskSheetContent(
        onAdd: (title, description, status) async {
          final request = CreateTasksRequest(
            tasks: [
              CreateTaskItem(
                title: title,
                description: description,
                status: status,
              ),
            ],
          );
          await context.read<ProjectTasksCubit>().addTasks(request);
        },
        onDismiss: () => Navigator.pop(ctx),
      ),
    );
  }

  void _showAssignSheet(BuildContext context, {List<int>? initialTaskIds}) {
    final cubit = context.read<ProjectTasksCubit>();
    final state = cubit.state;
    if (state is! ProjectTasksLoaded || state.tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)?.trans('no_tasks_to_assign') ?? 'No tasks to assign')),
      );
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AssignSheetContent(
        tasks: state.tasks,
        initialSelectedTaskIds: initialTaskIds,
        onAssign: (userId, taskIds) async {
          await context.read<ProjectTasksCubit>().assignTasks(
                AssignTasksRequest(userId: userId, taskIds: taskIds),
              );
        },
        onDismiss: () => Navigator.pop(ctx),
      ),
    );
  }
}

class _CreateTaskSheetContent extends StatefulWidget {
  const _CreateTaskSheetContent({
    required this.onAdd,
    required this.onDismiss,
  });

  final Future<void> Function(String title, String description, String status) onAdd;
  final VoidCallback onDismiss;

  @override
  State<_CreateTaskSheetContent> createState() => _CreateTaskSheetContentState();
}

class _CreateTaskSheetContentState extends State<_CreateTaskSheetContent> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _titleFocus = FocusNode();
  final _descFocus = FocusNode();
  String _status = 'open';
  bool _isSubmitting = false;

  String _tr(String key) => AppLocalizations.of(context)?.trans(key) ?? key;

  static List<DropdownMenuItem<dynamic>> _statusItems(String Function(String) tr) => [
        DropdownMenuItem(value: 'open', child: Text(tr('open'))),
        DropdownMenuItem(value: 'closed', child: Text(tr('closed'))),
      ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _titleFocus.dispose();
    _descFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final statusItems = _statusItems(_tr);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: ColorConsts.whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _tr('new_task'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorConsts.gunmetalBlue),
              ),
              const SizedBox(height: 16),
              DefaultFormField(
                labelText: _tr('task_title'),
                controller: _titleController,
                type: TextInputType.text,
                focusNode: _titleFocus,
                height: 52,
                onSubmit: () => _descFocus.requestFocus(),
                onChange: () {},
                onTap: () {},
                validate: () {},
                prefixPressed: () {},
                suffixPressed: () {},
                obscureText: false,
              ),
              const SizedBox(height: 12),
              DefaultFormField(
                labelText: _tr('description'),
                controller: _descController,
                type: TextInputType.multiline,
                focusNode: _descFocus,
                height: 100,
                maxLines: 3,
                onSubmit: () {},
                onChange: () {},
                onTap: () {},
                validate: () {},
                prefixPressed: () {},
                suffixPressed: () {},
                obscureText: false,
              ),
              const SizedBox(height: 12),
              DropDownBottomSheet(
                context: context,
                labelText: _tr('status'),
                item: statusItems,
                lang: lang,
                value: _status,
                hint: _status == 'open' ? _tr('open') : _tr('closed'),
                hintStyle: Theme.of(context).textTheme.bodyLarge,
                onTap: (value) => setState(() => _status = value as String? ?? 'open'),
                text: (v) => v == 'open' ? _tr('open') : _tr('closed'),
                searchFunction: (value, query) {
                  final label = value == 'open' ? _tr('open') : _tr('closed');
                  return label.toLowerCase().contains(query.toLowerCase());
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting ? null : widget.onDismiss,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorConsts.gunmetalBlue,
                        side: const BorderSide(color: ColorConsts.gunmetalBlue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(_tr('cancel')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              final title = _titleController.text.trim();
                              if (title.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(_tr('enter_title'))),
                                );
                                return;
                              }
                              setState(() => _isSubmitting = true);
                              await widget.onAdd(
                                title,
                                _descController.text.trim(),
                                _status,
                              );
                              if (mounted) {
                                setState(() => _isSubmitting = false);
                                widget.onDismiss();
                                doneBotToast(title: _tr('task_added'));
                              }
                            },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorConsts.whiteColor,
                        backgroundColor: ColorConsts.gunmetalBlue,
                        side: const BorderSide(color: ColorConsts.gunmetalBlue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ColorConsts.whiteColor,
                              ),
                            )
                          : Text(_tr('add_task')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssignSheetContent extends StatefulWidget {
  const _AssignSheetContent({
    required this.tasks,
    required this.onAssign,
    required this.onDismiss,
    this.initialSelectedTaskIds,
  });

  final List<TaskModel> tasks;
  final List<int>? initialSelectedTaskIds;
  final Future<void> Function(int userId, List<int> taskIds) onAssign;
  final VoidCallback onDismiss;

  @override
  State<_AssignSheetContent> createState() => _AssignSheetContentState();
}

class _AssignSheetContentState extends State<_AssignSheetContent> {
  final _userIdController = TextEditingController();
  late Set<int> _selectedIds;

  String _tr(String key) => AppLocalizations.of(context)?.trans(key) ?? key;

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.initialSelectedTaskIds != null
        ? Set<int>.from(widget.initialSelectedTaskIds!)
        : <int>{};
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: ColorConsts.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            _tr('assign_user_to_tasks'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorConsts.gunmetalBlue),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _userIdController,
            decoration: InputDecoration(
              labelText: _tr('user_id'),
              border: const OutlineInputBorder(),
              hintText: _tr('user_id_hint'),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          Text(_tr('select_tasks'), style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.tasks.length,
              itemBuilder: (_, i) {
                final task = widget.tasks[i];
                return CheckboxListTile(
                  title: Text(task.title, overflow: TextOverflow.ellipsis),
                  value: _selectedIds.contains(task.id),
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        _selectedIds.add(task.id);
                      } else {
                        _selectedIds.remove(task.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: widget.onDismiss,
                  child: Text(_tr('cancel')),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    final userIdStr = _userIdController.text.trim();
                    if (userIdStr.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_tr('enter_user_id'))),
                      );
                      return;
                    }
                    final userId = int.tryParse(userIdStr);
                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_tr('user_id_must_be_number'))),
                      );
                      return;
                    }
                    if (_selectedIds.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(_tr('select_at_least_one_task'))),
                      );
                      return;
                    }
                    await widget.onAssign(userId, _selectedIds.toList());
                    if (mounted) {
                      widget.onDismiss();
                      doneBotToast(title: _tr('tasks_assigned'));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConsts.gunmetalBlue,
                    foregroundColor: ColorConsts.whiteColor,
                  ),
                  child: Text(_tr('assign')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TasksList extends StatelessWidget {
  const _TasksList({
    required this.tasks,
    required this.onStatusChanged,
    required this.onAssignTask,
  });

  final List<TaskModel> tasks;
  final void Function(int taskId, String newStatus) onStatusChanged;
  final void Function(int taskId) onAssignTask;

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.of(context)?.trans(key) ?? key;
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt_outlined,
              size: 64,
              color: ColorConsts.gunmetalBlue.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              tr('no_tasks_yet'),
              style: TextStyle(fontSize: 16, color: ColorConsts.textColor),
            ),
            const SizedBox(height: 8),
            Text(
              tr('tap_to_add_task'),
              style: TextStyle(fontSize: 14, color: ColorConsts.warmGrey),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () => context.read<ProjectTasksCubit>().loadTasks(),
      color: ColorConsts.gunmetalBlue,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: tasks.length,
        itemBuilder: (context, index) => _TaskCard(
          task: tasks[index],
          onStatusChanged: onStatusChanged,
          onAssignTask: onAssignTask,
        ),
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.onStatusChanged,
    required this.onAssignTask,
  });

  final TaskModel task;
  final void Function(int taskId, String newStatus) onStatusChanged;
  final void Function(int taskId) onAssignTask;

  @override
  Widget build(BuildContext context) {
    String tr(String key) => AppLocalizations.of(context)?.trans(key) ?? key;
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
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _taskStatusColor(task.status).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: _taskStatusColor(task.status),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ColorConsts.gunmetalBlue,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.person_add_outlined, size: 22),
                  color: ColorConsts.gunmetalBlue,
                  tooltip: AppLocalizations.of(context)?.trans('assign_user_tooltip') ?? 'Assign',
                  onPressed: () => onAssignTask(task.id),
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
                const SizedBox(width: 4),
                _StatusChip(
                  status: task.status,
                  onTap: () => _showStatusBottomSheet(context, task.id, task.status, onStatusChanged, tr),
                  statusLabel: _statusLabel(task.status, tr),
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

Color _taskStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'closed':
    case 'completed':
      return Colors.green;
    default:
      return ColorConsts.gunmetalBlue;
  }
}

String _statusLabel(String status, String Function(String) tr) {
  switch (status.toLowerCase()) {
    case 'closed':
    case 'completed':
      return tr('completed');
    default:
      return tr('open');
  }
}

void _showStatusBottomSheet(
  BuildContext context,
  int taskId,
  String currentStatus,
  void Function(int taskId, String newStatus) onStatusChanged,
  String Function(String) tr,
) {
  final lang = Localizations.localeOf(context).languageCode;
  final items = [
    DropdownMenuItem(value: 'open', child: Text(tr('open'))),
    DropdownMenuItem(value: 'completed', child: Text(tr('completed'))),
  ];
  showDropDownBottomSheet(
    context: context,
    item: items,
    lang: lang,
    onTap: (value) {
      final newStatus = value as String?;
      if (newStatus != null) {
        onStatusChanged(taskId, newStatus);
      }
    },
    text: (v) => v == 'open' ? tr('open') : tr('completed'),
    searchFunction: (value, query) {
      final label = value == 'open' ? tr('open') : tr('completed');
      return label.toLowerCase().contains(query.toLowerCase());
    },
  );
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.onTap, required this.statusLabel});

  final String status;
  final VoidCallback onTap;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    final color = _taskStatusColor(status);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              statusLabel,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 18, color: color),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final retryLabel = AppLocalizations.of(context)?.trans('retry') ?? 'Retry';
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
              onPressed: () => context.read<ProjectTasksCubit>().loadTasks(),
              icon: const Icon(Icons.refresh),
              label: Text(retryLabel),
              style: TextButton.styleFrom(foregroundColor: ColorConsts.gunmetalBlue),
            ),
          ],
        ),
      ),
    );
  }
}
