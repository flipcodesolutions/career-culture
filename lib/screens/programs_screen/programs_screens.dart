import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import '../../app_const/app_strings.dart';
import '../../widgets/custom_grid.dart';

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
      body: CustomGridWidget(
        data: <String>["one", "Two", "Three"],
        itemBuilder:
            (item, index) => CustomContainer(
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
        axisCount: 2,
      ),
    );
  }
}
