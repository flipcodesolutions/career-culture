import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/utils/method_helpers/gradient_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'custom_text.dart';
import 'cutom_loader.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    this.height,
    this.width,
    this.showControls = false,
  });

  final String videoUrl;
  final double? width;
  final double? height;
  final bool showControls;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _showOverlay = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.addListener(() {
      if (mounted && !_isDragging) setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration position) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(position.inMinutes.remainder(60));
    final seconds = twoDigits(position.inSeconds.remainder(60));
    return "${position.inHours > 0 ? '${twoDigits(position.inHours)}:' : ''}$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final videoReady = _controller.value.isInitialized;

    return GestureDetector(
      onTap:
          widget.showControls
              ? () => setState(() => _showOverlay = !_showOverlay)
              : null,
      child: CustomContainer(
        width: widget.width ?? 100.w,
        height: widget.height ?? 40.h,
        child:
            videoReady
                ? Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    VideoPlayer(_controller),

                    // Controls overlay
                    if (widget.showControls && _showOverlay)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: CustomContainer(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2.w,
                            vertical: 1.h,
                          ),
                          gradient: GradientHelper.videoPlayer,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                padding: EdgeInsets.only(bottom: 6),
                                colors: VideoProgressColors(
                                  playedColor: AppColors.error,
                                  bufferedColor: AppColors.secondary,
                                  backgroundColor: AppColors.white.withOpacity(
                                    0.2,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      _controller.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _controller.value.isPlaying
                                            ? _controller.pause()
                                            : _controller.play();
                                      });
                                    },
                                  ),
                                  SizeHelper.width(),
                                  CustomText(
                                    text:
                                        "${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}",
                                    style: TextStyleHelper.smallText.copyWith(
                                      color: AppColors.white,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.fullscreen,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      // Optional: add fullscreen navigation here
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                )
                : const Center(child: CustomLoader()),
      ),
    );
  }
}
