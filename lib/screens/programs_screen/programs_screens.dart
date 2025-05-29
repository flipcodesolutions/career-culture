import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/models/chapters_model/chapters_model.dart';
import 'package:mindful_youth/provider/programs_provider/chapter_provider/chapter_provider.dart';
import 'package:mindful_youth/provider/programs_provider/programs_provider.dart';
import 'package:mindful_youth/provider/user_provider/sign_up_provider.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/screens/cousling_screens/cousiling_form_screen.dart';
import 'package:mindful_youth/screens/login/login_screen.dart';
import 'package:mindful_youth/screens/programs_screen/posts_screen.dart';
import 'package:mindful_youth/utils/list_helper/list_helper.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/transitions/scale_fade_transiation.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_listview.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:mindful_youth/widgets/user_name_and_userid.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_strings.dart';
import '../../models/programs/programs_model.dart';
import '../../provider/home_screen_provider/home_screen_provider.dart';
import '../../utils/user_screen_time/tracking_mixin.dart';
import '../../widgets/custom_grid.dart';
import '../../widgets/custom_profile_pic_circle.dart';
import 'widgets/program_container.dart';

class ProgramsScreens extends StatefulWidget {
  const ProgramsScreens({super.key});

  @override
  State<ProgramsScreens> createState() => _ProgramsScreensState();
}

