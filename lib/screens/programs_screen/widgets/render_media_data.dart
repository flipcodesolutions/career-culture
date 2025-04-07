import 'package:flutter/material.dart';
import 'package:mindful_youth/widgets/custom_grid.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
import '../../../app_const/app_size.dart';
import '../../../utils/method_helpers/size_helper.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_listview.dart';
import '../../../widgets/custom_text.dart';

class MediaRender extends StatelessWidget {
  const MediaRender({
    super.key,
    required this.heading,
    this.isList = true,
    this.axisCountForGrid,
    required this.data,
    this.isNotScroll = false,
  });
  final String heading;
  final bool isList;
  final int? axisCountForGrid;
  final List data;
  final bool isNotScroll;
  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return SizedBox.shrink();
    }
    return Column(
      children: [
        CustomContainer(
          width: 100.w,
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          backGroundColor: AppColors.lightWhite,
          child: CustomText(
            text: heading,
            style: TextStyleHelper.smallHeading.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
        SizeHelper.height(),
        isList
            ? CustomContainer(
              height: 25.h,
              child: CustomListWidget(
                scrollAxis: Axis.horizontal,
                isNotScroll: isNotScroll,
                data: data,
                itemBuilder:
                    (item, index) => CustomContainer(
                      margin: EdgeInsets.only(right: 5.w),
                      borderRadius: BorderRadius.circular(AppSize.size10),
                      height: 25.h,
                      width: 90.w,
                      backGroundColor: AppColors.cream,
                    ),
              ),
            )
            : CustomGridWidget(
              isNotScroll: isNotScroll,
              axisCount: axisCountForGrid ?? 2,
              data: data,
              itemBuilder:
                  (item, index) =>
                      CustomContainer(backGroundColor: AppColors.cream),
            ),
        SizeHelper.height(),
      ],
    );
  }
}
