import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/provider/wall_provider/wall_provider.dart';
import 'package:mindful_youth/screens/wall_screen/individual_wall_post_screen.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../models/post_models/wall_model.dart';
import '../../provider/home_screen_provider/home_screen_provider.dart';
import '../../utils/method_helpers/method_helper.dart';
import '../../utils/user_screen_time/tracking_mixin.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_image.dart';

class WallScreen extends StatefulWidget {
  const WallScreen({super.key});

  @override
  State<WallScreen> createState() => _WallScreenState();
}

class _WallScreenState extends State<WallScreen>
    with WidgetsBindingObserver, ScreenTracker<WallScreen>, NavigateHelper {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  String get screenName => 'WallScreen';
  @override
  bool get debug => false; // Enable debug logs
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
    UserProvider userProvider = context.watch<UserProvider>();
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
                : wallProvider.wallModel?.data?.isNotEmpty == true
                ? CustomRefreshIndicator(
                  onRefresh: () async => wallProvider.getWall(context: context),
                  child: ListView.builder(
                    itemCount: wallProvider.wallModel?.data?.length ?? 0,
                    itemBuilder: (context, index) {
                      WallListModelData? post =
                          wallProvider.wallModel?.data?[index];
                      return FeedPostCard(
                        onTap: () {
                          wallProvider.initWallPostSlugFromWallScreen(
                            post: post,
                          );
                          push(
                            context: context,
                            widget: IndividualWallPostScreen(
                              isFromWallScreen: true,
                            ),
                            transition: FadeUpwardsPageTransitionsBuilder(),
                          );
                        },
                        post: post,
                        onLikePressed:
                            () async => MethodHelper.likeWallPost(
                              isLiked: userProvider.isUserLoggedIn,
                              wallProvider: wallProvider,
                              postId: post?.id ?? -1,
                              isFromWallScreen: true,
                              context: context,
                            ),
                        onSharePressed:
                            () async => MethodHelper.shareWallPost(
                              slug: post?.slug ?? "",
                            ),
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
                    children: [
                      Center(
                        child: NoDataFoundWidget(text: AppStrings.noPostsFound),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }
}

class FeedPostCard extends StatelessWidget {
  final WallListModelData? post;

  /// Callbacks
  final VoidCallback? onMorePressed;
  final VoidCallback? onLikePressed;
  final VoidCallback? onCommentPressed;
  final VoidCallback? onSharePressed;
  final void Function()? onTap;
  const FeedPostCard({
    super.key,
    required this.post,
    this.onMorePressed,
    this.onLikePressed,
    this.onCommentPressed,
    this.onSharePressed,
    required this.onTap,
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
          InkWell(
            onTap: onTap,
            child: CustomContainer(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.size10),
                child: CustomImageWithLoader(
                  showImageInPanel: false,
                  fit: BoxFit.cover,
                  width: 85.w,
                  skeletonHeight: 20.h,
                  imageUrl: "${AppStrings.assetsUrl}${post?.image}",
                ),
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
                PostButton(
                  icon:
                      post?.isMyFavourite == true
                          ? Icons.thumb_up_alt
                          : Icons.thumb_up_alt_outlined,
                  label: "${post?.likeCount ?? 0}",
                  onTap: onLikePressed,
                ),
                PostButton(
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

class PostButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? iconColor;
  const PostButton({
    super.key,
    required this.icon,
    required this.label,
    this.iconColor,
    this.onTap,
  });

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
            Icon(icon, size: 20, color: iconColor ?? theme.iconTheme.color),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ),
    );
  }
}
