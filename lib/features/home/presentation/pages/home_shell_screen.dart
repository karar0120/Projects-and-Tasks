import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projectsandtasks/core/constants/cache_consts.dart';
import 'package:projectsandtasks/core/styles/Colors.dart';
import 'package:projectsandtasks/core/utils/change_index_controller.dart';
import 'package:projectsandtasks/core/utils/localization_controller.dart';
import 'package:projectsandtasks/core/utils/route/app_router.dart';
import 'package:projectsandtasks/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:projectsandtasks/features/projects/presentation/pages/projects_list_screen.dart';
import 'package:projectsandtasks/features/tasks/presentation/pages/my_tasks_screen.dart';
import 'package:projectsandtasks/shared/services/localeServices/locale_services.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localizations.dart';
import 'package:projectsandtasks/shared/widgets/GeneralComponents.dart';

class HomeShellScreen extends StatelessWidget {
  const HomeShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChangeIndexController>(
      create: (_) => ChangeIndexController(),
      child: const _HomeShellView(),
    );
  }
}

class _HomeShellView extends StatelessWidget {
  const _HomeShellView();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangeIndexController>(
      builder: (context, controller, _) {
        return Scaffold(
          appBar: GeneralAppBar(
            title: Text(_titleForIndex(context, controller.index)),
            centerTitle: true,
            leading: const SizedBox.shrink(),
            leadingWidth: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => _logout(context),
              ),
            ],
          ),
          body: IndexedStack(
            index: controller.index,
            children: const [
              ProjectsListScreen(),
              MyTasksScreen(),
              _SettingsTab(),
            ],
          ),
          bottomNavigationBar: const HomeBottomNavBar(),
        );
      },
    );
  }

  String _titleForIndex(BuildContext context, int index) {
    String tr(String key) => AppLocalizations.of(context)?.trans(key) ?? key;
    switch (index) {
      case 0:
        return tr('projects');
      case 1:
        return tr('my_tasks');
      case 2:
        return tr('settings');
      default:
        return tr('projects_and_tasks');
    }
  }

  Future<void> _logout(BuildContext context) async {
    await LocaleServices.clearKey(key: CacheConsts.accessToken);
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
    }
  }
}

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          _SettingsSection(
            title: AppLocalizations.of(context)?.trans('language') ?? 'Language',
            children: [
              _LanguageTile(localeCode: 'en', label: AppLocalizations.of(context)?.trans('english') ?? 'English'),
              _LanguageTile(localeCode: 'ar', label: AppLocalizations.of(context)?.trans('arabic') ?? 'العربية'),
            ],
          ),
          const SizedBox(height: 24),
          _SettingsSection(
            title: AppLocalizations.of(context)?.trans('account') ?? 'Account',
            children: [
              ListTile(
                leading: Icon(Icons.logout, color: ColorConsts.tomato),
                title: Text(
                  AppLocalizations.of(context)?.trans('logout') ?? 'Logout',
                  style: TextStyle(
                    color: ColorConsts.tomato,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () => _logout(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Logout', style: TextStyle(color: ColorConsts.tomato)),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;
    await LocaleServices.clearKey(key: CacheConsts.accessToken);
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    }
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ColorConsts.warmGrey,
            ),
          ),
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: ColorConsts.whiteColor2),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.localeCode,
    required this.label,
  });

  final String localeCode;
  final String label;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LocalizationController>();
    final isSelected = controller.locale.languageCode == localeCode;
    return ListTile(
      leading: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
        color: isSelected ? ColorConsts.gunmetalBlue : ColorConsts.warmGrey,
        size: 22,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          color: ColorConsts.gunmetalBlue,
        ),
      ),
      onTap: () async {
        await controller.setLocale(Locale(localeCode));
      },
    );
  }
}
