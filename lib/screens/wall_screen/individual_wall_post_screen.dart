import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../provider/wall_provider/wall_provider.dart';
import '../../utils/method_helpers/method_helper.dart';
import 'wall_screen.dart';

class IndividualWallPostScreen extends StatefulWidget {
  final String? slug;
  final bool isFromWallScreen;
  const IndividualWallPostScreen({
    super.key,
    this.slug,
    required this.isFromWallScreen,
  });

  @override
  State<IndividualWallPostScreen> createState() =>
      _IndividualWallPostScreenState();
}

class _IndividualWallPostScreenState extends State<IndividualWallPostScreen> {
  @override
  void initState() {
    WallProvider wallProvider = context.read<WallProvider>();
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      if (!widget.isFromWallScreen) {
        await wallProvider.getWallPostBySlug(slug: widget.slug,context: context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WallProvider wallProvider = context.watch<WallProvider>();
    return wallProvider.isLoading
        ? Center(child: CustomLoader())
        : Scaffold(
          appBar: AppBar(
            title: CustomText(
              text: wallProvider.slugWallPost?.title ?? widget.slug ?? "",
              style: TextStyleHelper.mediumHeading,
            ),
            actions: [
              PostButton(
                icon: Icons.share_outlined,
                label: "",
                iconColor: AppColors.primary,
                onTap:
                    () async => MethodHelper.shareWallPost(
                      slug:
                          widget.slug ?? wallProvider.slugWallPost?.slug ?? "",
                    ),
              ),
            ],
          ),
          body:
              wallProvider.slugWallPost != null
                  ? CustomRefreshIndicator(
                    onRefresh:
                        () async =>
                            wallProvider.getWallPostBySlug(slug: widget.slug,context: context),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 16 / 9,
                            child: CustomImageWithLoader(
                              imageUrl:
                                  "${AppStrings.assetsUrl}${wallProvider.slugWallPost?.image ?? ""}",
                            ),
                          ),
                          SizeHelper.height(),
                          Padding(
                            padding: EdgeInsets.only(left: 5.w),
                            child: CustomText(
                              text: wallProvider.slugWallPost?.title ?? "",
                              style: TextStyleHelper.mediumHeading,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 2.w),
                            child: PostButton(
                              onTap:
                                  () async => MethodHelper.likeWallPost(
                                    context: context,
                                    isLiked: true,
                                    wallProvider: wallProvider,
                                    postId: wallProvider.slugWallPost?.id ?? -1,
                                    isFromWallScreen: widget.isFromWallScreen
                                  ),
                              icon:
                                  wallProvider.slugWallPost?.isMyFavourite ==
                                          true
                                      ? Icons.thumb_up_alt
                                      : Icons.thumb_up_alt_outlined,
                              label:
                                  "${wallProvider.slugWallPost?.likeCount ?? 0}",
                            ),
                            // CustomText(
                            //   text:
                            //       "${wallProvider.slugWallPost?.likeCount.toString()} Like",
                            //   style: TextStyleHelper.smallText,
                            // ),
                          ),
                          SizeHelper.height(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.w),
                            child: CustomText(
                              text:
                                  wallProvider.slugWallPost?.description ??
                                  "Failed To Load Description !!",
                              style: TextStyleHelper.smallText,
                              useOverflow: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  : Center(child: NoDataFoundWidget()),
        );
  }
}
