import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/provider/refer_provider/refer_provider.dart';
import 'package:mindful_youth/provider/user_provider/sign_up_provider.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/screens/events_screen/events_screen.dart';
import 'package:mindful_youth/screens/login/login_screen.dart';
import 'package:mindful_youth/screens/login/sign_up/sign_up.dart';
import 'package:mindful_youth/screens/shop_market_screen/products_screen.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/transitions/scale_fade_transiation.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_profile_avatar.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/exit_app_dialogbox.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../provider/home_screen_provider/home_screen_provider.dart';
import '../cousling_screens/cousiling_form_screen.dart';
import '../refer_screen/refer_screen.dart';

import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> with NavigateHelper {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserProvider userProvider = context.read<UserProvider>();
    Future.microtask(() async {
      userProvider.initProfilePicFromLocalStorage(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        HomeScreenProvider homeScreenProvider =
            context.read<HomeScreenProvider>();
        if (!didPop) {
          homeScreenProvider.setNavigationIndex =
              homeScreenProvider.navigationIndex - 1;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: AppStrings.account,
            style: TextStyleHelper.mediumHeading,
          ),
          // actions: [
          //   if (!userProvider.isUserLoggedIn)
          //     IconButton(
          //       onPressed:
          //           () => push(
          //             context: context,
          //             widget: LoginScreen(),
          //             transition: FadeUpwardsPageTransitionsBuilder(),
          //           ),
          //       icon: Icon(Icons.login, color: AppColors.primary),
          //     ),
          // ],
        ),
        body:
            userProvider.isUserLoggedIn
                ? AnimationLimiter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        childAnimationBuilder:
                            (widget) => SlideAnimation(
                              duration: Duration(milliseconds: 500),
                              horizontalOffset: 50.w,
                              child: FadeInAnimation(
                                duration: Duration(milliseconds: 500),
                                child: widget,
                              ),
                            ),
                        children: [
                          /// profile circle avatar
                          CustomProfileAvatar(),
                          SizeHelper.height(),

                          /// profile btn
                          ProfilePageListTiles(
                            leading: Icons.person,
                            onTap: () {
                              context
                                  .read<UserProvider>()
                                  .setCurrentSignupPageIndex = 0;
                              context
                                  .read<SignUpProvider>()
                                  .setIsUpdatingProfile = true;
                              push(
                                context: context,
                                widget: SignUpScreen(),
                                transition: OpenUpwardsPageTransitionsBuilder(),
                              );
                            },
                            titleText: AppStrings.profile,
                          ),

                          /// event history
                          ProfilePageListTiles(
                            leading: Icons.event_note_rounded,
                            onTap:
                                () => push(
                                  context: context,
                                  widget: EventsScreen(isMyEvents: true),
                                  transition:
                                      OpenUpwardsPageTransitionsBuilder(),
                                ),
                            titleText: AppStrings.eventHistory,
                          ),

                          /// program history
                          // ProfilePageListTiles(
                          //   leading: Icons.event_sharp,
                          //   onTap: () {},
                          //   titleText: AppStrings.programsHistory,
                          // ),

                          /// certificates
                          ProfilePageListTiles(
                            leading: Icons.workspace_premium,
                            onTap:
                                //  () {},
                                () => push(
                                  context: context,
                                  widget: CousilingFormScreen(),
                                  transition:
                                      OpenUpwardsPageTransitionsBuilder(),
                                ),
                            titleText: AppStrings.certificates,
                          ),

                          /// saved
                          // ProfilePageListTiles(
                          //   leading: Icons.folder_special,
                          //   onTap: () {},
                          //   // () => push(
                          //   //   context: context,
                          //   //   widget: ChipSelector(),
                          //   // ),
                          //   titleText: AppStrings.saved,
                          // ),

                          /// refer
                          ProfilePageListTiles(
                            leading: Icons.share,
                            // onTap: () {},
                            onTap: () async {
                              String referCode =
                                  await context
                                      .read<ReferProvider>()
                                      .initReferCodeFromLocalStorage();
                              push(
                                context: context,
                                widget: ReferralPage(
                                  points: "100",
                                  referCode: referCode,
                                ),
                                transition: FadeUpwardsPageTransitionsBuilder(),
                              );
                            },

                            titleText: AppStrings.refer,
                          ),

                          /// refer
                          ProfilePageListTiles(
                            leading: Icons.shopping_bag_outlined,
                            // onTap: () {},
                            onTap: () async {
                              push(
                                context: context,
                                widget: ProductListPage(),
                                transition: FadeUpwardsPageTransitionsBuilder(),
                              );
                            },

                            titleText: AppStrings.products,
                          ),
                          ProfilePageListTiles(
                            leading: Icons.delete_forever,
                            color: AppColors.error,
                            onTap: () async {
                              String uId = await SharedPrefs.getSharedString(
                                AppStrings.id,
                              );
                              if (!context.mounted) return;
                              showDialog(
                                context: context,
                                builder: (context) => DeleteAccount(uId: uId),
                              );
                            },
                            titleText: AppStrings.deleteAccount,
                          ),

                          /// logout account
                          ProfilePageListTiles(
                            leading: Icons.logout,
                            color: AppColors.error,
                            onTap:
                                () async => showDialog(
                                  context: context,
                                  builder: (context) => LogoutDialog(),
                                ),
                            titleText: AppStrings.logOut,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                : CustomContainer(
                  alignment: Alignment.center,
                  child: PrimaryBtn(
                    width: 30.w,
                    btnText: AppStrings.login,
                    onTap:
                        () => push(
                          context: context,
                          widget: LoginScreen(),
                          transition: ScaleFadePageTransitionsBuilder(),
                        ),
                  ),
                ),
      ),
    );
  }
}

class ProfilePageListTiles extends StatelessWidget {
  const ProfilePageListTiles({
    super.key,
    required this.titleText,
    required this.onTap,
    required this.leading,
    this.showTrailing = true,
    this.color,
  });
  final IconData leading;
  final bool showTrailing;
  final String titleText;
  final void Function()? onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // shape: Border(bottom: BorderSide(color: AppColors.grey)),
      splashColor: color?.withOpacity(0.3),
      leading: CustomContainer(
        child: Icon(leading, color: color ?? AppColors.grey),
      ),
      title: CustomText(
        text: titleText,
        style: TextStyleHelper.smallHeading.copyWith(color: color),
      ),
      trailing:
          showTrailing
              ? Icon(Icons.keyboard_arrow_right, color: color ?? AppColors.grey)
              : null,
      onTap: onTap,
    );
  }
}

