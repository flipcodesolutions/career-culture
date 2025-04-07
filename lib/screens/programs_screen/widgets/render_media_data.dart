import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/widgets/custom_grid.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
import '../../../app_const/app_size.dart';
import '../../../utils/method_helpers/size_helper.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_listview.dart';
import '../../../widgets/custom_text.dart';

class MediaRender<T> extends StatelessWidget {
  const MediaRender({
    super.key,
    required this.heading,
    this.isList = true,
    this.axisCountForGrid,
    required this.data,
    this.isNotScroll = false,
    required this.itemBuilder,
  });
  final String heading;
  final bool isList;
  final int? axisCountForGrid;
  final List<T> data;
  final bool isNotScroll;
  final Widget Function(T item, int index) itemBuilder; // Custom widget builder
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
                itemBuilder: itemBuilder,
              ),
            )
            : CustomGridWidget(
              isNotScroll: isNotScroll,
              axisCount: axisCountForGrid ?? 2,
              data: data,
              itemBuilder: itemBuilder,
            ),
        SizeHelper.height(),
      ],
    );
  }
}
