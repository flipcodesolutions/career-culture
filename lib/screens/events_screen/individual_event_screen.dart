import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/all_event_provider/all_event_provider.dart';
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
import 'package:mindful_youth/widgets/cutom_loader.dart';
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
                  showDialog(
                    context: context,
                    builder:
                        (context) => ContestAgreementWidget(
                          id: eventInfo.id.toString(),
                          termsText: eventInfo.terms ?? "No Terms Found!!",
                        ),
                  );
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

class ContestAgreementWidget extends StatefulWidget {
  final String termsText;
  final String id;

  const ContestAgreementWidget({
    super.key,
    required this.termsText,
    required this.id,
  });

  @override
  _ContestAgreementWidgetState createState() => _ContestAgreementWidgetState();
}

class _ContestAgreementWidgetState extends State<ContestAgreementWidget> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    AllEventProvider eventProvider = context.watch<AllEventProvider>();
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: CustomText(
        useOverflow: false,
        text: AppStrings.acceptTerms,
        style: TextStyleHelper.mediumHeading.copyWith(color: AppColors.primary),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Terms and Conditions Text
          CustomText(text: widget.termsText),
          const SizedBox(height: 10),

          // Checkbox to agree
          Row(
            children: [
              Checkbox(
                activeColor: AppColors.primary,
                value: _agreed,
                onChanged: (value) {
                  setState(() {
                    _agreed = value ?? false;
                  });
                },
              ),
              Expanded(
                child: CustomText(
                  useOverflow: false,
                  text: AppStrings.agreeToTerms,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        eventProvider.isLoading
            ? Center(child: CustomLoader())
            : PrimaryBtn(
              btnText: AppStrings.submit,
              onTap:
                  _agreed
                      ? () =>
                          context.read<UserProvider>().isUserApproved
                              ? eventProvider.eventParticipate(
                                context: context,
                                id: widget.id.toString(),
                              )
                              : WidgetHelper.customSnackBar(
                                context: context,
                                title: AppStrings.yourAreNotApprovedYet,
                                isError: true,
                              )
                      : () => WidgetHelper.customSnackBar(
                        context: context,
                        title: AppStrings.mustAcceptTerms,
                        isError: true,
                      ),
            ),
      ],
    );
  }
}
