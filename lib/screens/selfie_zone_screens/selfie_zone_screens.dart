import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/selfie_provider/selfie_provider.dart';
import 'package:mindful_youth/screens/selfie_zone_screens/upload_selfie.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_strings.dart';
import '../../models/selfie_model/selfie_model.dart';
import '../../widgets/custom_container.dart';

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
      await selfieProvider.getSelfieZone(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final SelfieProvider selfieProvider = context.watch<SelfieProvider>();
    final List<GetSelfieZoneData>? selfieZoneList =
        selfieProvider.selfieZone?.data;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.selfieZone,
          style: TextStyleHelper.mediumHeading,
        ),
      ),
      body:
          selfieProvider.isLoading
              ? Center(child: CustomLoader())
              : selfieZoneList?.isNotEmpty == true
              ? ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.5.h),
                separatorBuilder:
                    (context, index) => SizeHelper.height(height: 1.h),
                itemCount: selfieZoneList?.length ?? 0,
                itemBuilder:
                    (context, index) => CustomContainer(
                      padding: EdgeInsets.all(AppSize.size10),
                      backGroundColor: AppColors.lightWhite,
                      borderRadius: BorderRadius.circular(AppSize.size10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            text: selfieZoneList?[index].title ?? "",
                            useOverflow: false,
                          ),
                          SizeHelper.height(height: 1.h),
                          InkWell(
                            onTap:
                                () => push(
                                  context: context,
                                  widget: UploadSelfie(
                                    selfie: selfieZoneList?[index],
                                  ),
                                  transition:
                                      OpenUpwardsPageTransitionsBuilder(),
                                ),
                            child: CustomContainer(
                              padding: EdgeInsets.symmetric(
                                vertical: 1.h,
                                horizontal: 5.w,
                              ),
                              backGroundColor: AppColors.faqQuestion,
                              borderRadius: BorderRadius.circular(
                                AppSize.size10,
                              ),
                              child: CustomText(
                                text: AppStrings.uploadSelfie,
                                style: TextStyleHelper.smallHeading.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              )
              : Center(child: NoDataFoundWidget()),
    );
  }
}
