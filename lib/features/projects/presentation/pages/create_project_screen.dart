import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectsandtasks/core/styles/Colors.dart';
import 'package:projectsandtasks/features/projects/data/models/create_project_with_tasks_request.dart';
import 'package:projectsandtasks/features/projects/presentation/cubit/projects_cubit.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';
import 'package:projectsandtasks/shared/widgets/GeneralComponents.dart';
import 'package:projectsandtasks/shared/widgets/button_widget.dart';
import 'package:projectsandtasks/shared/widgets/form_field_widget.dart';
import 'package:projectsandtasks/shared/widgets/drop_down_widget.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _nameFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _taskInputs = <_TaskInputState>[];
  bool _isSubmitting = false;

  String _tr(String key) => AppLocalizations.of(context)?.trans(key) ?? key;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _nameFocus.dispose();
    _descriptionFocus.dispose();
    for (final t in _taskInputs) {
      t.dispose();
    }
    super.dispose();
  }

  void _addTask() {
    setState(() => _taskInputs.add(_TaskInputState()));
  }

  void _removeTask(int index) {
    setState(() {
      _taskInputs[index].dispose();
      _taskInputs.removeAt(index);
    });
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_tr('enter_project_name'))),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    final tasks = _taskInputs
        .map((t) => ProjectTaskInput(
              title: t.titleController.text.trim(),
              description: t.descController.text.trim(),
              status: t.status,
            ))
        .where((t) => t.title.isNotEmpty)
        .toList();
    final request = CreateProjectWithTasksRequest(
      name: name,
      description: _descriptionController.text.trim(),
      tasks: tasks,
    );
    final response = await context.read<ProjectsCubit>().createProjectWithTasks(request);
    setState(() => _isSubmitting = false);
    if (!mounted) return;
    if (response != null) {
      doneBotToast(title: _tr('project_created'));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConsts.backgroundColor,
      appBar: GeneralAppBar(
        title: Text(_tr('create_project')),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: ColorConsts.gunmetalBlue.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DefaultFormField(
                  labelText: '${_tr('project_name')} *',
                  controller: _nameController,
                  type: TextInputType.text,
                  focusNode: _nameFocus,
                  onSubmit: () => _descriptionFocus.requestFocus(),
                  onChange: () {},
                  onTap: () {},
                  validate: () {},
                  prefixPressed: () {},
                  suffixPressed: () {},
                  obscureText: false,
                ),
                const SizedBox(height: 16),
                DefaultFormField(
                  labelText: _tr('description'),
                  controller: _descriptionController,
                  type: TextInputType.multiline,
                  focusNode: _descriptionFocus,
                  height: 120,
                  maxLines: 3,
                  onSubmit: () {},
                  onChange: () {},
                  onTap: () {},
                  validate: () {},
                  prefixPressed: () {},
                  suffixPressed: () {},
                  obscureText: false,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _tr('tasks_optional'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorConsts.gunmetalBlue,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _addTask,
                      icon: const Icon(Icons.add, size: 20),
                      label: Text(_tr('add_task')),
                      style: TextButton.styleFrom(
                        foregroundColor: ColorConsts.whiteColor,
                        backgroundColor: ColorConsts.gunmetalBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...List.generate(_taskInputs.length, (index) {
                  final t = _taskInputs[index];
                  return _TaskInputTile(
                    key: ObjectKey(t),
                    titleController: t.titleController,
                    descController: t.descController,
                    titleFocus: t.titleFocus,
                    descFocus: t.descFocus,
                    status: t.status,
                    onStatusChanged: (v) {
                      setState(() => t.status = v ?? 'open');
                    },
                    onRemove: () => _removeTask(index),
                    tr: _tr,
                  );
                }),
                const SizedBox(height: 32),
                InkWell(
                  onTap: _isSubmitting ? null : _submit,
                  borderRadius: BorderRadius.circular(8),
                  child: GeneralButton(
                    title: _tr('create_project_with_tasks'),
                    height: 52,
                    isLoading: _isSubmitting,
                    loadingSize: 0.05,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskInputState {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final titleFocus = FocusNode();
  final descFocus = FocusNode();
  String status = 'open';

  void dispose() {
    titleController.dispose();
    descController.dispose();
    titleFocus.dispose();
    descFocus.dispose();
  }
}

class _TaskInputTile extends StatelessWidget {
  const _TaskInputTile({
    super.key,
    required this.titleController,
    required this.descController,
    required this.titleFocus,
    required this.descFocus,
    required this.status,
    required this.onStatusChanged,
    required this.onRemove,
    required this.tr,
  });

  final TextEditingController titleController;
  final TextEditingController descController;
  final FocusNode titleFocus;
  final FocusNode descFocus;
  final String status;
  final ValueChanged<String?> onStatusChanged;
  final VoidCallback onRemove;
  final String Function(String) tr;

  static List<DropdownMenuItem<dynamic>> _statusItems(String Function(String) tr) => [
        DropdownMenuItem(value: 'open', child: Text(tr('open'))),
        DropdownMenuItem(value: 'closed', child: Text(tr('closed'))),
      ];

  @override
  Widget build(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    final statusItems = _statusItems(tr);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.task_alt_outlined, size: 20, color: ColorConsts.gunmetalBlue),
                const SizedBox(width: 8),
                Expanded(
                  child: DefaultFormField(
                    labelText: tr('task_title'),
                    controller: titleController,
                    type: TextInputType.text,
                    focusNode: titleFocus,
                    height: 52,
                    onSubmit: () => descFocus.requestFocus(),
                    onChange: () {},
                    onTap: () {},
                    validate: () {},
                    prefixPressed: () {},
                    suffixPressed: () {},
                    obscureText: false,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline, color: ColorConsts.tomato),
                  onPressed: onRemove,
                ),
              ],
            ),
            const SizedBox(height: 8),
            DefaultFormField(
              labelText: tr('description'),
              controller: descController,
              type: TextInputType.multiline,
              focusNode: descFocus,
              height: 80,
              maxLines: 2,
              onSubmit: () {},
              onChange: () {},
              onTap: () {},
              validate: () {},
              prefixPressed: () {},
              suffixPressed: () {},
              obscureText: false,
            ),
            const SizedBox(height: 8),
            DropDownBottomSheet(
              context: context,
              labelText: tr('status'),
              item: statusItems,
              lang: lang,
              value: status,
              hint: status == 'open' ? tr('open') : tr('closed'),
              hintStyle: Theme.of(context).textTheme.bodyLarge,
              onTap: (value) => onStatusChanged(value as String?),
              text: (v) => v == 'open' ? tr('open') : tr('closed'),
              searchFunction: (value, query) {
                final label = value == 'open' ? tr('open') : tr('closed');
                return label.toLowerCase().contains(query.toLowerCase());
              },
            ),
          ],
        ),
      ),
    );
  }
}
