import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/screens/login/login_screen.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/transitions/scale_fade_transiation.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../app_const/app_strings.dart';
import '../../models/all_events_model.dart/all_events_model.dart';

class IndividualEventScreen extends StatelessWidget with NavigateHelper {
  const IndividualEventScreen({super.key, required this.eventInfo});
  final EventModel eventInfo;
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: eventInfo.title ?? "",
          style: TextStyleHelper.mediumHeading,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomContainer(
              width: 90.w,
              height: 30.h,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.size10),
                child: CustomImageWithLoader(
                  imageUrl: "${AppStrings.assetsUrl}${eventInfo.poster}",
                ),
              ),
            ),
            SizeHelper.height(),
            CustomText(
              text: "Time :- ${eventInfo.time}",
              style: TextStyleHelper.smallHeading,
            ),
            CustomText(
              text:
                  "Registration End Date :- ${eventInfo.registrationEndDate ?? "Not Found"}",
              style: TextStyleHelper.smallHeading,
            ),
            CustomText(
              text:
                  "Start Date :- ${eventInfo.registrationEndDate ?? "Not Found"}",
              style: TextStyleHelper.smallHeading,
            ),
            CustomText(
              text:
                  "End Date :- ${eventInfo.registrationEndDate ?? "Not Found"}",
              style: TextStyleHelper.smallHeading,
            ),
            if (eventInfo.amount?.isNotEmpty == true)
              CustomText(
                text:
                    "End Date :- ${eventInfo.registrationEndDate ?? "Not Found"}",
                style: TextStyleHelper.smallHeading,
              ),
            SizeHelper.height(),
            CustomText(
              text: eventInfo.description ?? "No Description To Show ",
              useOverflow: false,
            ),
            SizeHelper.height(),
            PrimaryBtn(
              width: 90.w,
              btnText: AppStrings.participant,
              onTap: () {
                if (userProvider.isUserLoggedIn) {
                } else {
                  push(
                    context: context,
                    widget: LoginScreen(),
                    transition: ScaleFadePageTransitionsBuilder(),
                  );
                  WidgetHelper.customSnackBar(
                    context: context,
                    title: AppStrings.pleaseLoginFirst,
                    isError: true,
                  );
                }
              },
            ),
            SizeHelper.height(),
            CustomText(text: "Venue :- ${eventInfo.venue}"),
          ],
        ),
      ),
    );
  }
}
