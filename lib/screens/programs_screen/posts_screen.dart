import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/programs_provider/post_provider/post_provider.dart';
import 'package:mindful_youth/screens/programs_screen/individual_program_screen.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/custom_video_player.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';
import '../../models/post_models/post_model.dart';
import '../../widgets/custom_audio_player.dart';

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

class _PostsScreenState extends State<PostsScreen> with NavigateHelper {
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
    return Scaffold(
      appBar: AppBar(
        /// if only one post
        title: CustomText(
          text: postProvider.currentPost?.title ?? widget.chapterName,
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
                        onTap: () => postProvider.setPostInfo = post,
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
                                ImageContainer(
                                  image:
                                      "${AppStrings.assetsUrl}${post?.image}",
                                ),
                                CustomContainer(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                  ),
                                  child: CustomText(text: post?.title ?? ""),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
              : ListView(children: [NoDataFoundWidget(height: 80.h)]),
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
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: Column(
          children: [
            ImageContainer(image: "${AppStrings.assetsUrl}${post?.image}"),
            SizeHelper.height(),
            CustomText(
              text: post?.description ?? "",
              useOverflow: false,
              textAlign: TextAlign.justify,
            ),
            SizeHelper.height(),
            if (post?.video?.isNotEmpty == true)
              CustomContainer(
                boxShadow: ShadowHelper.scoreContainer,
                child: VideoPlayerWidget(
                  height: 30.h,
                  width: 90.w,
                  showControls: true,
                  videoUrl:
                      "https://videos.pexels.com/video-files/5532762/5532762-uhd_2732_1440_25fps.mp4",
                ),
              ),
            SizeHelper.height(),
            if (post?.audio?.isNotEmpty == true)
              CustomAudioPlayer(
                audioUrl:
                    "https://cdn.s3waas.gov.in/master/uploads/2017/11/2017111337.mp3",
              ),
          ],
        ),
      ),
    );
  }
}
