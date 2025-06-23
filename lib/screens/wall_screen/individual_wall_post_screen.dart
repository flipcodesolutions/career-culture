import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
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
import '../../utils/navigation_helper/navigation_helper.dart';
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

class _IndividualWallPostScreenState extends State<IndividualWallPostScreen>
    with NavigateHelper {
  @override
  void initState() {
    WallProvider wallProvider = context.read<WallProvider>();
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      if (!widget.isFromWallScreen) {
        await wallProvider.getWallPostBySlug(
          slug: widget.slug,
          context: context,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    WallProvider wallProvider = context.watch<WallProvider>();
    return wallProvider.isLoading
        ? Center(child: CustomLoader())
        : PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              pop(context, result: true);
            }
          },
          child: Scaffold(
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
                            widget.slug ??
                            wallProvider.slugWallPost?.slug ??
                            "",
                      ),
                ),
              ],
            ),
            body:
                wallProvider.slugWallPost != null
                    ? CustomRefreshIndicator(
                      onRefresh:
                          () async => wallProvider.getWallPostBySlug(
                            slug: widget.slug,
                            context: context,
                          ),
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: CustomText(
                                      text:
                                          wallProvider.slugWallPost?.title ??
                                          "",
                                      style: TextStyleHelper.mediumHeading,
                                      useOverflow: false,
                                    ),
                                  ),
                                  PostButton(
                                    onTap:
                                        () async => MethodHelper.likeWallPost(
                                          context: context,
                                          isLiked: true,
                                          wallProvider: wallProvider,
                                          postId:
                                              wallProvider.slugWallPost?.id ??
                                              -1,
                                          isFromWallScreen:
                                              widget.isFromWallScreen,
                                        ),
                                    icon:
                                        wallProvider
                                                    .slugWallPost
                                                    ?.isMyFavourite ==
                                                true
                                            ? Icons.thumb_up_alt
                                            : Icons.thumb_up_alt_outlined,
                                    label:
                                        "${wallProvider.slugWallPost?.likeCount ?? 0}",
                                  ),
                                ],
                              ),
                            ),

                            SizeHelper.height(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: Html(
                                data:
                                    wallProvider.slugWallPost?.description ??
                                    "Failed To Load Description !!",
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : Center(child: NoDataFoundWidget()),
          ),
        );
  }
}
