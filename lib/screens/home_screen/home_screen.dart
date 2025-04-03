import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_icons.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';
import '../../widgets/custom_animated_circular_progress.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_slider.dart';
import 'home_screen_widget/chapter_progress.dart';
import 'home_screen_widget/dashboard_user_score_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // notification logic
            },
            icon: Icon(Icons.notifications),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizeHelper.height(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: SearchBar(leading: AppIcons.search),
            ),
            SizeHelper.height(height: 4.h),

            /// user score tracking
            DashBoardUserScoreWidget(
              imageUrl: "https://picsum.photos/id/237/200/300",
              score: "5000",
              animationDuration: Duration(seconds: 3),
            ),
            SizeHelper.height(),
            SliderRenderWidget(items: [SizedBox(), SizedBox(), SizedBox()]),
            SizeHelper.height(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: CustomText(
                text: AppStrings.recentActivity,
                style: TextStyleHelper.mediumHeading.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            SizeHelper.height(),

            /// progress
            ChapterProgressWidget(
              imageUrl: "https://picsum.photos/id/237/200/300",
              chapter: "Chapter 1:",
              description: "Analysis Thought Process.",
              progressPercent: 90,
            ),
          ],
        ),
      ),
    );
  }
}
