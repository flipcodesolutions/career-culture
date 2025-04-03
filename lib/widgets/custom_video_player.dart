import 'package:flutter/material.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import '../app_const/app_strings.dart';
import 'cutom_loader.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key, required this.videoUrl});
  final String videoUrl;
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? videoController;
  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.networkUrl(
        Uri.parse("${AppStrings.assetsUrl}${widget.videoUrl}"),
      )
      ..initialize().then((_) {
        setState(() {}); // Update UI once video is ready
        videoController?.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 80.w,
      height: 40.h,
      child:
          videoController != null &&
                  videoController?.value.isInitialized == true
              ? VideoPlayer(videoController!)
              : Center(child: CustomLoader()),
    );
  }

  @override
  void dispose() {
    super.dispose();
    videoController?.dispose();
  }
}
