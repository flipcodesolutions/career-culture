import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:sizer/sizer.dart';

class ViewAllSelfieScreen extends StatelessWidget {
  const ViewAllSelfieScreen({super.key, required this.imageList});
  final List<String> imageList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          separatorBuilder: (context, index) => SizeHelper.height(),
          itemCount: imageList.length,
          itemBuilder:
              (context, index) => CustomContainer(
                borderRadius: BorderRadius.circular(AppSize.size10),
                backGroundColor: AppColors.lightWhite,
                boxShadow: ShadowHelper.scoreContainer,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSize.size10),
                  child: CustomImageWithLoader(imageUrl: imageList[index]),
                ),
              ),
        ),
      ),
    );
  }
}
