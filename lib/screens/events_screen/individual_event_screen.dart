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
import 'package:mindful_youth/utils/user_screen_time/tracking_mixin.dart';
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

class IndividualEventScreen extends StatefulWidget {
  const IndividualEventScreen({
    super.key,
    required this.eventInfo,
    required this.isMyEvents,
  });
  final EventModel eventInfo;
  final bool isMyEvents;

  @override
  State<IndividualEventScreen> createState() => _IndividualEventScreenState();
}

class _IndividualEventScreenState extends State<IndividualEventScreen>  with  WidgetsBindingObserver, ScreenTracker<IndividualEventScreen> ,NavigateHelper {
    @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  String get screenName => 'EventScreen';
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          AllEventProvider eventProvider = context.read<AllEventProvider>();
          Future.microtask(() async {
            widget.isMyEvents
                ? await eventProvider.getAllUserEvents(context: context)
                : await eventProvider.getAllEvents(context: context);
          });
          pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: widget.eventInfo.title ?? "",
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
                    imageUrl:
                        "${AppStrings.assetsUrl}${widget.eventInfo.poster}",
                  ),
                ),
              ),
              SizeHelper.height(),
              CustomText(
                text: widget.eventInfo.description ?? "No Description To Show ",
                useOverflow: false,
              ),
              SizeHelper.height(),
              HeadingText(text: AppStrings.dateAndTime),
              SizeHelper.height(height: 1.h),
              paddedText(
                heading: "Time :- ",
                text: widget.eventInfo.time ?? "Not Found",
              ),
              paddedText(
                heading: "Registration End Date :- ",
                text: widget.eventInfo.registrationEndDate ?? "Not Found",
              ),
              paddedText(
                heading: "Start Date :- ",
                text: widget.eventInfo.startDate ?? "Not Found",
              ),
              paddedText(
                heading: "End Date :- ",
                text: widget.eventInfo.endDate ?? "Not Found",
              ),

              SizeHelper.height(),
              HeadingText(text: AppStrings.location),
              SizeHelper.height(height: 1.h),
              paddedText(
                heading: "Venue :- ",
                text: widget.eventInfo.venue ?? "Not Provided",
              ),
              SizeHelper.height(),
              HeadingText(text: AppStrings.contactInfo),
              SizeHelper.height(height: 1.h),
              paddedText(
                heading: "Contact :- ",
                text: widget.eventInfo.contact ?? "Not Provided",
              ),
              SizeHelper.height(height: 1.h),
              if (widget.eventInfo.amount?.isNotEmpty == true) ...[
                HeadingText(text: AppStrings.registration),
                paddedText(
                  heading: "${AppStrings.registration} Fee:- ",
                  text:
                      "${widget.eventInfo.amount ?? "Not Found"} ${AppStrings.rupee}",
                ),
                SizeHelper.height(),
              ],
              PrimaryBtn(
                width: 90.w,
                btnText: AppStrings.participate,
                onTap: () {
                  if (userProvider.isUserLoggedIn) {
                    userProvider.isUserApproved
                        ? showDialog(
                          context: context,
                          builder:
                              (context) => ContestAgreementWidget(
                                id: widget.eventInfo.id.toString(),
                                termsText:
                                    widget.eventInfo.terms ??
                                    "No Terms Found!!",
                              ),
                        )
                        : WidgetHelper.customSnackBar(
                          autoClose: false,
                          title: AppStrings.yourAreNotApprovedYet,
                          isError: true,
                        );
                    ;
                  } else {
                    push(
                      context: context,
                      widget: LoginScreen(),
                      transition: ScaleFadePageTransitionsBuilder(),
                    );
                    WidgetHelper.customSnackBar(
                      autoClose: false,
                      title: AppStrings.pleaseLoginFirst,
                      isError: true,
                    );
                  }
                },
              ),
              SizeHelper.height(),
            ],
          ),
        ),
      ),
    );
  }
}

class HeadingText extends StatelessWidget {
  const HeadingText({super.key, required this.text});

  final String text;
  @override
  Widget build(BuildContext context) {
    return CustomText(
      text: text,
      style: TextStyleHelper.mediumHeading.copyWith(color: AppColors.primary),
    );
  }
}

class paddedText extends StatelessWidget {
  const paddedText({super.key, required this.text, required this.heading});
  final String text;
  final String heading;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 3.w),
      child: RichText(
        text: TextSpan(
          text: "• $heading",
          style: TextStyleHelper.smallHeading.copyWith(color: AppColors.black),
          children: <TextSpan>[
            TextSpan(
              text: text,
              style: TextStyleHelper.smallText.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
      //  CustomText(text: "• $text", style: TextStyleHelper.smallHeading),
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
          SizeHelper.height(),

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
                                autoClose: false,
                                title: AppStrings.yourAreNotApprovedYet,
                                isError: true,
                              )
                      : () => WidgetHelper.customSnackBar(
                        title: AppStrings.mustAcceptTerms,
                        isError: true,
                      ),
            ),
      ],
    );
  }
}
