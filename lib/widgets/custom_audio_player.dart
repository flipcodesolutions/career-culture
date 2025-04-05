import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import '../app_const/app_colors.dart';
import '../app_const/app_size.dart';
import '../utils/method_helpers/shadow_helper.dart';
import '../utils/text_style_helper/text_style_helper.dart';
import 'custom_container.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:rxdart/rxdart.dart';

class CustomAudioPlayer extends StatefulWidget {
  final String audioUrl;
  final Color? progressColor;
  final Color? backgroundColor;
  final Color? thumbColor;
  final double? barHeight;

  const CustomAudioPlayer({
    super.key,
    required this.audioUrl,
    this.progressColor,
    this.backgroundColor,
    this.thumbColor,
    this.barHeight,
  });

  @override
  State<CustomAudioPlayer> createState() => _CustomAudioPlayerState();
}

class _CustomAudioPlayerState extends State<CustomAudioPlayer> {
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer()..setUrl(widget.audioUrl);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      borderRadius: BorderRadius.circular(AppSize.size10),
      boxShadow: ShadowHelper.scoreContainer,
      backGroundColor: AppColors.lightWhite,
      padding: EdgeInsets.all(AppSize.size10),
      child: Column(
        children: [
          StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return ProgressBar(
                progress: positionData?.position ?? Duration.zero,
                buffered: positionData?.bufferedPosition ?? Duration.zero,
                total: positionData?.duration ?? Duration.zero,
                timeLabelTextStyle: TextStyleHelper.smallText.copyWith(
                  color: AppColors.black,
                ),
                bufferedBarColor:
                    widget.progressColor?.withOpacity(0.5) ?? AppColors.grey,
                progressBarColor: widget.progressColor ?? AppColors.primary,
                thumbColor: widget.thumbColor ?? AppColors.primary,
                barHeight: widget.barHeight ?? 5.0,
                onSeek: _player.seek,
              );
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10),
                onPressed: () {
                  final newPos = _player.position - const Duration(seconds: 10);
                  _player.seek(newPos > Duration.zero ? newPos : Duration.zero);
                },
              ),
              StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final processingState = playerState?.processingState;
                  final playing = playerState?.playing;
                  if (processingState == ProcessingState.loading ||
                      processingState == ProcessingState.buffering) {
                    return const CustomLoader();
                  } else if (playing != true) {
                    return IconButton(
                      icon: const Icon(Icons.play_arrow),
                      iconSize: AppSize.size30,
                      onPressed: _player.play,
                    );
                  } else if (processingState != ProcessingState.completed) {
                    return IconButton(
                      icon: const Icon(Icons.pause),
                      iconSize: AppSize.size30,
                      onPressed: _player.pause,
                    );
                  } else {
                    return IconButton(
                      icon: const Icon(Icons.replay),
                      iconSize: AppSize.size30,
                      onPressed: () => _player.seek(Duration.zero),
                    );
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10),
                onPressed: () {
                  final newPos = _player.position + const Duration(seconds: 10);
                  _player.seek(newPos);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
