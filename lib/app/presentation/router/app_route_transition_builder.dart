// build one transition builder for all routes
import 'package:flutter/material.dart';

RouteTransitionsBuilder get appRouteTransitionBuilder =>
    (context, animation, secondaryAnimation, child) {
      // use this to disable all transitions
      //return child;
      // or return a fade transition
      return FadeTransition(opacity: animation, child: child);
    };
