import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/models/chapters_model/chapters_model.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
import '../../../app_const/app_size.dart';
import '../../../utils/method_helpers/shadow_helper.dart';
import '../../../utils/navigation_helper/transitions/scale_fade_transiation.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';
import '../posts_screen.dart';

class ChapterContainer extends StatelessWidget with NavigateHelper {
  const ChapterContainer({super.key, required this.chaptersInfo});
  final ChaptersInfo chaptersInfo;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:
          () async=>
              chaptersInfo.isOpen != null && chaptersInfo.isOpen == true
                  ? push(
                    context: context,
                    widget: PostsScreen(
                      chapterId: chaptersInfo.id ?? 0,
                      chapterName: chaptersInfo.title ?? "",
                    ),
                    transition: ScaleFadePageTransitionsBuilder(),
                  )
                  : WidgetHelper.customSnackBar(
                    autoClose: false,
                    title: AppStrings.notOpenYet,
                    isError: true,
                  ),
      child: CustomContainer(
        width: 90.w,
        padding: EdgeInsets.all(AppSize.size10),
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        borderRadius: BorderRadius.circular(AppSize.size10),
        backGroundColor: AppColors.white,
        borderColor: AppColors.grey,
        borderWidth: 0.5,
        boxShadow: ShadowHelper.scoreContainer,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: CustomContainer(
                    width: 20.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.size10),
                      child: CustomImageWithLoader(
                        imageUrl:
                            "${AppStrings.assetsUrl}${chaptersInfo.image}",
                        skeletonHeight: 10.h,
                      ),
                    ),
                  ),
                ),
                SizeHelper.width(),
                Expanded(
                  flex: 6,
                  child: CustomContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: chaptersInfo.title ?? "",
                          style: TextStyleHelper.mediumHeading,
                          useOverflow: false,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                text: chaptersInfo.description ?? "",

                                maxLines: 2,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: AppColors.secondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
