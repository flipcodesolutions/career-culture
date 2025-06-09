import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/assessment_provider/assessment_provider.dart';
import 'package:mindful_youth/provider/programs_provider/post_provider/post_provider.dart';
import 'package:mindful_youth/provider/recent_activity_provider/recent_activity_provider.dart';
import 'package:mindful_youth/screens/programs_screen/individual_program_screen.dart';
import 'package:mindful_youth/screens/programs_screen/widgets/assessment_screen.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/utils/user_screen_time/tracking_mixin.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:mindful_youth/widgets/youtube_player.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
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
  });
  final int chapterId;
  final String chapterName;
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
    RecentActivityProvider recentActivityProvider =
        context.watch<RecentActivityProvider>();
    return Scaffold(
      appBar: AppBar(
        /// if only one post
        title: CustomText(
          text: postProvider.currentPost?.title ?? widget.chapterName,
          style: TextStyleHelper.mediumHeading,
        ),
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
                      PostInfo? post = postProvider.postListModel?.data?[index];
                      return GestureDetector(
                        onTap: () async {
                          postProvider.setPostInfo = post;
                          await recentActivityProvider.saveRecentActivity(post);
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
                                        textStyle: TextStyleHelper.smallHeading,
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
              : ListView(
                children: [
                  NoDataFoundWidget(
                    height: 80.h,
                    text: AppStrings.noPostsFound,
                  ),
                ],
              ),
      bottomNavigationBar:
          postProvider.currentPost != null
              ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: PrimaryBtn(
                  width: 90.w,
                  btnText:
                      "${AppStrings.takeATest} (Earn ${postProvider.currentPost?.points ?? 0} Coins)",
                  onTap: () {
                    context.read<AssessmentProvider>().setPostId =
                        postProvider.currentPost?.id?.toString() ?? "";
                    postProvider.currentPost?.isAssessmentDone != true
                        ? push(
                          context: context,
                          widget: AssessmentScreen(
                            postName:
                                "${postProvider.currentPost?.title}_${postProvider.currentPost?.id}",
                          ),
                          transition: FadeUpwardsPageTransitionsBuilder(),
                        )
                        : postProvider.currentPost
                            ?.handleWhatToShowIfAssessmentHasSubmittedAlready();
                  },
                ),
              )
              : null,
      // floatingActionButton:
      //     postProvider.currentPost != null
      //         ? FloatingActionButton(
      //           onPressed: () {},
      //           backgroundColor: AppColors.black,
      //           child: AppIcons.add(color: AppColors.white),
      //         )
      //         : null,
    );
  }
}

class SinglePostWIdget extends StatelessWidget with NavigateHelper {
  const SinglePostWIdget({super.key, required this.post});

  final PostInfo? post;

  @override
  Widget build(BuildContext context) {
    if (post == null) return Center(child: NoDataFoundWidget());

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
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: ImageContainer(
                showImageInPanel: true,
                image: "${AppStrings.assetsUrl}${post?.image}",
              ),
            ),
            SizeHelper.height(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Html(data: post?.description ?? ""),
            ),
            SizeHelper.height(),
            if (post?.video?.isNotEmpty == true) ...[
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
                      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
                      description: post?.description,
                    ),
                  ),
                ),
              ),
              SizeHelper.height(),
            ],
            if (post?.audio?.isNotEmpty == true) ...[
              HeadingTextWidget(heading: AppStrings.mustListen),
              SizeHelper.height(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: CustomAudioPlayer(
                  audioUrl: "${AppStrings.assetsUrl}${post?.audio}",
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
                  post?.media?.where((e) => e.type == 'video').toList() ??
                  <Media>[],
              itemBuilder:
                  (item, index) => GestureDetector(
                    onTap:
                        () async =>
                            launchUrl(url: item.url ?? "", context: context),
                    child: CustomContainer(
                      backGroundColor: AppColors.lightWhite,
                      margin: EdgeInsets.only(right: 5.w),
                      borderRadius: BorderRadius.circular(AppSize.size10),
                      child: ImageContainer(
                        image: "${AppStrings.assetsUrl}${item.thumbnail}",
                        showImageInPanel: false,
                      ),
                    ),
                  ),
            ),

            MediaRender(
              heading: AppStrings.articles,
              data:
                  post?.media?.where((e) => e.type == 'article').toList() ?? [],
              itemBuilder:
                  (item, index) => GestureDetector(
                    onTap:
                        () async =>
                            launchUrl(url: item.url ?? "", context: context),
                    child: CustomContainer(
                      backGroundColor: AppColors.lightWhite,
                      margin: EdgeInsets.only(right: 5.w),
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
              data: post?.media?.where((e) => e.type == 'audio').toList() ?? [],
              itemBuilder:
                  (item, index) => GestureDetector(
                    onTap:
                        () async =>
                            launchUrl(url: item.url ?? "", context: context),
                    child: CustomContainer(
                      backGroundColor: AppColors.lightWhite,
                      margin: EdgeInsets.only(right: 5.w),
                      borderRadius: BorderRadius.circular(AppSize.size10),
                      child: ImageContainer(
                        image: "${AppStrings.assetsUrl}${item.thumbnail}",
                        showImageInPanel: false,
                      ),
                    ),
                  ),
            ),

            MediaRender(
              heading: AppStrings.recommendedBooks,
              data: post?.media?.where((e) => e.type == 'book').toList() ?? [],
              itemBuilder:
                  (item, index) => GestureDetector(
                    onTap:
                        () async =>
                            launchUrl(url: item.url ?? "", context: context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppSize.size10),
                      child: CustomContainer(
                        backGroundColor: AppColors.lightWhite,
                        margin: EdgeInsets.only(right: 5.w),
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
