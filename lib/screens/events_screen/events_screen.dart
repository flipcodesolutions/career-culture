import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_listview.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CustomListWidget(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        data: ["event 1", "event 2"],
        itemBuilder:
            (item, index) => CustomContainer(
              backGroundColor: AppColors.lightWhite,
              margin: EdgeInsets.only(bottom: 1.h),
              borderColor: AppColors.grey,
              borderWidth: 0.5,
              boxShadow: ShadowHelper.scoreContainer,
              borderRadius: BorderRadius.circular(AppSize.size20 - 5),
              height: 20.h,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppSize.size10),
                      ),
                      child: CustomImageWithLoader(
                        width: 90.w,
                        imageUrl:
                            "https://images.pexels.com/photos/31133725/pexels-photo-31133725/free-photo-of-streetlamp-amidst-blooming-cherry-blossoms-at-dusk.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomContainer(
                      alignment: Alignment.center,
                      child: CustomText(
                        text: item,
                        style: TextStyleHelper.smallHeading,
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
