import 'package:flutter/material.dart';

class FadeSlidePageTransitionsBuilder extends PageTransitionsBuilder {
  const FadeSlidePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    // If this is the first route (initial route), don't animate
    if (route.settings.name == '/') {
      return child;
    }

    // Fade + Slide transition
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 0.1), // slide from slightly below
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: FadeTransition(opacity: animation, child: child),
    );
  }
}
