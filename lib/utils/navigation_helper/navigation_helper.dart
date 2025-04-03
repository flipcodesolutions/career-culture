import 'package:flutter/material.dart';

mixin NavigateHelper {
  // Custom transition method to add animations
  PageRouteBuilder _customPageRoute(Widget page,
      {PageTransitionsBuilder? transitionsBuilder}) {
    return PageRouteBuilder(
      transitionDuration: Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        if (transitionsBuilder != null) {
          return transitionsBuilder.buildTransitions(
            MaterialPageRoute(builder: (context) => page),
            context,
            animation,
            secondaryAnimation,
            child,
          );
        }
        // Default slide transition (from right)
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  // for push navigation
  Future<void> push(
      {required BuildContext context,
      required Widget widget,
      PageTransitionsBuilder? transition}) async {
    Navigator.of(context).push(
      _customPageRoute(widget, transitionsBuilder: transition),
    );
  }

  // for push remove navigation
  Future<void> pushRemoveUntil(
      {required BuildContext context,
      required Widget widget,
      bool? isRoute,
      PageTransitionsBuilder? transition}) async {
    Navigator.of(context).pushAndRemoveUntil(
        _customPageRoute(widget, transitionsBuilder: transition),
        (route) => isRoute ?? false);
  }

  // for pop navigation
  pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  // for push remove navigation
  Future<void> pushReplace(
      {required BuildContext context,
      required Widget widget,
      PageTransitionsBuilder? transition}) async {
    Navigator.of(context).pushReplacement(
      _customPageRoute(widget, transitionsBuilder: transition),
    );
  }
}
