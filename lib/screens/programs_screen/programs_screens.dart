import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/models/chapters_model/chapters_model.dart';
import 'package:mindful_youth/provider/programs_provider/chapter_provider/chapter_provider.dart';
import 'package:mindful_youth/provider/programs_provider/programs_provider.dart';
import 'package:mindful_youth/screens/programs_screen/posts_screen.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
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
                            PrimaryBtn(
                              width: 25.w,
                              height: 4.h,
                              // borderColor: ,
                              backGroundColor:
                                  programsProvider.isGridView
                                      ? null
                                      : AppColors.white,
                              btnText: AppStrings.allTopics,
                              onTap: () async {
                                programsProvider.setGridView =
                                    !programsProvider.isGridView;
                                await chapterProvider.getAllChapters(
                                  context: context,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      if (!programsProvider.isGridView) ...[
                        Expanded(
                          child: CustomGridWidget(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            data: <ProgramsInfo>[
                              ...programsProvider.programsModel?.data ?? [],
                            ],
                            itemBuilder:
                                (item, index) => ProgramContainer(item: item),
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
                                                  mainAxisSize: MainAxisSize.min,
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
                      () async =>
                          await programsProvider.getAllPrograms(context: context),
                  child: ListView(children: [NoDataFoundWidget(height: 80.h)]),
                ),
      ),
    );
  }
}
