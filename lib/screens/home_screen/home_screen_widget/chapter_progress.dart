import 'package:flutter/material.dart';
import 'package:mindful_youth/provider/programs_provider/post_provider/post_provider.dart';
import 'package:mindful_youth/provider/recent_activity_provider/recent_activity_provider.dart';
import 'package:mindful_youth/screens/programs_screen/posts_screen.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
import '../../../app_const/app_size.dart';
import '../../../app_const/app_strings.dart';
import '../../../utils/method_helpers/shadow_helper.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';

class ChapterProgressWidget extends StatelessWidget with NavigateHelper {
  ChapterProgressWidget({super.key});
  @override
  Widget build(BuildContext context) {
    RecentActivityProvider recentActivityProvider =
        context.watch<RecentActivityProvider>();
    return GestureDetector(
      onTap: () async {
        PostProvider postProvider = context.read<PostProvider>();
        postProvider.setPostInfo = recentActivityProvider.recentPost;
        push(
          context: context,
          widget: PostsScreen(
            chapterId: recentActivityProvider.recentPost?.chapterId ?? 0,
            chapterName: recentActivityProvider.recentPost?.title ?? "",
          ),
          transition: FadeForwardsPageTransitionsBuilder(),
        );
      },
      child: CustomContainer(
        width: 90.w,
        height: recentActivityProvider.isRecentActivity() ? 15.h : 5.h,
        margin: EdgeInsets.symmetric(horizontal: 5.w),
        borderRadius: BorderRadius.circular(AppSize.size10),
        backGroundColor: AppColors.white,
        borderColor: AppColors.grey,
        borderWidth: 0.5,
        boxShadow: ShadowHelper.scoreContainer,
        child:
            recentActivityProvider.isLoading
                ? Center(child: CustomLoader())
                : recentActivityProvider.isRecentActivity()
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomContainer(
                      width: 30.w,
                      height: 15.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.size10),
                        child: CustomImageWithLoader(
                          fit: BoxFit.cover,
                          imageUrl:
                              "${AppStrings.assetsUrl}${recentActivityProvider.recentPost?.image}",
                        ),
                      ),
                    ),
                    SizeHelper.width(),
                    CustomContainer(
                      width: 55.w,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text:
                                recentActivityProvider.recentPost?.title ?? "",
                            maxLines: 2,
                            style: TextStyleHelper.mediumHeading,
                          ),
                          CustomText(
                            text:
                                recentActivityProvider
                                    .recentPost
                                    ?.description ??
                                "",
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                : Center(child: CustomText(text: AppStrings.noRecentActivity)),
      ),
    );
  }
}
