import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/utils/method_helpers/gradient_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/transitions/fade_slide_from_belove.dart';
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
    this.autoPlay = true,
    this.showOnlyPlay = false,
  });

  final String videoUrl;
  final double? width;
  final double? height;
  final bool showControls;
  final bool autoPlay;
  final bool showOnlyPlay;
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget>
    with NavigateHelper {
  late VideoPlayerController _controller;
  bool _showOverlay = false;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
        if (widget.autoPlay) _controller.play();
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
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
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
                                padding: const EdgeInsets.only(bottom: 6),
                                colors: VideoProgressColors(
                                  playedColor: AppColors.error,
                                  bufferedColor: AppColors.secondary,
                                  backgroundColor: AppColors.white.withOpacity(
                                    0.2,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    iconSize: 10,
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
                                  if (!widget.showOnlyPlay) ...[
                                    SizeHelper.width(),
                                    CustomText(
                                      text:
                                          "${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}",
                                      style: TextStyleHelper.smallText.copyWith(
                                        color: AppColors.white,
                                      ),
                                    ),
                                    const Spacer(),
                                    // ← FULLSCREEN BUTTON NOW NAVIGATES
                                    IconButton(
                                      icon: const Icon(
                                        Icons.fullscreen,
                                        color: Colors.white,
                                      ),
                                      onPressed:
                                          () => push(
                                            context: context,
                                            widget: FullScreenVideoPage(
                                              controller: _controller,
                                              showOnlyPlay: widget.showOnlyPlay,
                                              showControls: widget.showControls,
                                            ),
                                            transition:
                                                FadeSlidePageTransitionsBuilder(),
                                          ),
                                    ),
                                  ],
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

/// ——————————————————————————————————————————
/// Full-Screen “Immersive” Video Page
/// ——————————————————————————————————————————
class FullScreenVideoPage extends StatefulWidget {
  final VideoPlayerController controller;
  final bool showControls;
  final bool showOnlyPlay;
  const FullScreenVideoPage({
    super.key,
    required this.controller,
    required this.showControls,
    required this.showOnlyPlay,
  });

  @override
  State<FullScreenVideoPage> createState() => _FullScreenVideoPageState();
}

class _FullScreenVideoPageState extends State<FullScreenVideoPage>
    with NavigateHelper {
  bool _showOverlay = true;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    // go immersive / landscape
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // ensure playback continues
    widget.controller.play();
    widget.controller.addListener(_updateState);
  }

  void _updateState() {
    if (!_isDragging) setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateState);
    // restore UI chrome & portrait
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
    final c = widget.controller;
    if (!c.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CustomLoader()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap:
              widget.showControls
                  ? () => setState(() => _showOverlay = !_showOverlay)
                  : null,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // keep aspect ratio and fill
              Center(
                child: AspectRatio(
                  aspectRatio: c.value.aspectRatio,
                  child: VideoPlayer(c),
                ),
              ),
              // overlay controls (exit replaces fullscreen)
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
                          c,
                          allowScrubbing: true,
                          padding: const EdgeInsets.only(bottom: 6),
                          colors: VideoProgressColors(
                            playedColor: AppColors.error,
                            bufferedColor: AppColors.secondary,
                            backgroundColor: AppColors.white.withOpacity(0.2),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              iconSize: 10,
                              icon: Icon(
                                c.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                                size: 24,
                              ),
                              onPressed: () {
                                setState(() {
                                  c.value.isPlaying ? c.pause() : c.play();
                                });
                              },
                            ),
                            if (!widget.showOnlyPlay) ...[
                              SizeHelper.width(),
                              CustomText(
                                text:
                                    "${_formatDuration(c.value.position)} / ${_formatDuration(c.value.duration)}",
                                style: TextStyleHelper.smallText.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ],
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.fullscreen_exit),
                              color: Colors.white,
                              onPressed: () => pop(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
