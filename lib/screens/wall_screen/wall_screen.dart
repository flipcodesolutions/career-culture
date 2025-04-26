import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/models/post_models/post_model.dart';
import 'package:mindful_youth/provider/wall_provider/wall_provider.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/custom_video_player.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../provider/home_screen_provider/home_screen_provider.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_image.dart';

class WallScreen extends StatefulWidget {
  const WallScreen({super.key});

  @override
  State<WallScreen> createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WallProvider wallProvider = context.read<WallProvider>();
    Future.microtask(() {
      wallProvider.getWall(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    WallProvider wallProvider = context.watch<WallProvider>();
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
            text: AppStrings.wall,
            style: TextStyleHelper.mediumHeading,
          ),
        ),
        body:
            wallProvider.isLoading
                ? Center(child: CustomLoader())
                : wallProvider.wallPost.isNotEmpty == true
                ? CustomRefreshIndicator(
                  onRefresh: () async => wallProvider.getWall(context: context),
                  child: ListView.builder(
                    itemCount: wallProvider.wallPost.length,
                    itemBuilder: (context, index) {
                      PostInfo? post = wallProvider.wallPost[index];
                      print(
                        "this is in all title => ${post.title ?? "Not Found"}",
                      );
                      return FeedPostCard(
                        post: post,
                        onLikePressed: () {
                          /* toggle like */
                        },
                        onSharePressed: () {
                          /* share sheet */
                        },
                        onMorePressed: () {
                          /* show menu */
                        },
                      );
                    },
                  ),
                )
                : CustomRefreshIndicator(
                  onRefresh: () async => wallProvider.getWall(context: context),
                  child: ListView(
                    children: [Center(child: NoDataFoundWidget())],
                  ),
                ),
      ),
    );
  }
}

class FeedPostCard extends StatelessWidget {
  final PostInfo? post;

  /// Callbacks
  final VoidCallback? onMorePressed;
  final VoidCallback? onLikePressed;
  final VoidCallback? onCommentPressed;
  final VoidCallback? onSharePressed;

  const FeedPostCard({
    super.key,
    required this.post,
    this.onMorePressed,
    this.onLikePressed,
    this.onCommentPressed,
    this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      borderColor: AppColors.lightPrimary,
      backGroundColor: AppColors.white,
      borderWidth: 0.3,
      boxShadow: ShadowHelper.scoreContainer,
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
      padding: EdgeInsets.all(AppSize.size10),
      borderRadius: BorderRadius.circular(AppSize.size10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── Header ─────────────────────────────
          // Row(
          //   children: [
          //     CircleAvatar(
          //       radius: 20,
          //       backgroundImage: NetworkImage(avatarUrl),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(userName),
          //           const SizedBox(height: 2),
          //           Text(timeAgo),
          //         ],
          //       ),
          //     ),
          //     IconButton(
          //       icon: const Icon(Icons.more_vert),
          //       onPressed: onMorePressed,
          //     ),
          //   ],
          // ),

          // ─── Body ───────────────────────────────
          CustomContainer(
            alignment: Alignment.center,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSize.size10),
              child:
                  post?.isForVideo == true
                      ? VideoPlayerWidget(
                        autoPlay: false,
                        showControls: true,
                        showOnlyPlay: true,
                        videoUrl: "${AppStrings.assetsUrl}${post?.video}",
                      )
                      : CustomImageWithLoader(
                        showImageInPanel: false,
                        fit: BoxFit.cover,
                        width: 85.w,
                        imageUrl: "${AppStrings.assetsUrl}${post?.image}",
                      ),
            ),
          ),

          // ─── Divider ────────────────────────────
          SizeHelper.height(),
          CustomText(text: post?.title ?? "not found", useOverflow: false),
          SizeHelper.height(),
          const Divider(height: 1),

          // ─── Footer ─────────────────────────────
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _PostButton(
                  icon: Icons.thumb_up_alt_outlined,
                  label: '100',
                  onTap: onLikePressed,
                ),
                _PostButton(
                  icon: Icons.share_outlined,
                  label: "",
                  onTap: onSharePressed,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _PostButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(4),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.iconTheme.color),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
}
