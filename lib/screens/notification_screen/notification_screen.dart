import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/models/all_events_model.dart/all_events_model.dart';
import 'package:mindful_youth/models/feedback_model/feedback_model.dart';
import 'package:mindful_youth/models/user_notification/counseling_schedual_change_model.dart';
import 'package:mindful_youth/models/user_notification/user_notification_model.dart';
import 'package:mindful_youth/provider/user_notification/user_notification_provider.dart';
import 'package:mindful_youth/screens/events_screen/individual_event_screen.dart';
import 'package:mindful_youth/screens/feedback_screen/feedback_screen.dart';
import 'package:mindful_youth/screens/wall_screen/individual_wall_post_screen.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';
import '../../utils/api_helper/api_helper.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with NavigateHelper {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final UserNotificationProvider userNotificationProvider =
        context.read<UserNotificationProvider>();
    Future.microtask(() async {
      await Future.wait([
        userNotificationProvider.getUserNotification(context: context),
        userNotificationProvider.getUserFeedbackNotification(context: context),
        userNotificationProvider.getCounselingChangesNotifications(
          context: context,
        ),
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserNotificationProvider userNotificationProvider =
        context.watch<UserNotificationProvider>();
    List<UserNotificationsData> notifications =
        userNotificationProvider.userScrollNotification?.data ?? [];
    List<FeedbackModelData> feedbackNotifications =
        userNotificationProvider.userFeedbackModel?.data ?? [];
    CounselingSchedualChangeNotificationModel?
    counselingSchedualChangeNotificationModel =
        userNotificationProvider.counselingChangesNotifications;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.notifications,
          style: TextStyleHelper.mediumHeading,
        ),
      ),
      body:
          userNotificationProvider.isLoading
              ? Center(child: CustomLoader())
              : notifications.isNotEmpty ||
                  feedbackNotifications.isNotEmpty ||
                  counselingSchedualChangeNotificationModel
                          ?.data
                          ?.notificationTitle !=
                      null
              ? CustomRefreshIndicator(
                onRefresh: () async {
                  await Future.wait([
                    userNotificationProvider.getUserNotification(
                      context: context,
                    ),
                    userNotificationProvider.getUserFeedbackNotification(
                      context: context,
                    ),
                    userNotificationProvider.getCounselingChangesNotifications(
                      context: context,
                    ),
                  ]);
                },
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  child: AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        childAnimationBuilder:
                            (widget) => SlideAnimation(
                              horizontalOffset: 30.w,
                              duration: Duration(milliseconds: 500),
                              child: FadeInAnimation(
                                duration: Duration(milliseconds: 500),
                                child: widget,
                              ),
                            ),
                        children: [
                          /// load the notification that is releated to counseling scheduals
                          if (counselingSchedualChangeNotificationModel
                                  ?.data
                                  ?.notificationTitle !=
                              null)
                            InkWell(
                              onTap: () async {
                                final bool
                                success = await userNotificationProvider
                                    .sentBackendThatNotificationIsOpened(
                                      context: context,
                                      apiUrl:
                                          ApiHelper
                                              .userReadStatusChangeNotification,
                                      body: {
                                        "appointmentId":
                                            (counselingSchedualChangeNotificationModel
                                                        ?.data
                                                        ?.appointmentId ??
                                                    -1)
                                                .toString(),
                                      },
                                    );
                                if (success) {
                                  await Future.wait([
                                    userNotificationProvider
                                        .getUserNotification(context: context),
                                    userNotificationProvider
                                        .getUserFeedbackNotification(
                                          context: context,
                                        ),
                                    userNotificationProvider
                                        .getCounselingChangesNotifications(
                                          context: context,
                                        ),
                                  ]);
                                } else {
                                  WidgetHelper.customSnackBar(
                                    title: "Please Try Again...",
                                    isError: true,
                                  );
                                }
                              },
                              child: NotificationTile(
                                title:
                                    counselingSchedualChangeNotificationModel
                                        ?.data
                                        ?.notificationTitle ??
                                    "",
                                description:
                                    counselingSchedualChangeNotificationModel
                                        ?.data
                                        ?.notificationDescription ??
                                    "",
                                createdAt:
                                    DateTime.timestamp().toIso8601String(),
                              ),
                            ),

                          /// load any feedback notification about expreince with counseling
                          if (feedbackNotifications.isNotEmpty) ...[
                            ...List.generate(
                              feedbackNotifications.length,
                              (index) => InkWell(
                                onTap: () async {
                                  final bool success = await push(
                                    context: context,
                                    widget: FeedbackPage(
                                      model:
                                          feedbackNotifications[index]
                                              .payload ??
                                          FeedbackModelPayload(),
                                    ),
                                  );
                                  if (success) {
                                    await Future.wait([
                                      userNotificationProvider
                                          .getUserNotification(
                                            context: context,
                                          ),
                                      userNotificationProvider
                                          .getUserFeedbackNotification(
                                            context: context,
                                          ),
                                    ]);
                                  }
                                },
                                child: NotificationTile(
                                  createdAt:
                                      feedbackNotifications[index]
                                          .payload
                                          ?.counselingBy
                                          ?.createdAt ??
                                      '',
                                  description:
                                      feedbackNotifications[index]
                                          .notificationDescription ??
                                      "",
                                  title:
                                      feedbackNotifications[index]
                                          .notificationTitle ??
                                      '',
                                ),
                              ),
                            ),
                            Divider(endIndent: 5.w, indent: 5.w, height: 2.h),
                            SizeHelper.height(height: 1.h),
                          ],

                          /// notification that are commans
                          ...List.generate(
                            notifications.length,
                            (index) => InkWell(
                              onTap: () async {
                                final bool
                                success = await userNotificationProvider
                                    .sentBackendThatNotificationIsOpened(
                                      context: context,
                                      apiUrl:
                                          ApiHelper.sentUserOpenNotification,
                                      body: {
                                        "notificationId":
                                            notifications[index].id.toString(),
                                      },
                                    );
                                if (success) {
                                  final bool success =
                                      await redirectUserToScreen(
                                        redirect:
                                            notifications[index]
                                                .notificationNavigateScreen ??
                                            "",
                                        payload:
                                            notifications[index].payload ?? "",
                                      );
                                  if (success) {
                                    await Future.wait([
                                      userNotificationProvider
                                          .getUserNotification(
                                            context: context,
                                          ),
                                      userNotificationProvider
                                          .getUserFeedbackNotification(
                                            context: context,
                                          ),
                                      userNotificationProvider
                                          .getCounselingChangesNotifications(
                                            context: context,
                                          ),
                                    ]);
                                  }
                                } else {
                                  WidgetHelper.customSnackBar(
                                    title: "Please Try Again...",
                                    isError: true,
                                  );
                                }
                              },
                              child: NotificationTile(
                                title:
                                    notifications[index].notificationTitle ??
                                    "",
                                description:
                                    notifications[index]
                                        .notificationDescription ??
                                    "",
                                createdAt: notifications[index].createdAt ?? "",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              : Center(
                child: CustomContainer(
                  width: 60.w,
                  height: 60.h,
                  child: Image.asset(AppImageStrings.noNotificationToShow),
                ),
              ),
    );
  }

  Future<bool> redirectUserToScreen({
    required String redirect,
    required String payload,
  }) async {
    Map<String, dynamic> payLoad = jsonDecode(payload);
    bool result = false;
    switch (redirect) {
      case "event":
        result = await push(
          context: context,
          widget: IndividualEventScreen(
            eventInfo: EventModel.fromJson(payLoad),
            isMyEvents: false,
          ),
        );
        break;
      case "wall":
        result = await push(
          context: context,
          widget: IndividualWallPostScreen(
            slug: payLoad['slug'],
            isFromWallScreen: false,
          ),
        );
        break;
      default:
    }
    return result;
  }
}

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.createdAt,
    required this.description,
    required this.title,
  });
  final String title;
  final String description;
  final String createdAt;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      borderRadius: BorderRadius.circular(AppSize.size10),
      margin: EdgeInsets.only(bottom: 1.h),
      backGroundColor: AppColors.lightWhite,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomContainer(
                  padding: EdgeInsets.all(AppSize.size20),
                  child: Icon(Icons.notifications),
                ),
              ),
              Expanded(
                flex: 5,
                child: CustomContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSize.size10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          useOverflow: false,
                          text: title,
                          style: TextStyleHelper.smallHeading,
                        ),
                        CustomText(useOverflow: false, text: description),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomContainer(
                padding: EdgeInsets.only(right: AppSize.size10),
                child: CustomText(text: MethodHelper.formatDateTime(createdAt)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
