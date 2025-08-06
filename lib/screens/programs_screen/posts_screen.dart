import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/assessment_provider/assessment_provider.dart';
import 'package:mindful_youth/provider/programs_provider/chapter_provider/chapter_provider.dart';
import 'package:mindful_youth/provider/programs_provider/post_provider/post_provider.dart';
import 'package:mindful_youth/provider/programs_provider/programs_provider.dart';
import 'package:mindful_youth/provider/recent_activity_provider/recent_activity_provider.dart';
import 'package:mindful_youth/screens/programs_screen/individual_program_screen.dart';
import 'package:mindful_youth/screens/programs_screen/widgets/assessment_screen.dart';
import 'package:mindful_youth/screens/programs_screen/widgets/gallery_page.dart';
import 'package:mindful_youth/screens/programs_screen/widgets/media_assessment_screen.dart';
import 'package:mindful_youth/screens/selfie_zone_screens/info_selfie_web_view.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/utils/user_screen_time/tracking_mixin.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:mindful_youth/widgets/youtube_player.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../app_const/app_strings.dart';
import '../../models/post_models/post_model.dart';
import '../../utils/widget_helper/widget_helper.dart';
import '../../widgets/custom_audio_player.dart';
import '../../widgets/custom_score_with_animation.dart';
import 'widgets/render_media_data.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({
    super.key,
    required this.chapterId,
    required this.chapterName,
    this.isFromGridView = false,
  });
  final int chapterId;
  final String chapterName;
  final bool isFromGridView;
  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen>
    with NavigateHelper, WidgetsBindingObserver, ScreenTracker<PostsScreen> {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  String get screenName => widget.chapterName;
  @override
  bool get debug => false; // Enable debug logs
  @override
  void initState() {
    PostProvider postProvider = context.read<PostProvider>();
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      postProvider.getPostById(
        context: context,
        id: widget.chapterId.toString(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = context.watch<PostProvider>();
    ProgramsProvider programsProvider = context.watch<ProgramsProvider>();
    RecentActivityProvider recentActivityProvider =
        context.watch<RecentActivityProvider>();
    final List<String> imageMedia =
        postProvider.currentPost?.media
            ?.where((e) => e.type == "image" && e.thumbnail?.isNotEmpty == true)
            .toList()
            .map((r) => r.thumbnail ?? "")
            .toList() ??
        [];

    /// used for the title showing in bottom sheet
    final post = postProvider.currentPost;

    final statusText =
        (post?.isFirstAssessmentDone == true &&
                post?.isSecondAssessmentDone == true)
            ? "All Test Completed. Bravo"
            : (post?.isFirstAssessmentDone == true &&
                post?.isSecondAssessmentDone != true)
            ? AppStrings.finishMediaAssessment
            : "${AppStrings.takeATest} (Earn ${post?.points ?? 0} Coins)";
    return PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        /// get refreshed current user progress
        await programsProvider.getUserProgress(
          context: context,
          pId: programsProvider.currentProgramInfo?.id.toString() ?? "",
        );
        if (!context.mounted) return;
        if (!widget.isFromGridView) {
          await context.read<ChapterProvider>().getChapterById(
            context: context,
            id: (programsProvider.currentProgramInfo?.id ?? 0).toString(),
          );
        } else {
          await context.read<ChapterProvider>().getAllChapters(
            context: context,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          /// if only one post
          title: CustomText(
            text: postProvider.currentPost?.title ?? widget.chapterName,
            style: TextStyleHelper.mediumHeading,
          ),
          actions: [
            /// only load gallery if media have any gallery media to show
            if (imageMedia.isNotEmpty)
              IconButton(
                onPressed:
                    () => push(
                      context: context,
                      widget: GalleryPage(imagesStrings: imageMedia),
                      transition: FadeForwardsPageTransitionsBuilder(),
                    ),
                icon: Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.primary,
                ),
              ),
          ],
        ),
        body:
            postProvider.isLoading
                ? Center(child: CustomLoader())
                : postProvider.postListModel?.data?.isNotEmpty == true
                ? postProvider.currentPost != null
                    ? SinglePostWIdget(post: postProvider.currentPost)
                    : ListView.builder(
                      shrinkWrap: true,
                      itemCount: postProvider.postListModel?.data?.length,
                      itemBuilder: (context, index) {
                        PostInfo? post =
                            postProvider.postListModel?.data?[index];
                        return GestureDetector(
                          onTap: () async {
                            postProvider.setPostInfo = post;
                            await recentActivityProvider.saveRecentActivity(
                              post,
                            );
                          },
                          child: CustomContainer(
                            margin: EdgeInsets.symmetric(
                              vertical: 0.5.h,
                              horizontal: 5.w,
                            ),
                            borderRadius: BorderRadius.circular(AppSize.size10),
                            backGroundColor: AppColors.lightWhite,
                            boxShadow: ShadowHelper.scoreContainer,
                            child: CustomContainer(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      CustomContainer(
                                        alignment: Alignment.topRight,
                                        child: CustomAnimatedScore(
                                          score: "${post?.points}",
                                          lastText: "Points",
                                          textStyle:
                                              TextStyleHelper.smallHeading,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ImageContainer(
                                    image:
                                        "${AppStrings.assetsUrl}${post?.image}",
                                    showImageInPanel: false,
                                  ),
                                  CustomContainer(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 9,
                                          child: CustomText(
                                            text: post?.title ?? "",
                                            useOverflow: false,
                                          ),
                                        ),
                                        Expanded(
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            color: AppColors.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                : CustomRefreshIndicator(
                  onRefresh:
                      () async => postProvider.getPostById(
                        context: context,
                        id: widget.chapterId.toString(),
                      ),
                  child: ListView(
                    children: [
                      NoDataFoundWidget(
                        height: 80.h,
                        text: AppStrings.noPostsFound,
                      ),
                    ],
                  ),
                ),

        bottomNavigationBar: SafeArea(
          child:
              postProvider.currentPost != null
                  ? CustomContainer(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 2.h,
                    ),
                    child: PrimaryBtn(
                      width: 90.w,
                      btnText: statusText,

                      onTap: () async {
                        context.read<AssessmentProvider>().setPostId =
                            postProvider.currentPost?.id?.toString() ?? "";
                        bool isFirstDone =
                            postProvider.currentPost?.isFirstAssessmentDone ==
                            true;
                        bool isSecondDone =
                            postProvider.currentPost?.isSecondAssessmentDone ==
                            true;

                        if (!isFirstDone && !isSecondDone) {
                          // Case 1: Neither assessment is done
                          bool success = await push(
                            context: context,
                            widget: AssessmentScreen(
                              isInReviewMode: false,
                              postName:
                                  "${postProvider.currentPost?.title}_${postProvider.currentPost?.id}",
                            ),
                            transition: FadeUpwardsPageTransitionsBuilder(),
                          );
                          if (success == true) {
                            //// if completed successfully , get fresh data
                            await postProvider.getPostById(
                              context: context,
                              id: widget.chapterId.toString(),
                            );
                          }
                        } else if (isFirstDone && !isSecondDone) {
                          // Case 2: First done, second not done
                          bool success = await push(
                            context: context,
                            widget: MediaAssessmentScreen(shouldPop3: false),
                            transition: FadeUpwardsPageTransitionsBuilder(),
                          );
                          if (success == true) {
                            //// if completed successfully , get fresh data
                            await postProvider.getPostById(
                              context: context,
                              id: widget.chapterId.toString(),
                            );
                          }
                        } else if (isFirstDone && isSecondDone) {
                          // Case 3: Both assessments are done
                          WidgetHelper.customSnackBar(
                            title: AppStrings.yourAssessmentIsDoneAlready,
                          );
                        } else {
                          // Fallback: Unexpected state
                          WidgetHelper.customSnackBar(
                            title:
                                "Unexpected state: First Assessment = $isFirstDone, Second Assessment = $isSecondDone",
                            isError: true,
                          );
                        }
                      },
                    ),
                  )
                  : SizedBox.shrink(),
        ),
      ),
    );
  }
}

class SinglePostWIdget extends StatefulWidget {
  const SinglePostWIdget({super.key, required this.post});

  final PostInfo? post;

  @override
  State<SinglePostWIdget> createState() => _SinglePostWIdgetState();
}

class _SinglePostWIdgetState extends State<SinglePostWIdget>
    with NavigateHelper {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      await context.read<RecentActivityProvider>().saveRecentActivity(
        context.read<PostProvider>().currentPost,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = context.watch<PostProvider>();
    if (widget.post == null) return Center(child: NoDataFoundWidget());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        PostProvider postProvider = context.read<PostProvider>();
        if (!didPop) {
          postProvider.setPostInfo = null;
          if (postProvider.postListModel?.data?.length == 1) {
            pop(context);
          }
        }
      },
      child: CustomRefreshIndicator(
        onRefresh:
            () async => postProvider.getPostById(
              context: context,
              id: widget.post?.chapterId.toString() ?? "",
            ),
        child: SingleChildScrollView(
          // padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageContainer(
                showImageInPanel: true,
                image: "${AppStrings.assetsUrl}${widget.post?.image}",
              ),
              SizeHelper.height(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Html(data: widget.post?.description ?? ""),
              ),
              SizeHelper.height(),
              if (widget.post?.video?.isNotEmpty == true &&
                  YoutubePlayer.convertUrlToId(
                        postProvider.currentPost?.video ?? "",
                      )?.isNotEmpty ==
                      true) ...[
                HeadingTextWidget(heading: AppStrings.mustWatch),
                SizeHelper.height(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: CustomContainer(
                      backGroundColor: AppColors.lightWhite,
                      boxShadow: ShadowHelper.scoreContainer,
                      child: VideoPreviewScreen(
                        videoUrl: postProvider.currentPost?.video ?? "",
                        description: widget.post?.description,
                      ),
                    ),
                  ),
                ),
                SizeHelper.height(),
              ],
              if (widget.post?.audio?.isNotEmpty == true) ...[
                HeadingTextWidget(heading: AppStrings.mustListen),
                SizeHelper.height(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: CustomAudioPlayer(
                    audioUrl: "${AppStrings.assetsUrl}${widget.post?.audio}",
                  ),
                ),
                SizeHelper.height(),
              ],
              // CustomContainer(
              //   padding: EdgeInsets.symmetric(horizontal: 5.w),
              //   child: ,
              // ),
              SizeHelper.height(),
              MediaRender(
                heading: AppStrings.video,
                data:
                    widget.post?.media
                        ?.where((e) => e.type == 'video')
                        .toList() ??
                    <Media>[],
                itemBuilder:
                    (context, item, index) => GestureDetector(
                      onTap:
                          () => push(
                            context: context,
                            widget: InfoSelfieWebView(webLink: item.url),
                            transition: OpenUpwardsPageTransitionsBuilder(),
                          ),
                      // () async =>
                      //     launchUrl(url: item.url ?? "", context: context),
                      child: CustomContainer(
                        backGroundColor: AppColors.lightWhite,
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        borderRadius: BorderRadius.circular(AppSize.size10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppSize.size10),
                          child: ImageContainer(
                            image: "${AppStrings.assetsUrl}${item.thumbnail}",
                            showImageInPanel: false,
                          ),
                        ),
                      ),
                    ),
              ),

              MediaRender(
                heading: AppStrings.articles,
                data:
                    widget.post?.media
                        ?.where((e) => e.type == 'article')
                        .toList() ??
                    [],
                itemBuilder:
                    (context, item, index) => GestureDetector(
                      onTap:
                          () async => launchUrl(
                            url: "${AppStrings.pdfArticleUrl}${item.url}",
                            context: context,
                          ),
                      child: CustomContainer(
                        backGroundColor: AppColors.lightWhite,
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        borderRadius: BorderRadius.circular(AppSize.size10),
                        child: ImageContainer(
                          image: "${AppStrings.assetsUrl}${item.thumbnail}",
                          showImageInPanel: false,
                        ),
                      ),
                    ),
              ),

              MediaRender(
                heading: AppStrings.audio,
                data:
                    widget.post?.media
                        ?.where((e) => e.type == 'audio')
                        .toList() ??
                    [],
                itemBuilder:
                    (context, item, index) => GestureDetector(
                      onTap:
                          () async =>
                              launchUrl(url: item.url ?? "", context: context),
                      child: CustomContainer(
                        backGroundColor: AppColors.lightWhite,
                        margin: EdgeInsets.symmetric(horizontal: 5.w),
                        borderRadius: BorderRadius.circular(AppSize.size10),
                        child: ImageContainer(
                          image: "${AppStrings.assetsUrl}${item.thumbnail}",
                          showImageInPanel: false,
                        ),
                      ),
                    ),
              ),

              MediaRender(
                isList: false,
                isNotScroll: true,
                heading: AppStrings.recommendedBooks,
                data:
                    widget.post?.media
                        ?.where((e) => e.type == 'book')
                        .toList() ??
                    [],
                itemBuilder:
                    (context, item, index) => GestureDetector(
                      onTap:
                          () async =>
                              launchUrl(url: item.url ?? "", context: context),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.size10),
                        child: CustomContainer(
                          backGroundColor: AppColors.lightWhite,
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                          borderRadius: BorderRadius.circular(AppSize.size10),
                          child: ImageContainer(
                            image: "${AppStrings.assetsUrl}${item.thumbnail}",
                            showImageInPanel: false,
                          ),
                        ),
                      ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HeadingTextWidget extends StatelessWidget {
  const HeadingTextWidget({super.key, required this.heading});
  final String heading;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 100.w,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      backGroundColor: AppColors.lightWhite,
      child: CustomText(
        text: heading,
        style: TextStyleHelper.smallHeading.copyWith(color: AppColors.primary),
      ),
    );
  }
}

Future<void> launchUrl({
  required String url,
  required BuildContext context,
}) async {
  bool success = await MethodHelper.launchUrlInBrowser(url: url);
  if (!success) {
    print("failed");
    if (!context.mounted) return;
    WidgetHelper.customSnackBar(
      autoClose: false,
      title: "Could Not Launch This Url",
      isError: true,
    );
  }
}
