import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:projectsandtasks/core/constants/cache_consts.dart';
import 'package:projectsandtasks/core/network/dio_consumer.dart';
import 'package:projectsandtasks/core/utils/localization_controller.dart';
import 'package:projectsandtasks/core/utils/route/app_router.dart';
import 'package:projectsandtasks/core/styles/Themes.dart';
import 'package:projectsandtasks/shared/services/localeServices/locale_services.dart';
import 'package:projectsandtasks/shared/services/localizationServices/app_localization_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleServices.init();
  await WebService.init();
  runApp(
    ChangeNotifierProvider<LocalizationController>(
      create: (_) => LocalizationController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final locale = context.watch<LocalizationController>().locale;
    final isRtl = locale.languageCode == 'ar';
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Projects and Tasks',
      theme: lightThemeApp,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      builder: (context, child) {
        final widget = Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        );
        return BotToastInit()(context, widget);
      },
      navigatorObservers: [BotToastNavigatorObserver()],
      initialRoute: _initialRoute,
      onGenerateRoute: (settings) {
        final route = AppRouter.generate(settings);
        return route;
      },
      onUnknownRoute: (_) => AppRouter.undefined(),
    );
  }

  String get _initialRoute {
    final token = LocaleServices.getString(key: CacheConsts.accessToken);
    return (token != null && token.isNotEmpty)
        ? AppRoutes.home
        : AppRoutes.login;
  }
}
