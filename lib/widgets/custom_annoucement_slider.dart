import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:sizer/sizer.dart';
import '../provider/all_event_provider/all_event_provider.dart';
import '../screens/events_screen/individual_event_screen.dart';
import '../utils/navigation_helper/navigation_helper.dart';
import 'custom_container.dart';
import 'custom_image.dart';

class CustomAnnouncementSlider extends StatelessWidget with NavigateHelper {
  const CustomAnnouncementSlider({super.key, required this.eventProvider});
  final AllEventProvider eventProvider;
  @override
  Widget build(BuildContext context) {
    return eventProvider.isLoading
        ? Center(child: CustomLoader())
        : eventProvider.eventModel?.data?.isNotEmpty == true
        ? CustomContainer(
          child: CarouselSlider(
            items:
                eventProvider.eventModel?.data
                    ?.where((e) => e.isAnnouncement == "yes")
                    .map((image) {
                      return GestureDetector(
                        onTap: () {
                          push(
                            context: context,
                            widget: IndividualEventScreen(
                              eventInfo: image,
                              isMyEvents: false,
                            ),
                            transition: FadeForwardsPageTransitionsBuilder(),
                          );
                        },
                        child: CustomContainer(
                          borderRadius: BorderRadius.circular(AppSize.size10),
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppSize.size10),
                            child: CustomImageWithLoader(
                              showImageInPanel: false,
                              fit: BoxFit.cover,
                              imageUrl:
                                  "${AppStrings.assetsUrl}${image.poster}",
                            ),
                          ),
                        ),
                      );
                    })
                    .toList(),
            options: CarouselOptions(
              enableInfiniteScroll: false,
              viewportFraction: 1,
              height: 25.h,
              disableCenter: true,
              autoPlay: true,
              padEnds: true,
            ),
          ),
        )
        : Center(child: NoDataFoundWidget(text: AppStrings.noAnnouncementFound,));
  }
}
