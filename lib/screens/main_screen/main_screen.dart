import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindful_youth/provider/notification_handler/notification_helper.dart';
import 'package:mindful_youth/screens/account_screen/account_screen.dart';
import 'package:mindful_youth/screens/events_screen/events_screen.dart';
import 'package:mindful_youth/screens/home_screen/home_screen.dart';
import 'package:mindful_youth/screens/programs_screen/programs_screens.dart';
import 'package:mindful_youth/screens/wall_screen/wall_screen.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/widgets/custom_fab_on_screen_btn.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import '../../app_const/app_colors.dart';
import '../../provider/home_screen_provider/home_screen_provider.dart';
import '../../widgets/navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.setIndex});
  final int? setIndex;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with NavigateHelper {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      context.read<HomeScreenProvider>().setNavigationIndex =
          widget.setIndex ?? 0;
      await MethodHelper.getAndSendFcmTokenToBackend(context: context);
    });
    NotificationHelper().processInitialUri();
  }

  final List<Widget> screenList = [
    HomeScreen(),
    WallScreen(),
    ProgramsScreens(),
    EventsScreen(isMyEvents: false),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    HomeScreenProvider homeScreenProvider = context.watch<HomeScreenProvider>();
    return UpgradeAlert(
      showIgnore: false,
      showLater: false,
      barrierDismissible: false,
      showReleaseNotes: true,
      upgrader: Upgrader(debugDisplayAlways: true, debugDisplayOnce: true),
      cupertinoButtonTextStyle: TextStyle(color: AppColors.primary),
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: screenList[homeScreenProvider.navigationIndex],
          floatingActionButton: CustomSpeedDial(),
          bottomNavigationBar: SafeArea(
            child: Selector<HomeScreenProvider, int>(
              builder:
                  (context, navIndex, child) =>
                      NavigationBarWidget(navIndex: navIndex),
              selector:
                  (context, homeScreenProvider) =>
                      homeScreenProvider.navigationIndex,
            ),
          ),
        ),
      ),
    );
  }
}
