import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/models/programs/programs_model.dart';
import 'package:mindful_youth/provider/programs_provider/chapter_provider/chapter_provider.dart';
import 'package:mindful_youth/provider/programs_provider/programs_provider.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../widgets/custom_animated_circular_progress.dart';
import '../../widgets/custom_text.dart';

class IndividualProgramScreen extends StatefulWidget {
  const IndividualProgramScreen({super.key});
  @override
  State<IndividualProgramScreen> createState() =>
      _IndividualProgramScreenState();
}

class _IndividualProgramScreenState extends State<IndividualProgramScreen> {
  @override
  void initState() {
    ProgramsProvider programsProvider = context.read<ProgramsProvider>();
    ChapterProvider chapterProvider = context.read<ChapterProvider>();
    super.initState();
    Future.microtask(() {
      // if (chapterProvider.chaptersModel?.data?.isEmpty == true) {
      chapterProvider.getChapterById(
        context: context,
        id: (programsProvider.currentProgramInfo?.id ?? 0).toString(),
      );
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    ProgramsProvider programsProvider = context.watch<ProgramsProvider>();
    ChapterProvider chapterProvider = context.watch<ChapterProvider>();
    ProgramsInfo? program = programsProvider.currentProgramInfo;
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          style: TextStyleHelper.mediumHeading,
          text: program?.title ?? "",
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        children: [
          CustomContainer(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            height: 30.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.size20),
              child: CustomImageWithLoader(
                imageUrl: "${AppStrings.assetsUrl}${program?.image ?? ""}",
              ),
            ),
          ),
          SizeHelper.height(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: CustomText(text: program?.description ?? ""),
          ),
          SizeHelper.height(),
          ////
          CustomContainer(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            backGroundColor: AppColors.lightWhite,
            child: CustomText(
              text: AppStrings.aspectForYourMentalWellBeing,
              style: TextStyleHelper.smallHeading.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          SizeHelper.height(),
          CustomContainer(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            boxShadow: ShadowHelper.scoreContainer,
            borderRadius: BorderRadius.circular(AppSize.size10),
            backGroundColor: AppColors.lightWhite,
            padding: EdgeInsets.all(AppSize.size10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer(
                  padding: EdgeInsets.only(left: AppSize.size10),
                  child: AnimatedCircularProgress(
                    percentage: 99,

                    size: AppSize.size100,
                    duration: Duration(seconds: 2),
                  ),
                ),
                SizeHelper.width(),
                Expanded(
                  child: CustomContainer(
                    padding: EdgeInsets.symmetric(vertical: AppSize.size20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text: "Overall Progress",
                          useOverflow: false,
                          style: TextStyleHelper.mediumHeading.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        CustomText(
                          text: "Overall Progress",
                          useOverflow: false,
                          style: TextStyleHelper.smallHeading,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizeHelper.height(),

          /// load if any chapter available
          if (chapterProvider.isLoading) ...[
            Center(child: CustomLoader()),
          ] else ...[
            ...chapterProvider.renderChapterList(),
          ],
        ],
      ),
    );
  }
}