class _ProgramsScreensState extends State<ProgramsScreens>
    with
        NavigateHelper,
        WidgetsBindingObserver,
        ScreenTracker<ProgramsScreens> {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  String get screenName => 'ProgramScreen';
  @override
  bool get debug => false; // Enable debug logs
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ProgramsProvider programsProvider = context.read<ProgramsProvider>();
    UserProvider userProvider = context.read<UserProvider>();
    Future.microtask(() async {
      programsProvider.getAllPrograms(context: context);
      userProvider.isUserLoggedIn
          ? await programsProvider.getUserProgress(context: context)
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    ProgramsProvider programsProvider = context.watch<ProgramsProvider>();
    ChapterProvider chapterProvider = context.watch<ChapterProvider>();
    UserProvider userProvider = context.watch<UserProvider>();
    SignUpProvider signUpProvider = context.watch<SignUpProvider>();
    HomeScreenProvider homeProvider = context.read<HomeScreenProvider>();
    final int counselingCount =
        homeProvider.overAllScoreModel?.data?.counselingCount ?? 0;
    final bool isFirstOpen = programsProvider.getPercentage() > 25;
    final bool isSecondOpen = programsProvider.getPercentage() > 75;
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
          actions: [
            InkWell(
              onTap: () async {
                programsProvider.setGridView = !programsProvider.isGridView;
                await chapterProvider.getAllChapters(context: context);
              },
              child: CustomContainer(
                width: 8.w,
                height: 4.h,
                margin: EdgeInsets.only(right: 3.w),
                child: Image.asset(
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                  programsProvider.isGridView
                      ? AppImageStrings.gridIcon
                      : AppImageStrings.gridOffIcon,
                ),
              ),
            ),
          ],
          title: CustomText(
            textAlign: TextAlign.center,
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
                        borderRadius: BorderRadius.circular(AppSize.size10),
                        backGroundColor: AppColors.lightWhite,
                        margin: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 2.h,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 1.h,
                        ),

                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            UserNameAndUIdRow(),
                            SizeHelper.height(height: 1.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CustomUserProfilePicCircle(
                                  isPhotoString:
                                      userProvider
                                          .user
                                          .profile
                                          ?.images
                                          ?.isNotEmpty ==
                                      true,
                                  photoLink: userProvider.user.profile?.images,
                                ),

                                CustomProgressBar(
                                  width: 60.w,
                                  percentage: programsProvider.getPercentage(),
                                ),
                              ],
                            ),
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
                                (item, index) => ProgramContainer(
                                  item: item,
                                  gradient: ListHelper.programListGradient
                                      .elementAtOrNull(index),
                                ),
                          ),
                        ),

                        /// this the counseling container that will now show only not completed counseling sessions,
                        CounselingContainer(
                          counselingCount: counselingCount,
                          isFirstOpen: isFirstOpen,
                          isSecondOpen: isSecondOpen,
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
                                          // childAspectRatio: 1 / 1.3,
                                        ),
                                    data:
                                        chapterProvider.chaptersModel?.data ??
                                        <ChaptersInfo>[],
                                    itemBuilder:
                                        (item, index) => GestureDetector(
                                          onTap:
                                              () =>
                                                  userProvider.isUserLoggedIn
                                                      ? checkIfChapterIsOpen(
                                                            chapterProvider,
                                                            programsProvider,
                                                            index,
                                                          )
                                                          ? goToPost(
                                                            context,
                                                            item,
                                                          )
                                                          : WidgetHelper.customSnackBar(
                                                            // context: context,
                                                            title:
                                                                AppStrings
                                                                    .notOpenYet,
                                                            isError: true,
                                                          )
                                                      : {
                                                        /// redirect if not logged in
                                                        goToLoginPageWithWarning(
                                                          context,
                                                        ),
                                                      },
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
                                                    AspectRatio(
                                                      aspectRatio: 16 / 9,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              AppSize.size10,
                                                            ),
                                                        child: CustomImageWithLoader(
                                                          showImageInPanel:
                                                              false,
                                                          width: 33.w,
                                                          height: 15.h,
                                                          imageUrl:
                                                              "${AppStrings.assetsUrl}${item.image}",
                                                        ),
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
                                                                  ? "${item.title?.substring(0, 30)} ..."
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
                  child: ListView(
                    children: [
                      NoDataFoundWidget(
                        height: 80.h,
                        text: AppStrings.noProgramsFound,
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  bool checkIfChapterIsOpen(
    ChapterProvider chapterProvider,
    ProgramsProvider programsProvider,
    int index,
  ) {
    return chapterProvider.canAccessChapter(
      totalChapters: (chapterProvider.chaptersModel?.data?.length ?? 0),
      totalAllMarks:
          double.tryParse(
            programsProvider.userProgressModel?.data?.totalPossiblePoints
                    .toString() ??
                "",
          ) ??
          0,
      correctPoints:
          double.tryParse(
            programsProvider.userProgressModel?.data?.totalUserPoints
                    .toString() ??
                "",
          ) ??
          0,
      requestedChapter: index + 1,
    );
  }

  Future<void> goToPost(BuildContext context, ChaptersInfo item) {
    return push(
      context: context,
      widget: PostsScreen(
        chapterId: item.id ?? -1,
        chapterName: item.title ?? "",
      ),
      transition: FadeUpwardsPageTransitionsBuilder(),
    );
  }

  /// redirect to login page if not logged in
  void goToLoginPageWithWarning(BuildContext context) {
    push(
      context: context,
      widget: LoginScreen(isToNavigateHome: false),
      transition: OpenUpwardsPageTransitionsBuilder(),
    );
    WidgetHelper.customSnackBar(
      // context: context,
      title: AppStrings.pleaseLoginFirst,
      isError: true,
    );
  }
}

class CounselingContainer extends StatelessWidget {
  const CounselingContainer({
    super.key,
    required this.counselingCount,
    required this.isFirstOpen,
    required this.isSecondOpen,
  });

  final int counselingCount;
  final bool isFirstOpen;
  final bool isSecondOpen;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: CustomContainer(
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        padding: EdgeInsets.all(AppSize.size10),
        backGroundColor: AppColors.counselingBox,
        borderRadius: BorderRadius.circular(AppSize.size10),
        boxShadow: [
          BoxShadow(
            color: Color(0x000000).withOpacity(1),
            offset: Offset(0, 0),
            blurRadius: 15,
            spreadRadius: -9,
          ),
        ],
        width: 90.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: AppStrings.bookAnAppointment,
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
            if (counselingCount == 0) ...[
              CounselingOptions(
                description: AppStrings.bookAfter25,
                heading: AppStrings.counseling1,
                isOpen: isFirstOpen,
                isDone: counselingCount == 1,
              ),
              SizeHelper.height(),
            ],
            if (counselingCount == 1) ...[
              CounselingOptions(
                description: AppStrings.bookAfter75,
                heading: AppStrings.counseling2,
                isOpen: isSecondOpen,
                isDone: counselingCount == 1,
              ),
            ],
            if (counselingCount != 0 && counselingCount != 1)
              CustomContainer(
                backGroundColor: AppColors.white,
                boxShadow: ShadowHelper.scoreContainer,
                height: 4.h,
                borderRadius: BorderRadius.circular(AppSize.size10),
                alignment: Alignment.center,
                child: CustomText(
                  text: "All Counseling is Done",
                  style: TextStyleHelper.smallHeading,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CounselingOptions extends StatelessWidget with NavigateHelper {
  const CounselingOptions({
    super.key,
    required this.description,
    required this.heading,
    required this.isOpen,
    required this.isDone,
  });
  final String heading;
  final String description;
  final bool isOpen;
  final bool isDone;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:
          () =>
              isOpen
                  ? isDone
                      ? WidgetHelper.customSnackBar(
                        // context: context,
                        title: AppStrings.counselingAppointmentDone,
                        isError: true,
                      )
                      : push(
                        context: context,
                        widget: CousilingFormScreen(),
                        transition: ScaleFadePageTransitionsBuilder(),
                      )
                  : WidgetHelper.customSnackBar(
                    // context: context,
                    title: AppStrings.mileStoneNotAchieved,
                    isError: true,
                  ),
      child: CustomContainer(
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
              height: 4.h,
              child: Image.asset(AppImageStrings.arrowRight),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomProgressBar extends StatelessWidget {
  final double percentage;
  final double? height;
  final double? width;

  const CustomProgressBar({
    super.key,
    required this.percentage,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: AppStrings.yourAllOverProgress),
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CustomContainer(
                borderRadius: BorderRadius.circular(AppSize.size10),
                height: height ?? 1.h,
                width: width ?? 30.w,
                backGroundColor: AppColors.lightGrey,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: percentage / 100,
                        child: CustomContainer(
                          backGroundColor: AppColors.secondary,
                          borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(AppSize.size10),
                            left: Radius.circular(AppSize.size10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizeHelper.width(width: 2.w),
            CustomText(text: '${percentage.toInt()}%'),
          ],
        ),
      ],
    );
  }
}
