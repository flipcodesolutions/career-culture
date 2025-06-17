import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/models/selfie_model/uploaded_selfies_with_status.dart';
import 'package:mindful_youth/provider/selfie_provider/selfie_provider.dart';
import 'package:mindful_youth/screens/selfie_zone_screens/info_selfie_web_view.dart';
import 'package:mindful_youth/screens/selfie_zone_screens/upload_selfie.dart';
import 'package:mindful_youth/screens/selfie_zone_screens/view_all_selfie_screen.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_grid.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_strings.dart';
import '../../utils/method_helpers/shadow_helper.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/primary_btn.dart';

class SelfieZoneScreen extends StatefulWidget {
  const SelfieZoneScreen({super.key});

  @override
  State<SelfieZoneScreen> createState() => _SelfieZoneScreenState();
}

class _SelfieZoneScreenState extends State<SelfieZoneScreen>
    with NavigateHelper {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final SelfieProvider selfieProvider = context.read<SelfieProvider>();
    Future.microtask(() async {
      await selfieProvider.getUploadedSelfieWithStatus(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final SelfieProvider selfieProvider = context.watch<SelfieProvider>();
    final List<UploadedSelfiesWithStatusModelData>? uploadedSelfie =
        selfieProvider.uploadedSelfiesWithSelfie?.data;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.selfieZone,
          style: TextStyleHelper.mediumHeading,
        ),
        actions: [
          IconButton(
            onPressed:
                () => push(
                  context: context,
                  widget: InfoSelfieWebView(),
                  transition: FadeForwardsPageTransitionsBuilder(),
                ),
            icon: Icon(Icons.question_mark),
          ),
        ],
      ),
      body:
          selfieProvider.isLoading
              ? Center(child: CustomLoader())
              : CustomRefreshIndicator(
                onRefresh: () async {
                  await selfieProvider.getUploadedSelfieWithStatus(
                    context: context,
                  );
                },
                child: ListView(
                  children: [
                    SizeHelper.height(),
                    ExamplePhotos(),
                    if ((uploadedSelfie?.length ?? 0) > 4) ...[
                      SizeHelper.height(),
                      CustomContainer(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        child: InkWell(
                          onTap:
                              () => push(
                                context: context,
                                widget: ViewAllSelfieScreen(
                                  imageList: List.generate(
                                    uploadedSelfie?.length ?? 0,
                                    (index) =>
                                        "${AppStrings.assetsUrl}${uploadedSelfie?[index].images}",
                                  ),
                                ),
                                transition: OpenUpwardsPageTransitionsBuilder(),
                              ),
                          child: CustomContainer(
                            borderRadius: BorderRadius.circular(AppSize.size10),
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 0.5.h,
                            ),
                            backGroundColor: AppColors.lightWhite,
                            child: CustomText(text: "See All"),
                          ),
                        ),
                      ),
                    ],
                    uploadedSelfie?.isNotEmpty == true
                        ? CustomGridWidget(
                          isNotScroll: false,
                          axisCount: 2,
                          data: List.generate(
                            uploadedSelfie?.length ?? 0,
                            (index) =>
                                "${AppStrings.assetsUrl}${uploadedSelfie?[index].images}",
                          ),
                          itemBuilder:
                              (item, index) => CustomContainer(
                                backGroundColor: AppColors.body2,
                                borderRadius: BorderRadius.circular(
                                  AppSize.size10,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppSize.size10,
                                  ),
                                  child: CustomImageWithLoader(imageUrl: item),
                                ),
                              ),
                        )
                        : CustomContainer(
                          height: 20.h,
                          width: 90.w,
                          margin: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 2.h,
                          ),
                          backGroundColor: AppColors.lightWhite,
                          borderRadius: BorderRadius.circular(AppSize.size10),
                          alignment: Alignment.center,
                          child: CustomText(text: "No Selfies To Show..."),
                        ),
                  ],
                ),
              ),
      bottomNavigationBar: CustomContainer(
        margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: PrimaryBtn(
          onTap:
              () => push(
                context: context,
                widget: UploadSelfie(),
                transition: OpenUpwardsPageTransitionsBuilder(),
              ),
          btnText: AppStrings.uploadSelfie,
        ),
      ),
    );
  }
}

class ExamplePhotos extends StatelessWidget with NavigateHelper {
  const ExamplePhotos({super.key});
  @override
  Widget build(BuildContext context) {
    final SelfieProvider selfieProvider = context.watch<SelfieProvider>();
    return selfieProvider.isLoading
        ? Center(child: CustomLoader())
        :
        // : eventProvider.eventModel?.data?.isNotEmpty == true
        // ?
        CustomContainer(
          height: 25.h,
          child: CarouselSlider(
            items:
                // eventProvider.eventModel?.data
                //     ?.where((e) => e.isAnnouncement == "yes")
                [
                  "https://plus.unsplash.com/premium_photo-1701767501250-fda0c8f7907f?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                  "https://plus.unsplash.com/premium_photo-1701767501250-fda0c8f7907f?q=80&w=1932&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                ].map((image) {
                  return AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CustomContainer(
                      boxShadow: ShadowHelper.scoreContainer,
                      backGroundColor: AppColors.white,
                      borderColor: AppColors.grey,
                      borderWidth: 0.2,
                      borderRadius: BorderRadius.circular(AppSize.size10),
                      margin: EdgeInsets.only(right: 5.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.size10),
                        child: CustomImageWithLoader(
                          showImageInPanel: false,
                          fit: BoxFit.cover,
                          imageUrl: "${image}",
                        ),
                      ),
                    ),
                  );
                }).toList(),
            options: CarouselOptions(
              enableInfiniteScroll: false,
              viewportFraction: 0.9,
              disableCenter: true,
              autoPlay: true,
              padEnds: true,
            ),
          ),
        );
    // : Center(
    //   child: NoDataFoundWidget(text: AppStrings.noAnnouncementFound),
    // );
  }
}
