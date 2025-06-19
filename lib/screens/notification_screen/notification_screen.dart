import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/models/all_events_model.dart/all_events_model.dart';
import 'package:mindful_youth/models/user_notification/user_notification_model.dart';
import 'package:mindful_youth/provider/user_notification/user_notification_provider.dart';
import 'package:mindful_youth/screens/events_screen/individual_event_screen.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';

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
      await userNotificationProvider.getUserNotification(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserNotificationProvider userNotificationProvider =
        context.watch<UserNotificationProvider>();
    List<UserNotificationsData> notifications =
        userNotificationProvider.userScrollNotification?.data ?? [];
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
              : notifications.isNotEmpty
              ? SingleChildScrollView(
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
                      children: List.generate(
                        notifications.length,
                        (index) => InkWell(
                          onTap: () async {
                            await userNotificationProvider
                                .sentBackendThatNotificationIsOpened(
                                  context: context,
                                  notificationId:
                                      notifications[index].id.toString(),
                                );
                            final bool success = await redirectUserToScreen(
                              redirect:
                                  notifications[index]
                                      .notificationNavigateScreen ??
                                  "",
                              payload: notifications[index].payload ?? "",
                            );
                            if (success && context.mounted) {
                              await userNotificationProvider
                                  .getUserNotification(context: context);
                            }
                          },
                          child: CustomContainer(
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
                                          padding: const EdgeInsets.all(
                                            AppSize.size10,
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CustomText(
                                                useOverflow: false,
                                                text:
                                                    notifications[index]
                                                        .notificationTitle ??
                                                    "",
                                                style:
                                                    TextStyleHelper
                                                        .smallHeading,
                                              ),
                                              CustomText(
                                                useOverflow: false,
                                                text:
                                                    notifications[index]
                                                        .notificationDescription ??
                                                    "",
                                              ),
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
                                      padding: EdgeInsets.only(
                                        right: AppSize.size10,
                                      ),
                                      child: CustomText(
                                        text: MethodHelper.formatDateTime(
                                          notifications[index].createdAt ?? "",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
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
      default:
    }
    return result;
  }
}
