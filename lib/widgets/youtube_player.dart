import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../app_const/app_strings.dart';

class VideoPreviewScreen extends StatelessWidget with NavigateHelper {
  final String videoUrl;
  final String? description;
  const VideoPreviewScreen({
    super.key,
    required this.videoUrl,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';

    return GestureDetector(
      onTap:
          () => push(
            context: context,
            widget: YoutubePlayerScreen(
              videoId: videoId,
              description: description,
            ),
          ),

      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: CustomImageWithLoader(
              showImageInPanel: false,
              fit: BoxFit.cover,
              imageUrl: 'https://img.youtube.com/vi/$videoId/0.jpg',
            ),
          ),
          const Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
        ],
      ),
    );
  }
}

class YoutubePlayerScreen extends StatefulWidget {
  final String videoId;
  final String? description;

  const YoutubePlayerScreen({
    super.key,
    required this.videoId,
    this.description,
  });

  @override
  State<YoutubePlayerScreen> createState() => _YoutubePlayerScreenState();
}

class _YoutubePlayerScreenState extends State<YoutubePlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false;
  String _videoTitle = "";

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: true,
        hideControls: false,
        controlsVisibleAtStart: false,
        enableCaption: false,
        showLiveFullscreenButton: false,
      ),
    );

    _controller.addListener(() {
      if (_controller.metadata.title.isNotEmpty &&
          _controller.metadata.title != _videoTitle) {
        setState(() {
          _videoTitle = _controller.metadata.title;
        });
      }

      final isNowFullScreen = _controller.value.isFullScreen;
      if (isNowFullScreen != _isFullScreen) {
        setState(() => _isFullScreen = isNowFullScreen);
      }
    });
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();

    // Restore UI on exit
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

  void _toggleFullscreen() async {
    if (!_isFullScreen) {
      // Enter fullscreen
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      // Exit fullscreen
      // Delay restoring UI slightly to avoid timing issues
      Future.delayed(Duration(milliseconds: 400), () {
        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.edgeToEdge, // or SystemUiMode.manual with overlays
          overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
        );
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      });
    }

    _controller.toggleFullScreenMode(); // Use this instead of copyWith
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      // appBar: _isFullScreen ? null : AppBar(),
      body: SafeArea(
        child: YoutubePlayerBuilder(
          player: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            bufferIndicator: CustomLoader(),
            onEnded: (metaData) {
              _controller.seekTo(Duration.zero);
              _controller.play();
            },
            progressColors: const ProgressBarColors(
              playedColor: AppColors.primary,
              handleColor: AppColors.secondary,
            ),
            bottomActions: [
              const CurrentPosition(),
              const ProgressBar(
                isExpanded: true,
                colors: ProgressBarColors(
                  playedColor: AppColors.primary,
                  handleColor: AppColors.primary,
                  bufferedColor: AppColors.secondary,
                ),
              ),
              const RemainingDuration(),
              IconButton(
                icon: Icon(
                  _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
                  color: Colors.white,
                ),
                onPressed: _toggleFullscreen,
              ),
            ],
          ),
          builder:
              (context, player) => SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    AspectRatio(aspectRatio: 16 / 9, child: player),
                    if (!_isFullScreen) ...[
                      _videoTitle.isNotEmpty
                          ? CustomContainer(
                            width: 100.w,
                            boxShadow: ShadowHelper.scoreContainer,
                            backGroundColor: AppColors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 1.h,
                            ),
                            child: CustomText(
                              text: _controller.metadata.title,
                              useOverflow: false,
                              style: TextStyleHelper.smallHeading.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          )
                          : SizedBox.shrink(),

                      if (widget.description?.isNotEmpty == true)
                        CustomContainer(
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                            vertical: 1.h,
                          ),
                          child:
                              widget.description?.isNotEmpty == true
                                  ? Html(
                                    data:
                                        widget.description ??
                                        AppStrings.noDescriptionFound,
                                  )
                                  : CustomContainer(
                                    padding: EdgeInsets.only(top: 5.h),
                                    alignment: Alignment.center,
                                    child: CustomText(
                                      text: AppStrings.noDescriptionFound,
                                    ),
                                  ),
                        ),
                    ],
                  ],
                ),
              ),
        ),
      ),
    );
  }
}
