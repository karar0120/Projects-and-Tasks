import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectsandtasks/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:projectsandtasks/features/auth/presentation/pages/login_screen.dart';
import 'package:projectsandtasks/features/auth/presentation/pages/register_screen.dart';
import 'package:projectsandtasks/features/home/presentation/pages/home_shell_screen.dart';
import 'package:projectsandtasks/features/tasks/presentation/pages/project_tasks_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String projectTasks = '/project-tasks';
}

class AppRouter {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(),
            child: const LoginScreen(),
          ),
        );
      case AppRoutes.register:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<AuthCubit>(
            create: (_) => AuthCubit(),
            child: const RegisterScreen(),
          ),
        );
      case AppRoutes.projectTasks: {
        final args = settings.arguments as Map<String, dynamic>?;
        final projectId = args?['projectId'] as int? ?? 0;
        final projectName = args?['projectName'] as String? ?? 'Tasks';
        return MaterialPageRoute(
          builder: (_) => ProjectTasksScreen(
            projectId: projectId,
            projectName: projectName,
          ),
        );
      }
      case AppRoutes.home:
      default:
        return MaterialPageRoute(
          builder: (_) => const HomeShellScreen(),
        );
    }
  }

  static Route<dynamic> undefined() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Not found')),
        body: const Center(child: Text('Page not found')),
      ),
    );
  }
}
