import 'package:flutter/material.dart';
import 'package:mindful_youth/utils/method_helpers/gradient_helper.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_icons.dart';

class ListHelper {
  static final List<Map<String, dynamic>> navDestinations = [
    {'icon': AppIconsData.home, 'label': 'Home'},
    {'icon': AppIconsData.wall, 'label': 'Wall'},
    {'icon': AppIconsData.programs, 'label': 'Programs'},
    {'icon': AppIconsData.event, 'label': 'Events'},
    {'icon': AppIconsData.profile, 'label': 'Account'},
  ];

  /// Returns a list with dynamically updated icon colors based on navIndex
  static List<Map<String, dynamic>> getNavDestinations(int navIndex) {
    return navDestinations
        .asMap()
        .map(
          (index, item) => MapEntry(index, {
            ...item,
            'iconColor': index == navIndex ? null : AppColors.black,
          }),
        )
        .values
        .toList();
  }

  /// programs gradient helper list
  static List<Gradient> programListGradient = [
    GradientHelper.bodyGradient,
    GradientHelper.mindGradient,
    GradientHelper.soulGradient,
  ];
}
