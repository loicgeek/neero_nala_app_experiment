import 'dart:developer';

import 'package:flutter/material.dart';

class RouteLoggerObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    log('Navigating from ${previousRoute?.settings.name} to ${route.settings.name},${route.settings.arguments}',
        name: 'RouteLoggerObserver');

    try {
      final finalArgs = {};
      final args = route.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        for (var i = 0; i < args.entries.toList().length; i++) {
          var item = args.entries.toList()[i];
          try {
            finalArgs[item.key] = item.value?.toJson();
          } catch (e) {
            finalArgs[item.key] = item.value;
          }
          // log("${item.value?.toJson()}", name: "RouteLoggerObserver");
        }
      }
    } catch (e) {}
    super.didPush(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    log('Removing route  ${previousRoute?.settings.name} to ${route.settings.name}',
        name: 'RouteLoggerObserver');
    super.didRemove(route, previousRoute);
  }
}
