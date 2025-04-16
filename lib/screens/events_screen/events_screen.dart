import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/models/all_events_model.dart/all_events_model.dart';
import 'package:mindful_youth/provider/all_event_provider/all_event_provider.dart';
import 'package:mindful_youth/screens/events_screen/individual_event_screen.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_listview.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../app_const/app_strings.dart';
import '../../provider/home_screen_provider/home_screen_provider.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> with NavigateHelper {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      AllEventProvider eventProvider = context.read<AllEventProvider>();
      eventProvider.getAllEvents(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    AllEventProvider eventProvider = context.watch<AllEventProvider>();
    return PopScope(
      canPop: false,
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
                : eventProvider.eventModel?.data?.isNotEmpty == true
                ? CustomListWidget(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                  data: eventProvider.eventModel?.data ?? <EventModel>[],
                  itemBuilder:
                      (item, index) => GestureDetector(
                        onTap:
                            () => push(
                              context: context,
                              widget: IndividualEventScreen(eventInfo: item),
                              transition: FadeForwardsPageTransitionsBuilder(),
                            ),
                        child: CustomContainer(
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
                )
                : Center(child: NoDataFoundWidget()),
      ),
    );
  }
}
