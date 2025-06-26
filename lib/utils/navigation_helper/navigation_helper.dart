import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin NavigateHelper {
  // Custom transition method to add animations
  PageRouteBuilder _customPageRoute(
    Widget page, {
    PageTransitionsBuilder? transitionsBuilder,
  }) {
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
  Future push({
    required BuildContext context,
    required Widget widget,
    PageTransitionsBuilder? transition,
  }) async {
    return Platform.isIOS
        ? Navigator.of(
          context,
        ).push(CupertinoPageRoute(builder: (context) => widget))
        : await Navigator.of(
          context,
        ).push(_customPageRoute(widget, transitionsBuilder: transition));
  }

  // for push remove navigation
  Future<void> pushRemoveUntil({
    required BuildContext context,
    required Widget widget,
    bool? isRoute,
    PageTransitionsBuilder? transition,
  }) async {
    Platform.isIOS
        ? Navigator.of(context).pushAndRemoveUntil(
          CupertinoPageRoute(builder: (context) => widget),
          (isRoute) => false,
        )
        : Navigator.of(context).pushAndRemoveUntil(
          _customPageRoute(widget, transitionsBuilder: transition),
          (route) => isRoute ?? false,
        );
  }

  // for pop navigation
  Future pop(BuildContext context, {dynamic result}) async {
    return Navigator.of(context).pop(result);
  }

  // for push remove navigation
  Future<void> pushReplace({
    required BuildContext context,
    required Widget widget,
    PageTransitionsBuilder? transition,
  }) async {
    Platform.isIOS
        ? Navigator.of(
          context,
        ).pushReplacement(CupertinoPageRoute(builder: (context) => widget))
        : Navigator.of(context).pushReplacement(
          _customPageRoute(widget, transitionsBuilder: transition),
        );
  }
}
