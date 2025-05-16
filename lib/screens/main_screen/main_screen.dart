import 'package:flutter/material.dart';
import 'package:mindful_youth/screens/account_screen/account_screen.dart';
import 'package:mindful_youth/screens/events_screen/events_screen.dart';
import 'package:mindful_youth/screens/home_screen/home_screen.dart';
import 'package:mindful_youth/screens/programs_screen/programs_screens.dart';
import 'package:mindful_youth/screens/wall_screen/wall_screen.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:provider/provider.dart';
import '../../provider/home_screen_provider/home_screen_provider.dart';
import '../../widgets/navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.setIndex});
  final int? setIndex;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
    context.read<HomeScreenProvider>().setNavigationIndex =
        widget.setIndex ?? 0;
      await MethodHelper.getAndSendFcmTokenToBackend();
    });
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: screenList[homeScreenProvider.navigationIndex],
        bottomNavigationBar: Selector<HomeScreenProvider, int>(
          builder:
              (context, navIndex, child) =>
                  NavigationBarWidget(navIndex: navIndex),
          selector:
              (context, homeScreenProvider) =>
                  homeScreenProvider.navigationIndex,
        ),
      ),
    );
  }
}
