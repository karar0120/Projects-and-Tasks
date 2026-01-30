import 'package:flutter/material.dart';
import 'package:projectsandtasks/core/constants/string_consts.dart';

class Routes {
  static const splashScreen = "/";
  
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
     
     
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text(StringConsts.noRouteFound)),
        body: const Center(child: Text(StringConsts.noRouteFound)),
      ),
    );
  }
}
