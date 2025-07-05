import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/all_event_provider/all_event_provider.dart';
import 'package:mindful_youth/screens/events_screen/individual_event_screen.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
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
import '../../models/all_events_model.dart/all_events_model.dart';
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
    final List<EventModel?> upcomingEvents = eventProvider.getUpcomingEvents();
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
                    if (!widget.isMyEvents && upcomingEvents.isNotEmpty) ...[
                      CustomContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 1.h,
                        ),
                        child: Row(
                          children: [
                            CustomText(
                              text: "Upcoming Events",
                              style: TextStyleHelper.mediumHeading.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 0.5.h,
                          ),
                          itemBuilder:
                              (context, index) => GestureDetector(
                                onTap:
                                    () => push(
                                      context: context,
                                      widget: IndividualEventScreen(
                                        eventInfo:
                                            upcomingEvents[index] ??
                                            EventModel(),
                                        isMyEvents: widget.isMyEvents,
                                      ),
                                      transition:
                                          FadeForwardsPageTransitionsBuilder(),
                                    ),
                                child: CustomContainer(
                                  width:
                                      upcomingEvents.length == 1 ? 90.w : 80.w,
                                  padding: EdgeInsets.all(AppSize.size10),
                                  borderRadius: BorderRadius.circular(
                                    AppSize.size10,
                                  ),
                                  backGroundColor: AppColors.body2,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          CustomText(
                                            text:
                                                "In ${MethodHelper.daysFromToday(date: upcomingEvents[index]?.startDate ?? "")} Days",
                                          ),
                                        ],
                                      ),
                                      SizeHelper.height(height: 0.5.h),
                                      CustomText(
                                        text:
                                            upcomingEvents[index]?.title ?? "",
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
                                          CustomText(
                                            text:
                                                upcomingEvents[index]?.venue ??
                                                "",
                                            maxLines: 2,
                                          ),
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
                                          CustomText(
                                            text:
                                                upcomingEvents[index]
                                                    ?.startDate ??
                                                "",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          separatorBuilder:
                              (context, index) => SizeHelper.width(),
                          itemCount: upcomingEvents.length,
                        ),
                      ),
                    ],

                    if (!widget.isMyEvents)
                      CustomContainer(
                        margin: EdgeInsets.only(top: 0.5.h),
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
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
                          vertical: 0.5.h,
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
                              child:
                                  !widget.isMyEvents
                                      ? CustomContainer(
                                        height: 20.h,
                                        backGroundColor: AppColors.lightWhite,
                                        margin: EdgeInsets.symmetric(
                                          vertical: 1.h,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          AppSize.size10,
                                        ),
                                        child: Row(
                                          children: [
                                            CustomContainer(
                                              width: 1.w,
                                              borderRadius:
                                                  BorderRadius.horizontal(
                                                    left: Radius.circular(
                                                      AppSize.size10,
                                                    ),
                                                  ),
                                              backGroundColor:
                                                  AppColors.secondary,
                                            ),
                                            Expanded(
                                              child: CustomContainer(
                                                padding: EdgeInsets.all(
                                                  AppSize.size10,
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        CustomText(
                                                          text: MethodHelper.convertToDisplayFormat(
                                                            inputDate:
                                                                item.startDate ??
                                                                "",
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizeHelper.height(
                                                      height: 0.5.h,
                                                    ),
                                                    CustomText(
                                                      text: item.title ?? "",
                                                      style:
                                                          TextStyleHelper
                                                              .mediumHeading,
                                                      maxLines: 3,
                                                    ),
                                                    SizeHelper.height(
                                                      height: 1.h,
                                                    ),
                                                    Spacer(),
                                                    CustomContainer(
                                                      width: 85.w,
                                                      child: Row(
                                                        children: [
                                                          CustomContainer(
                                                            width: 50.w,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Image.asset(
                                                                  AppImageStrings
                                                                      .locationIcon,
                                                                  width:
                                                                      AppSize
                                                                          .size20,
                                                                  height:
                                                                      AppSize
                                                                          .size20,
                                                                ),
                                                                SizeHelper.width(),
                                                                Expanded(
                                                                  child: CustomText(
                                                                    maxLines: 2,
                                                                    text:
                                                                        item.venue ??
                                                                        "",
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Spacer(),
                                                          CustomContainer(
                                                            width: 25.w,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Image.asset(
                                                                  AppImageStrings
                                                                      .eventTimingIcon,
                                                                  width:
                                                                      AppSize
                                                                          .size20,
                                                                  height:
                                                                      AppSize
                                                                          .size20,
                                                                ),
                                                                SizeHelper.width(),
                                                                Expanded(
                                                                  child: CustomText(
                                                                    maxLines: 2,
                                                                    text:
                                                                        item.time ??
                                                                        "",
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : CustomContainer(
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
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                      top: Radius.circular(
                                                        AppSize.size10,
                                                      ),
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
                                                  style:
                                                      TextStyleHelper
                                                          .smallHeading,
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
                        height: 80.h,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [NoDataFoundIcon(text: "No Events Found")],
                        ),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}
