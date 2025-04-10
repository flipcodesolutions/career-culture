import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_size.dart';

class AppIcons {
  static const Icon remove = Icon(Icons.remove, color: AppColors.primary);
  static const Icon audio = Icon(Icons.audio_file, color: AppColors.primary);
  static const Icon video = Icon(Icons.video_call, color: AppColors.primary);
  static const Icon removeWhite = Icon(Icons.remove, color: AppColors.white);
  static Icon add({Color? color}) =>
      Icon(Icons.add, color: color ?? AppColors.primary);
  static const Icon addWhite = Icon(Icons.add, color: AppColors.white);
  static const Icon forwardArrow = Icon(
    size: AppSize.size20,
    Icons.arrow_forward,
  );
  static const Icon backArrow = Icon(Icons.arrow_back, color: AppColors.black);
  static const Icon search = Icon(Icons.search);
  static const Icon shoppingCart = Icon(
    Icons.shopping_cart_rounded,
    size: AppSize.size50,
    color: AppColors.primary,
  );
  static const Icon forwardArrowIos = Icon(
    Icons.arrow_forward_ios,
    size: AppSize.size20,
  );
  static const Icon notifications = Icon(Icons.notifications);
  static const Icon feedBackPerson = Icon(Icons.person, color: AppColors.grey);
  static const edit = Icon(Icons.edit, color: AppColors.primary);
  static const star = Icon(Icons.star, color: AppColors.primary);
  static const delete = Icon(Icons.delete, color: AppColors.error);
  static const back = Icon(Icons.arrow_back, color: AppColors.white);

  /// navigation bar
  static const profile = Icon(Icons.person);
  static const events = Icon(Icons.event);
  static const programs = Icon(Icons.apps);
  static const wall = Icon(Icons.grid_view);
  static const home = Icon(Icons.home);
  static const noCartIcon = Icon(
    Icons.shopping_cart_outlined,
    size: AppSize.size80,
    color: AppColors.grey,
  );
}

class AppIconsData {
  static const IconData shoppingBag = Icons.shopping_bag;
  static const IconData feedback = Icons.feedback;
  static const IconData address = Icons.location_on;
  static const IconData polices = Icons.policy;
  static const IconData faq = Icons.question_answer_rounded;
  static const IconData contact = Icons.phone;
  static const IconData shareApp = Icons.share;
  static const IconData changeLanguage = Icons.language;
  static const IconData logout = Icons.logout;
  static const IconData home = Icons.home;
  static const IconData wall = Icons.grid_view;
  static const IconData event = Icons.event_note;
  static const IconData programs = Icons.apps;
  static const IconData profile = Icons.account_circle;
  static const IconData add = Icons.add;
  static const IconData remove = Icons.remove;
  static const IconData radioOff = Icons.radio_button_off;
  static const IconData radioOn = Icons.radio_button_checked;
  static const IconData search = Icons.category_rounded;
  static const IconData audio = Icons.audio_file;
  static const IconData video = Icons.video_call;
}
