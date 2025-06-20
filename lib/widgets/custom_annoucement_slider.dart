import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_image_strings.dart';
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
                          boxShadow: ShadowHelper.scoreContainer,
                          backGroundColor: AppColors.white,
                          borderColor: AppColors.grey,
                          borderWidth: 0.2,
                          borderRadius: BorderRadius.circular(AppSize.size10),
                          margin: EdgeInsets.only(right: 5.w, bottom: 0.5.h),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppSize.size10),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: CustomImageWithLoader(
                                    showImageInPanel: false,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${AppStrings.assetsUrl}${image.poster}",
                                  ),
                                ),
                                CustomContainer(
                                  padding: EdgeInsets.only(top: 0.3.h),
                                  border: Border(
                                    top: BorderSide(
                                      color: AppColors.grey,
                                      width: 0.2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: CustomText(
                                    text: image.title ?? "",
                                    style: TextStyleHelper.smallHeading
                                        .copyWith(color: AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                    .toList(),
            options: CarouselOptions(
              enableInfiniteScroll: false,
              viewportFraction: 0.9,
              disableCenter: true,
              autoPlay: true,
              padEnds: true,
            ),
          ),
        )
        : Center(
          child: NoDataFoundIcon(icon: AppImageStrings.noDataFoundIcon2),
        );
  }
}
