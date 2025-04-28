import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/models/chapters_model/chapters_model.dart';
import 'package:mindful_youth/provider/programs_provider/chapter_provider/chapter_provider.dart';
import 'package:mindful_youth/provider/programs_provider/programs_provider.dart';
import 'package:mindful_youth/screens/programs_screen/posts_screen.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_listview.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_strings.dart';
import '../../models/programs/programs_model.dart';
import '../../provider/home_screen_provider/home_screen_provider.dart';
import '../../widgets/custom_grid.dart';
import 'widgets/program_container.dart';

class ProgramsScreens extends StatefulWidget {
  const ProgramsScreens({super.key});

  @override
  State<ProgramsScreens> createState() => _ProgramsScreensState();
}

class _ProgramsScreensState extends State<ProgramsScreens> with NavigateHelper {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ProgramsProvider programsProvider = context.read<ProgramsProvider>();
      programsProvider.getAllPrograms(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    ProgramsProvider programsProvider = context.watch<ProgramsProvider>();
    ChapterProvider chapterProvider = context.watch<ChapterProvider>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        HomeScreenProvider homeScreenProvider =
            context.read<HomeScreenProvider>();
        if (!didPop) {
          homeScreenProvider.setNavigationIndex =
              homeScreenProvider.navigationIndex - 1;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: AppStrings.programs,
            style: TextStyleHelper.mediumHeading,
          ),
        ),
        body:
            programsProvider.isLoading
                ? Center(child: CustomLoader())
                : programsProvider.programsModel?.data?.isNotEmpty == true
                ? CustomRefreshIndicator(
                  onRefresh: () async {
                    await programsProvider.getAllPrograms(context: context);
                    await chapterProvider.getAllChapters(context: context);
                  },
                  child: Column(
                    children: [
                      CustomContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 1.h,
                        ),
                        // backGroundColor: AppColors.error,
                        // height: 5.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // PrimaryBtn(
                            //   width: 25.w,
                            //   height: 4.h,
                            //   // borderColor: ,
                            //   backGroundColor:
                            //       programsProvider.isGridView
                            //           ? null
                            //           : AppColors.white,
                            //   btnText: AppStrings.allTopics,
                            //   onTap: () async {
                            //     programsProvider.setGridView =
                            //         !programsProvider.isGridView;
                            //     await chapterProvider.getAllChapters(
                            //       context: context,
                            //     );
                            //   },
                            Image.asset(
                              AppImageStrings.gridIcon,
                              width: 25.w,
                              height: 5.h,
                            ),
                            // ),
                            // CustomProgressBar(percentage: 50),
                          ],
                        ),
                      ),
                      if (!programsProvider.isGridView) ...[
                        Expanded(
                          child: CustomListWidget(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            data: <ProgramsInfo>[
                              ...programsProvider.programsModel?.data ?? [],
                            ],
                            itemBuilder:
                                (item, index) => ProgramContainer(item: item),
                          ),
                        ),
                        CustomContainer(
                          margin: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 2.h,
                          ),
                          boxShadow: ShadowHelper.scoreContainer,
                          padding: EdgeInsets.all(AppSize.size10),
                          backGroundColor: AppColors.lightWhite,
                          borderRadius: BorderRadius.circular(AppSize.size10),
                          height: 38.h,
                          width: 90.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(
                                text: AppStrings.needABoost,
                                style: TextStyleHelper.mediumHeading.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                              SizeHelper.height(height: 1.h),
                              CustomText(
                                text: AppStrings.takeAMomentToTalkWithUs,
                                useOverflow: false,
                              ),
                              SizeHelper.height(),
                              CounselingOptions(
                                description: AppStrings.bookAfter25,
                                heading: AppStrings.counseling1,
                              ),
                              SizeHelper.height(),
                              CounselingOptions(
                                description: AppStrings.bookAfter75,
                                heading: AppStrings.counseling2,
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child:
                              chapterProvider.isLoading
                                  ? Center(child: CustomLoader())
                                  : CustomGridWidget(
                                    padding: EdgeInsets.all(0),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          childAspectRatio: 1 / 1.3,
                                        ),
                                    data:
                                        chapterProvider.chaptersModel?.data ??
                                        <ChaptersInfo>[],
                                    itemBuilder:
                                        (item, index) => GestureDetector(
                                          onTap:
                                              () => push(
                                                context: context,
                                                widget: PostsScreen(
                                                  chapterId: item.id ?? -1,
                                                  chapterName: item.title ?? "",
                                                ),
                                                transition:
                                                    FadeUpwardsPageTransitionsBuilder(),
                                              ),
                                          child: CustomContainer(
                                            height: 50.h,
                                            backGroundColor:
                                                index.isEven
                                                    ? AppColors.cream
                                                    : AppColors.secondary,
                                            child: Stack(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            AppSize.size10,
                                                          ),
                                                      child: CustomImageWithLoader(
                                                        showImageInPanel: false,
                                                        width: 33.w,
                                                        height: 15.h,
                                                        imageUrl:
                                                            "${AppStrings.assetsUrl}${item.image}",
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: CustomContainer(
                                                        child: CustomText(
                                                          useOverflow: false,
                                                          text:
                                                              (item.title?.length ??
                                                                          0) >
                                                                      50
                                                                  ? "${item.title!.substring(0, 30)} ..."
                                                                  : item.title ??
                                                                      "",
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    axisCount: 2,
                                  ),
                        ),
                      ],
                    ],
                  ),
                )
                : CustomRefreshIndicator(
                  onRefresh:
                      () async => await programsProvider.getAllPrograms(
                        context: context,
                      ),
                  child: ListView(children: [NoDataFoundWidget(height: 80.h)]),
                ),
      ),
    );
  }
}

class CounselingOptions extends StatelessWidget {
  const CounselingOptions({
    super.key,
    required this.description,
    required this.heading,
  });
  final String heading;
  final String description;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      height: 10.h,
      backGroundColor: AppColors.white,
      borderRadius: BorderRadius.circular(AppSize.size10),
      padding: EdgeInsets.all(AppSize.size10),
      boxShadow: ShadowHelper.scoreContainer,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: heading, style: TextStyleHelper.smallHeading),
              SizeHelper.height(height: 1.h),
              CustomText(text: description, style: TextStyleHelper.smallText),
            ],
          ),
          CustomContainer(
            padding: EdgeInsets.all(5),
            width: 10.w,
            child: Image.asset(AppImageStrings.arrowRight),
          ),
        ],
      ),
    );
  }
}

class CustomProgressBar extends StatelessWidget {
  final double percentage; // e.g., 60 for 60%

  const CustomProgressBar({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${percentage.toInt()}%',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Container(
            height: 20,
            width: 250,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(50),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage / 100,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.lightBlueAccent, Colors.blue],
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