class AudioRecorderPlayer extends StatefulWidget {
  @override
  _AudioRecorderPlayerState createState() => _AudioRecorderPlayerState();
}

class _AudioRecorderPlayerState extends State<AudioRecorderPlayer> {
  FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  FlutterSoundPlayer _player = FlutterSoundPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _filePath;
  final int _maxFileSize = 5 * 1024 * 1024; // 5 MB
  StreamSubscription? _sizeMonitor;

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
    _sizeMonitor?.cancel();
    super.dispose();
  }

  Future<void> _startRecording() async {
    bool permissionGranted = await Permission.microphone.request().isGranted;
    if (!permissionGranted) return;

    Directory tempDir = await getTemporaryDirectory();
    _filePath = '${tempDir.path}/audio_record.aac';

    await _recorder.startRecorder(toFile: _filePath, codec: Codec.aacADTS);

    setState(() => _isRecording = true);

    _monitorFileSize();
  }

  void _monitorFileSize() {
    _sizeMonitor = Stream.periodic(Duration(milliseconds: 500)).listen((
      _,
    ) async {
      if (_filePath == null) return;
      final file = File(_filePath!);
      if (await file.exists()) {
        final size = await file.length();
        print(size.toString());
        if (size >= _maxFileSize) {
          _stopRecording();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Recording stopped: Max size 5MB reached')),
          );
        }
      }
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    _sizeMonitor?.cancel();
    setState(() => _isRecording = false);
  }

  Future<void> _playRecording() async {
    if (_filePath == null || _isPlaying) return;
    await _player.startPlayer(
      fromURI: _filePath,
      whenFinished: () {
        setState(() => _isPlaying = false);
      },
    );
    setState(() => _isPlaying = true);
  }

  Future<void> _stopPlayback() async {
    await _player.stopPlayer();
    setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isRecording ? Icons.mic : Icons.mic_none,
              size: 64,
              color: _isRecording ? Colors.red : Colors.blue,
            ),
            const SizedBox(height: 20),
            Text(
              _isRecording ? 'Recording...' : 'Press to record (max 5MB)',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  icon: Icon(
                    _isRecording ? Icons.stop : Icons.fiber_manual_record,
                  ),
                  label: Text(_isRecording ? 'Stop' : 'Record'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRecording ? Colors.red : Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _isPlaying ? _stopPlayback : _playRecording,
                  icon: Icon(_isPlaying ? Icons.stop : Icons.play_arrow),
                  label: Text(_isPlaying ? 'Stop' : 'Play'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
