import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_listview.dart';
import 'package:sizer/sizer.dart';

import '../../../app_const/app_strings.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key, required this.imagesStrings});
  final List<String> imagesStrings;
  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CustomListWidget(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        data: widget.imagesStrings,
        itemBuilder:
            (item, index) => CustomContainer(
              borderRadius: BorderRadius.circular(AppSize.size10),
              backGroundColor: AppColors.lightWhite,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.size10),
                child: CustomImageWithLoader(
                  skeletonHeight: 20.h,
                  imageUrl: "${AppStrings.assetsUrl}${item}",
                ),
              ),
            ),
      ),
    );
  }
}
