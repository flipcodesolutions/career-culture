import 'dart:nativewrappers/_internal/vm/lib/developer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/models/post_models/post_model.dart';
import 'package:mindful_youth/provider/wall_provider/wall_provider.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/custom_video_player.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
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
    return Scaffold(
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
              ? MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: wallProvider.wallPost.length,
                itemBuilder: (context, index) {
                  PostInfo? post = wallProvider.wallPost[index];
                  return CustomContainer(
                    borderRadius: BorderRadius.circular(AppSize.size10),
                    child:
                        post.isUseVideoOrImageForWall == true
                            ? VideoPlayerWidget(
                              videoUrl: "${AppStrings.assetsUrl}${post.video}",
                            )
                            : CustomImageWithLoader(
                              fit: BoxFit.fitHeight,
                              showImageInPanel: false,
                              imageUrl: "${AppStrings.assetsUrl}${post.image}",
                            ),
                  );
                },
              )
              : Center(child: NoDataFoundWidget()),
    );
  }
}
