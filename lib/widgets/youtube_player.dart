import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/utils/method_helpers/gradient_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// A widget that displays a YouTube video with optional fullscreen mode.
class CustomVideoPlayer extends StatefulWidget {
  const CustomVideoPlayer({
    Key? key,
    required this.videoId,
    required this.heading,
    required this.description,
  }) : super(key: key);

  final String videoId;
  final String heading;
  final String description;

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer>
    with NavigateHelper {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        enableCaption: true,
      ),
    )..addListener(_listener);
  }

  void _listener() {
    if (_controller.value.isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_listener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      bottomActions: [
        const CurrentPosition(),
        SizeHelper.width(),
        const ProgressBar(isExpanded: true),
        const RemainingDuration(),
        SizeHelper.width(),
        IconButton(
          onPressed: () {
            push(
              context: context,
              widget: FullScreenYoutubePage(controller: _controller),
            );
          },
          icon: const Icon(Icons.fullscreen, color: AppColors.white),
        ),
      ],
    );
  }
}

/// Full-screen page for immersive playback.
class FullScreenYoutubePage extends StatefulWidget {
  const FullScreenYoutubePage({super.key, required this.controller});

  final YoutubePlayerController controller;

  @override
  _FullScreenYoutubePageState createState() => _FullScreenYoutubePageState();
}

class _FullScreenYoutubePageState extends State<FullScreenYoutubePage>
    with NavigateHelper {
  bool _showOverlay = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    widget.controller.play();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    return h > 0 ? '$two(h):$m:$s' : '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => setState(() => _showOverlay = !_showOverlay),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: YoutubePlayer(controller: c),
                ),
              ),
              if (_showOverlay)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 2.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: GradientHelper.videoPlayer,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ProgressBar(controller: c),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                c.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                              ),
                              onPressed:
                                  () =>
                                      c.value.isPlaying ? c.pause() : c.play(),
                            ),
                            CustomText(
                              text:
                                  '${_format(c.value.position)} / ${_format(c.value.position)}',
                              style: TextStyleHelper.smallText.copyWith(
                                color: AppColors.white,
                              ),
                            ),
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
