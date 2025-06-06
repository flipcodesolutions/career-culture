import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/screens/account_screen/account_screen.dart';
import 'package:mindful_youth/screens/events_screen/events_screen.dart';
import 'package:mindful_youth/screens/home_screen/home_screen.dart';
import 'package:mindful_youth/screens/programs_screen/programs_screens.dart';
import 'package:mindful_youth/screens/wall_screen/wall_screen.dart';
import 'package:mindful_youth/utils/border_helper/border_helper.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:provider/provider.dart';
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
  final GlobalKey<ExpandableFabState> _key = GlobalKey<ExpandableFabState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      context.read<HomeScreenProvider>().setNavigationIndex =
          widget.setIndex ?? 0;
      await MethodHelper.getAndSendFcmTokenToBackend(context: context);
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
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: ExpandableFab(
          key: _key,
          type: ExpandableFabType.fan,
          overlayStyle: ExpandableFabOverlayStyle(blur: AppSize.size10),
          fanAngle: 90,
          openButtonBuilder: fabBtnsHelper(icon: Icons.widgets_rounded),
          closeButtonBuilder: fabBtnsHelper(
            icon: Icons.clear,
            backgroundColor: AppColors.error,
            fabSize: ExpandableFabSize.small,
            iconSize: AppSize.size20,
          ),
          children: [
            CustomFloatingActionBtn(
              iconData: Icons.bubble_chart_rounded,
              onPressed: () {
                // _key.currentState?.toggle();
                // push(context: context, widget: NotificationScreen());
              },
            ),
            CustomFloatingActionBtn(iconData: Icons.call),
            CustomFloatingActionBtn(iconData: Icons.wechat_sharp),
          ],
        ),
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

  /// used to create a fab btns
  RotateFloatingActionButtonBuilder fabBtnsHelper({
    required IconData icon,
    Color? foregroundColor,
    Color? backgroundColor,
    double? iconSize,
    ExpandableFabSize? fabSize,
  }) {
    return RotateFloatingActionButtonBuilder(
      child: Icon(icon, size: iconSize ?? AppSize.size30),
      fabSize: fabSize ?? ExpandableFabSize.regular,
      foregroundColor: foregroundColor ?? AppColors.white,
      backgroundColor: backgroundColor ?? AppColors.secondary,
      shape: BorderHelper.containerLikeBorder(borderRadius: AppSize.size10),
    );
  }
}

//// custom floating btn
class CustomFloatingActionBtn extends StatelessWidget {
  const CustomFloatingActionBtn({
    super.key,
    this.onPressed,
    this.backGroundColor,
    this.foregroundColor,
    this.child,
    this.iconData,
  });
  final void Function()? onPressed;
  final Color? backGroundColor;
  final Color? foregroundColor;
  final Widget? child;
  final IconData? iconData;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: DateTime.now().toIso8601String(),
      onPressed: onPressed,
      backgroundColor: backGroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.white,
      child:
          child ??
          Icon(
            iconData ?? Icons.check_box_outline_blank_rounded,
            size: AppSize.size30,
          ),
    );
  }
}
