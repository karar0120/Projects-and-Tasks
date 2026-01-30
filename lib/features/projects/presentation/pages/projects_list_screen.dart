import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectsandtasks/core/styles/Colors.dart';
import 'package:projectsandtasks/features/projects/data/models/project_model.dart';
import 'package:projectsandtasks/features/projects/presentation/cubit/projects_cubit.dart';
import 'package:projectsandtasks/features/projects/presentation/pages/create_project_screen.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';
import 'package:projectsandtasks/shared/widgets/loader_widget.dart';

class ProjectsListScreen extends StatelessWidget {
  const ProjectsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProjectsCubit>(
      create: (_) => ProjectsCubit()..loadProjects(),
      child: const _ProjectsListView(),
    );
  }
}

class _ProjectsListView extends StatelessWidget {
  const _ProjectsListView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsCubit, ProjectsState>(
      builder: (context, state) {
        if (state is ProjectsLoading) {
          return const Center(child: LoaderWidget(sizeLoader: 0.06));
        }
        if (state is ProjectsError) {
          return _ErrorView(message: state.message);
        }
        if (state is ProjectsLoaded) {
          return _ProjectsList(
            projects: state.projects,
            hasMore: state.hasMore,
            isLoadingMore: state.isLoadingMore,
          );
        }
        return Center(child: Text(AppLocalizations.of(context)?.trans('pull_to_load_projects') ?? 'Pull to load projects'));
      },
    );
  }
}

class _ProjectsList extends StatefulWidget {
  const _ProjectsList({
    required this.projects,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  final List<ProjectModel> projects;
  final bool hasMore;
  final bool isLoadingMore;

  @override
  State<_ProjectsList> createState() => _ProjectsListState();
}

class _ProjectsListState extends State<_ProjectsList> {
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
      context.read<ProjectsCubit>().loadMore();
    }
  }

  void _openCreateProject(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<ProjectsCubit>(),
          child: const CreateProjectScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projects = widget.projects;
    if (projects.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 64, color: ColorConsts.gunmetalBlue.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)?.trans('no_projects_yet') ?? 'No projects yet',
              style: TextStyle(
                fontSize: 16,
                color: ColorConsts.textColor,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _openCreateProject(context),
              icon: const Icon(Icons.add),
              label: Text(AppLocalizations.of(context)?.trans('create_project') ?? 'Create project'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConsts.gunmetalBlue,
                foregroundColor: ColorConsts.gunmetalBlue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }
    final itemCount = projects.length + (widget.hasMore && widget.isLoadingMore ? 1 : 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                projects.length == 1
                    ? (AppLocalizations.of(context)?.trans('one_project') ?? '1 project')
                    : (AppLocalizations.of(context)?.trans('projects_count') ?? '${projects.length} projects').replaceAll('{count}', '${projects.length}'),
                style: TextStyle(
                  fontSize: 14,
                  color: ColorConsts.textColor,
                ),
              ),
              TextButton.icon(
                onPressed: () => _openCreateProject(context),
                icon: const Icon(Icons.add, size: 20),
                label: Text(AppLocalizations.of(context)?.trans('create_project') ?? 'Create project'),
                style: TextButton.styleFrom(
                  foregroundColor: ColorConsts.whiteColor,
                  backgroundColor: ColorConsts.gunmetalBlue,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => context.read<ProjectsCubit>().loadProjects(),
            color: ColorConsts.gunmetalBlue,
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                if (index >= projects.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: LoaderWidget(sizeLoader: 0.06)),
                  );
                }
                return _ProjectCard(project: projects[index]);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final ProjectModel project;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            '/project-tasks',
            arguments: <String, dynamic>{
              'projectId': project.id,
              'projectName': project.name,
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ColorConsts.gunmetalBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.folder_outlined,
                      color: ColorConsts.gunmetalBlue,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      project.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ColorConsts.gunmetalBlue,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (project.description.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  project.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColorConsts.textColor,
                    height: 1.35,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                _formatDate(project.createdAt),
                style: TextStyle(
                  fontSize: 12,
                  color: ColorConsts.warmGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    if (iso.isEmpty) return '';
    try {
      final dt = DateTime.tryParse(iso);
      if (dt == null) return iso;
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    } catch (_) {
      return iso;
    }
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
              style: const TextStyle(
                fontSize: 14,
                color: ColorConsts.gunmetalBlue,
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () => context.read<ProjectsCubit>().loadProjects(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: TextButton.styleFrom(
                foregroundColor: ColorConsts.gunmetalBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
