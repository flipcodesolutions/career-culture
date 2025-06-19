import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/all_event_provider/all_event_provider.dart';
import 'package:mindful_youth/screens/events_screen/individual_event_screen.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/utils/user_screen_time/tracking_mixin.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_listview.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';
import '../../provider/home_screen_provider/home_screen_provider.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key, required this.isMyEvents});
  final bool isMyEvents;
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen>
    with NavigateHelper, WidgetsBindingObserver, ScreenTracker<EventsScreen> {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  String get screenName => 'EventScreen';
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      AllEventProvider eventProvider = context.read<AllEventProvider>();
      Future.microtask(() async {
        widget.isMyEvents
            ? eventProvider.getAllUserEvents(context: context)
            : eventProvider.getAllEvents(context: context);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AllEventProvider eventProvider = context.watch<AllEventProvider>();
    return PopScope(
      /// if from my profile pop
      canPop: widget.isMyEvents,
      onPopInvokedWithResult: (didPop, result) {
        HomeScreenProvider homeScreenProvider =
            context.read<HomeScreenProvider>();
        if (!didPop) {
          homeScreenProvider.setNavigationIndex =
              homeScreenProvider.navigationIndex - 1;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: AppStrings.eventActivity,
            style: TextStyleHelper.mediumHeading,
          ),
        ),
        body:
            eventProvider.isLoading
                ? Center(child: CustomLoader())
                : eventProvider
                        .getEventsByModel(isMyEvents: widget.isMyEvents)
                        .isNotEmpty ==
                    true
                ? ListView(
                  children: [
                    if (!widget.isMyEvents)
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 2.h,
                          ),
                          itemBuilder:
                              (context, index) => CustomContainer(
                                width: 80.w,
                                padding: EdgeInsets.all(AppSize.size10),
                                borderRadius: BorderRadius.circular(
                                  AppSize.size10,
                                ),
                                backGroundColor: AppColors.body2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [CustomText(text: "In 2 Days")],
                                    ),
                                    SizeHelper.height(height: 0.5.h),
                                    CustomText(
                                      text:
                                          "hhdfgsdagjhsdjg ngnafrjh jigrwrgkjhw gjwr4 kgrjk hrwhukghu jijijljsdlkfj ",
                                      style: TextStyleHelper.mediumHeading,
                                      maxLines: 3,
                                    ),
                                    SizeHelper.height(height: 1.h),
                                    Spacer(),
                                    Row(
                                      children: [
                                        Image.asset(
                                          AppImageStrings.locationIcon,
                                          width: AppSize.size20,
                                          height: AppSize.size20,
                                        ),
                                        SizeHelper.width(),
                                        CustomText(text: "Ahmedabad"),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          AppImageStrings.eventTimingIcon,
                                          width: AppSize.size20,
                                          height: AppSize.size20,
                                        ),
                                        SizeHelper.width(),
                                        CustomText(text: "8:00 am - 11 :00 am"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          separatorBuilder:
                              (context, index) => SizeHelper.width(),
                          itemCount: 3,
                        ),
                      ),
                    if (!widget.isMyEvents)
                      CustomContainer(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        height: 5.h,
                        child: Row(
                          children: [
                            CustomText(
                              text: "Featured Events",
                              style: TextStyleHelper.mediumHeading.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    CustomRefreshIndicator(
                      onRefresh:
                          () async =>
                              widget.isMyEvents
                                  ? await eventProvider.getAllUserEvents(
                                    context: context,
                                  )
                                  : await eventProvider.getAllEvents(
                                    context: context,
                                  ),
                      child: CustomListWidget(
                        isNotScroll: true,
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 2.h,
                        ),
                        data: eventProvider.getEventsByModel(
                          isMyEvents: widget.isMyEvents,
                        ),
                        itemBuilder:
                            (item, index) => GestureDetector(
                              onTap:
                                  () => push(
                                    context: context,
                                    widget: IndividualEventScreen(
                                      eventInfo: item,
                                      isMyEvents: widget.isMyEvents,
                                    ),
                                    transition:
                                        FadeForwardsPageTransitionsBuilder(),
                                  ),
                              child: CustomContainer(
                                backGroundColor: AppColors.lightWhite,
                                margin: EdgeInsets.only(bottom: 1.h),
                                borderColor: AppColors.grey,
                                borderWidth: 0.5,
                                boxShadow: ShadowHelper.scoreContainer,
                                borderRadius: BorderRadius.circular(
                                  AppSize.size20 - 5,
                                ),
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
                                          showImageInPanel: false,
                                          width: 90.w,
                                          imageUrl:
                                              "${AppStrings.assetsUrl}${item.poster}",
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: CustomContainer(
                                        alignment: Alignment.center,
                                        child: CustomText(
                                          text: item.title ?? "",
                                          style: TextStyleHelper.smallHeading,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      ),
                    ),
                  ],
                )
                : CustomRefreshIndicator(
                  onRefresh:
                      () async =>
                          widget.isMyEvents
                              ? await eventProvider.getAllUserEvents(
                                context: context,
                              )
                              : await eventProvider.getAllEvents(
                                context: context,
                              ),
                  child: ListView(
                    children: [
                      CustomContainer(
                        alignment: Alignment.center,
                        height: 90.h,
                        child: NoDataFoundWidget(
                          text: AppStrings.noEventsFound,
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
