import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/home_screen_provider/home_screen_provider.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../app_const/app_colors.dart';

class CustomSmoothPageIndicator extends StatelessWidget {
  const CustomSmoothPageIndicator({
    super.key,
    required this.pageCount,
    required this.activeIndex,
    this.height,
  });
  final int pageCount;
  final int activeIndex;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      padding: EdgeInsets.all(AppSize.size20),
      height: height ?? 5.h,
      child: AnimatedSmoothIndicator(
        activeIndex: activeIndex, // PageController
        count: pageCount,
        effect: ExpandingDotsEffect(
          activeDotColor: AppColors.darkBlue,
          dotColor: AppColors.grey,
          dotWidth: 2.w,
          dotHeight: 1.h,
        ), // your preferred effect
        onDotClicked: (index) {},
      ),
    );
  }
}
