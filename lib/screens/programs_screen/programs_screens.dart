import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

import '../../app_const/app_strings.dart';

class ProgramsScreens extends StatelessWidget {
  const ProgramsScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.programs,
          style: TextStyleHelper.mediumHeading,
        ),
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSize.size10,
          mainAxisSpacing: AppSize.size10,
          childAspectRatio: 1,
        ),
        itemCount: 10,
        itemBuilder:
            (context, index) => CustomContainer(
              backGroundColor: AppColors.cream,
              borderRadius: BorderRadius.circular(AppSize.size10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: CustomContainer(
                      child: CircleAvatar(radius: AppSize.size50),
                    ),
                  ),
                  Expanded(
                    child: CustomText(
                      text: "index ${index}",
                      style: TextStyleHelper.smallHeading,
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
