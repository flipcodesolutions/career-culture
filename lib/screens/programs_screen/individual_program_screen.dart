import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/models/programs/programs_model.dart';
import 'package:mindful_youth/provider/programs_provider/chapter_provider/chapter_provider.dart';
import 'package:mindful_youth/provider/programs_provider/programs_provider.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../utils/user_screen_time/tracking_mixin.dart';
import '../../widgets/custom_animated_circular_progress.dart';
import '../../widgets/custom_text.dart';

class IndividualProgramScreen extends StatefulWidget {
  const IndividualProgramScreen({super.key, required this.programName});
  final String programName;
  @override
  State<IndividualProgramScreen> createState() =>
      _IndividualProgramScreenState();
}

class _IndividualProgramScreenState extends State<IndividualProgramScreen>
    with
        NavigateHelper,
        WidgetsBindingObserver,
        ScreenTracker<IndividualProgramScreen> {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  String get screenName => widget.programName;
  @override
  bool get debug => false; // Enable debug logs
  @override
  void initState() {
    ProgramsProvider programsProvider = context.read<ProgramsProvider>();
    ChapterProvider chapterProvider = context.read<ChapterProvider>();
    UserProvider userProvider = context.read<UserProvider>();
    super.initState();
    Future.microtask(() {
      // / get chapter by id
      chapterProvider.getChapterById(
        context: context,
        id: (programsProvider.currentProgramInfo?.id ?? 0).toString(),
      );
      programsProvider.getUserProgress(
        context: context,
        pId: programsProvider.currentProgramInfo?.id.toString() ?? "",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ProgramsProvider programsProvider = context.watch<ProgramsProvider>();
    ChapterProvider chapterProvider = context.watch<ChapterProvider>();
    ProgramsInfo? program = programsProvider.currentProgramInfo;
    UserProvider userProvider = context.read<UserProvider>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await programsProvider.getUserProgress(context: context).then((_) {
            pop(context);
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            style: TextStyleHelper.mediumHeading,
            text: program?.title ?? "",
          ),
        ),
        body:
            programsProvider.isLoading
                ? Center(child: CustomLoader())
                : CustomRefreshIndicator(
                  onRefresh:
                      () async => Future.wait([
                        chapterProvider.getChapterById(
                          context: context,
                          id:
                              (programsProvider.currentProgramInfo?.id ?? 0)
                                  .toString(),
                        ),
                        programsProvider.getUserProgress(
                          context: context,
                          pId:
                              programsProvider.currentProgramInfo?.id
                                  .toString() ??
                              "",
                        ),
                      ]),

                  child: ListView(
                    children: [
                      ImageContainer(
                        image: "${AppStrings.assetsUrl}${program?.image}",
                        showImageInPanel: true,
                      ),
                      SizeHelper.height(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Html(data: program?.description ?? ""),
                        //  CustomText(
                        //   text: program?.description ?? "",
                        //   useOverflow: false,
                        // ),
                      ),
                      SizeHelper.height(),
                      ////
                      CustomContainer(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 1.h,
                        ),
                        backGroundColor: AppColors.lightWhite,
                        child: CustomText(
                          text: AppStrings.aspectForYourMentalWellBeing,
                          style: TextStyleHelper.smallHeading.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizeHelper.height(),
                      if (programsProvider.userProgressModel?.data != null) ...[
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
                                  percentage: programsProvider.getPercentage(),
                                  size: AppSize.size100,
                                  duration: Duration(seconds: 2),
                                ),
                              ),
                              SizeHelper.width(),
                              Expanded(
                                child: CustomContainer(
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSize.size10,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomText(
                                        text: "Overall Progress",
                                        useOverflow: false,
                                        style: TextStyleHelper.mediumHeading
                                            .copyWith(color: AppColors.primary),
                                      ),
                                      CustomText(
                                        text:
                                            AppStrings.getMessageAccordingToProgress(
                                              percentage:
                                                  programsProvider
                                                      .getPercentage(),
                                            ),
                                        useOverflow: false,
                                        style: TextStyleHelper.smallText,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizeHelper.height(),
                      ],

                      /// load if any chapter available
                      if (chapterProvider.isLoading) ...[
                        Center(child: CustomLoader()),
                      ] else ...[
                        ...chapterProvider.renderChapterList(
                          isUserLoggedIn: userProvider.isUserLoggedIn,
                          userProgressModel: programsProvider.userProgressModel,
                        ),
                      ],
                    ],
                  ),
                ),
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  const ImageContainer({
    super.key,
    required this.image,
    required this.showImageInPanel,
    this.fit,
    this.aspectRatio,
  });
  final bool showImageInPanel;
  final String image;
  final BoxFit? fit;
  final double? aspectRatio;
  @override
  Widget build(BuildContext context) {
    log("image $image");
    return CustomContainer(
      child: CustomContainer(
        backGroundColor: AppColors.lightWhite,
        // boxShadow: ShadowHelper.scoreContainer,
        // borderRadius: BorderRadius.circular(AppSize.size10),
        child: ClipRRect(
          // borderRadius: BorderRadius.circular(AppSize.size10),
          child: AspectRatio(
            aspectRatio: aspectRatio ?? 16 / 9,
            child: CustomImageWithLoader(
              imageUrl: image,
              showImageInPanel: showImageInPanel,
              fit: fit ?? BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
