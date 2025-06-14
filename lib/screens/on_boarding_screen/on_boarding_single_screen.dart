import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../models/on_boarding_model/on_borading_model.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_video_player.dart';

class OnBoardingSinglePage extends StatefulWidget {
  const OnBoardingSinglePage({super.key, required this.onBoardingInfo});
  final OnBoardingInfo onBoardingInfo;
  @override
  State<OnBoardingSinglePage> createState() => _OnBoardingSinglePageState();
}

class _OnBoardingSinglePageState extends State<OnBoardingSinglePage> {
  final AudioPlayer audioPlayer = AudioPlayer();
  String imageLink = "";
  String audioLink = "";
  String videoLink = "";
  @override
  void initState() {
    super.initState();
    imageLink = widget.onBoardingInfo.image ?? "";
    audioLink = widget.onBoardingInfo.audioUrl ?? "";
    videoLink = widget.onBoardingInfo.videoUrl ?? "";
    // Play Audio if available
    if (audioLink.isNotEmpty && videoLink.isEmpty == true) {
      audioPlayer
          .setUrl("${AppStrings.assetsUrl}${widget.onBoardingInfo.audioUrl!}")
          .then((_) {
            audioPlayer.play();
          });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("${AppStrings.assetsUrl}$videoLink");
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (videoLink.isNotEmpty && imageLink.isEmpty)
            CustomContainer(
              child: VideoPlayerWidget(
                videoUrl: "${AppStrings.assetsUrl}$videoLink",
              ),
            ),
          if (imageLink.isNotEmpty)
            CustomContainer(
              // backGroundColor: AppColors.error,
              width: 90.w,
              height: 25.h,
              child: CustomImageWithLoader(
                fit: BoxFit.contain,
                imageUrl: "${AppStrings.assetsUrl}$imageLink",
              ),
            ),
          SizeHelper.height(height: 10.h),
          CustomText(
            text: widget.onBoardingInfo.title ?? "",
            useOverflow: false,
            style: TextStyleHelper.largeHeading.copyWith(
              color: AppColors.primary,
            ),
          ),
          SizeHelper.height(),
          Html(data: widget.onBoardingInfo.description ?? ""),
        ],
      ),
    );
  }
}
