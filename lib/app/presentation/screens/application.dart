import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:neero_nala_app/app/data/locator_service.dart';
import 'package:neero_nala_app/app/presentation/router/app_router.dart';
import 'package:neero_nala_app/app/presentation/router/route_logger_observer.dart';
import 'package:neero_nala_app/app/presentation/themes/theme_dark.dart';
import 'package:neero_nala_app/app/presentation/themes/theme_light.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
        },
      ),
      // theme: ThemeLight().data(),
      theme: ThemeDark().data(),
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (_) => 'Nala',
      routerConfig: getIt<AppRouter>().config(
        navigatorObservers: () {
          return [
            RouteLoggerObserver(),
          ];
        },
      ),
    );
  }
}
