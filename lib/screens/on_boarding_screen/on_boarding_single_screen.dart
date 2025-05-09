import 'package:flutter/material.dart';
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
  @override
  void initState() {
    super.initState();
    // Play Audio if available
    if (widget.onBoardingInfo.audioUrl != null &&
        widget.onBoardingInfo.audioUrl!.isNotEmpty) {
      audioPlayer
          .setUrl("${AppStrings.assetsUrl}${widget.onBoardingInfo.audioUrl!}")
          .then((_) {
            audioPlayer.play();
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (widget.onBoardingInfo.videoUrl != null &&
              widget.onBoardingInfo.videoUrl?.isNotEmpty == true)
            CustomContainer(
              width: 90.w,
              height: 25.h,
              child: VideoPlayerWidget(
                videoUrl:
                    "${AppStrings.assetsUrl}${widget.onBoardingInfo.videoUrl}",
              ),
            ),
          if (widget.onBoardingInfo.image != null &&
              widget.onBoardingInfo.image?.isNotEmpty == true)
            CustomContainer(
              // backGroundColor: AppColors.error,
              width: 90.w,
              height: 25.h,
              child: CustomImageWithLoader(
                fit: BoxFit.contain,
                imageUrl:
                    "${AppStrings.assetsUrl}${widget.onBoardingInfo.image}",
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
          CustomText(
            text: widget.onBoardingInfo.description ?? "",
            style: TextStyleHelper.mediumText,
            useOverflow: false,
          ),
        ],
      ),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
