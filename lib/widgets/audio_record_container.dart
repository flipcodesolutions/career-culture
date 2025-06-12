import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_colors.dart';
import '../app_const/app_size.dart';
import '../provider/assessment_provider/assessment_provider.dart';
import '../utils/method_helpers/size_helper.dart';
import '../utils/text_style_helper/text_style_helper.dart';
import 'custom_container.dart';
import 'custom_text.dart';

class AudioRecorderPlayer extends StatefulWidget {
  final int? questionId;
  final int maximumAudioSize;

  const AudioRecorderPlayer({
    super.key,
    required this.questionId,
    this.maximumAudioSize = 1,
  });

  @override
  _AudioRecorderPlayerState createState() => _AudioRecorderPlayerState();
}

class _AudioRecorderPlayerState extends State<AudioRecorderPlayer> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  late StreamController<Uint8List> _recorderStreamController;
  final List<int> _audioBuffer = [];

  bool _isRecording = false;
  bool _isPlaying = false;
  int _currentFileSize = 0;

  @override
  void initState() {
    super.initState();
    _recorder.openRecorder();
    _player.openPlayer();
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final hasPermission = await Permission.microphone.request().isGranted;
    if (!hasPermission) return;

    _audioBuffer.clear();
    _currentFileSize = 0;

    _recorderStreamController = StreamController<Uint8List>();
    _recorderStreamController.stream.listen((buffer) {
      // Only handle non-empty buffers
      if (buffer.isNotEmpty) {
        _audioBuffer.addAll(buffer);
        _currentFileSize = _audioBuffer.length;
        final maxBytes = widget.maximumAudioSize * 1024 * 1024;
        if (_currentFileSize >= maxBytes) {
          _stopRecording();
          WidgetHelper.customSnackBar(
            title: "Recording stopped: Max size reached",
            isError: true,
          );
        }
        setState(() {});
      }
    });

    await _recorder.startRecorder(
      toStream: _recorderStreamController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 16000,
    );

    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    await _recorderStreamController.close();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _playRecording() async {
    if (_isPlaying || _audioBuffer.isEmpty) return;

    await _player.startPlayer(
      fromDataBuffer: Uint8List.fromList(_audioBuffer),
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 16000,
      whenFinished: () => setState(() => _isPlaying = false),
    );

    setState(() {
      _isPlaying = true;
    });
  }

  Future<void> _stopPlayback() async {
    await _player.stopPlayer();
    setState(() {
      _isPlaying = false;
    });
  }

  void _handleSingleAction() {
    if (_isRecording) {
      _stopRecording();
    } else if (_isPlaying) {
      _stopPlayback();
    } else if (_audioBuffer.isEmpty) {
      _startRecording();
    } else {
      _playRecording();
    }
  }

  double _getProgress() {
    final maxBytes = widget.maximumAudioSize * 1024 * 1024;
    return (_currentFileSize / maxBytes).clamp(0.0, 1.0);
  }

  IconData _getIcon() {
    if (_isRecording) return Icons.stop;
    if (_isPlaying) return Icons.pause_circle;
    if (_audioBuffer.isEmpty) return Icons.mic;
    return Icons.play_arrow;
  }

  String _getTitle() {
    if (_isRecording) return 'Stop Recording';
    if (_isPlaying) return 'Pause Playback';
    if (_audioBuffer.isEmpty) return 'Start Recording';
    return 'Play Recording';
  }

  String _getSubtitle() {
    if (_isRecording) return 'Recording... tap to stop';
    if (_isPlaying) return 'Playing... tap to pause';
    if (_audioBuffer.isEmpty) return 'Tap to record';
    return 'Tap to play';
  }

  @override
  Widget build(BuildContext context) {
    final AssessmentProvider assessmentProvider =
        context.watch<AssessmentProvider>();
    final List<PlatformFile> selectedFileList =
        assessmentProvider.assessmentQuestions?.data
            ?.where((e) => e.id == widget.questionId)
            .first
            .selectedFiles ??
        [];
    return CustomContainer(
      backGroundColor: AppColors.lightWhite,
      borderRadius: BorderRadius.circular(AppSize.size10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizeHelper.height(height: 1.h),
          CustomText(
            text: "Record Audio ",
            style: TextStyleHelper.smallHeading.copyWith(
              color: AppColors.primary,
            ),
          ),
          SizeHelper.height(),
          CustomContainer(
            margin: EdgeInsets.symmetric(horizontal: 5.w),
            child: LinearProgressIndicator(
              value: _getProgress(),
              borderRadius: BorderRadius.circular(AppSize.size10),
              backgroundColor: AppColors.lightGrey,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getProgress() > 0.8 ? Colors.red : Colors.green,
              ),
              minHeight: 8,
            ),
          ),
          SizeHelper.height(height: 1.h),
          CustomText(
            text:
                'Audio Size :- ${(_currentFileSize / (1024 * 1024)).toStringAsFixed(3)} MB / ${widget.maximumAudioSize} MB',
          ),
          SizeHelper.height(height: 1.h),
          ListTile(
            dense: true,
            leading: InkWell(
              onTap: () => _handleSingleAction(),
              child: Icon(_getIcon(), color: AppColors.primary, size: 32),
            ),
            title: CustomText(text: _getTitle()),
            subtitle: CustomText(
              text: _getSubtitle(),
              style: TextStyleHelper.xSmallText.copyWith(
                fontStyle: FontStyle.italic,
                color: AppColors.grey,
              ),
              useOverflow: false,
            ),
            trailing:
                _audioBuffer.isNotEmpty
                    ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            assessmentProvider.makeFilesSelection(
                              questionId: widget.questionId ?? -1,
                              selectedFiles: [
                                PlatformFile(
                                  name: "${DateTime.now().toIso8601String()}",
                                  size: _audioBuffer.length,
                                  bytes: Uint8List.fromList(_audioBuffer),
                                ),
                              ],
                            );
                            _stopPlayback();
                            setState(() {
                              _audioBuffer.clear();
                              _currentFileSize = 0;
                            });
                          },
                          icon: Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            assessmentProvider.clearFilesSelection(
                              questionId: widget.questionId ?? -1,
                            );
                            _stopPlayback();
                            setState(() {
                              _audioBuffer.clear();
                              _currentFileSize = 0;
                            });
                          },
                          icon: Icon(Icons.delete, color: AppColors.error),
                        ),
                      ],
                    )
                    : null,
          ),
          if (selectedFileList.isNotEmpty)
            ListTile(
              leading: Icon(Icons.audiotrack, color: AppColors.primary),
              title: CustomText(
                text: selectedFileList.first.name,
                useOverflow: false,
              ),
            ),
        ],
      ),
    );
  }
}
