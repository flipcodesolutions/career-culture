import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/provider/all_event_provider/all_event_provider.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/screens/feedback_screen/feedback_screen.dart';
import 'package:mindful_youth/screens/login/sign_up/sign_up.dart';
import 'package:mindful_youth/screens/notification_screen/notification_screen.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/transitions/scale_fade_transiation.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/utils/user_screen_time/tracking_mixin.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_product_showcase.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';
import '../../models/feedback_model/feedback_model.dart';
import '../../provider/home_screen_provider/home_screen_provider.dart';
import '../../provider/product_provider/product_provider.dart';
import '../../provider/user_provider/sign_up_provider.dart';
import '../../widgets/custom_annoucement_slider.dart';
import '../../widgets/custom_slider.dart';
import '../../widgets/exit_app_dialogbox.dart';
import '../shop_market_screen/products_screen.dart';
import 'home_screen_widget/chapter_progress.dart';
import 'home_screen_widget/dashboard_user_score_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, ScreenTracker<HomeScreen>, NavigateHelper {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  String get screenName => 'HomeScreen';
  @override
  void initState() {
    UserProvider userProvider = context.read<UserProvider>();
    HomeScreenProvider homeProvider = context.read<HomeScreenProvider>();
    AllEventProvider eventProvider = context.read<AllEventProvider>();
    ProductProvider productProvider = context.read<ProductProvider>();
    SignUpProvider signUpProvider = context.read<SignUpProvider>();
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      userProvider.checkIfUserIsLoggedIn();
      userProvider.checkIfUserIsApproved();
      userProvider.getUserData();
      await productProvider.getProductList(context: context);
      await eventProvider.getAllEvents(context: context);
      await homeProvider.getUserOverAllScore(context: context);

      /// check if logged in user has empty user profile or user education
      if (await userProvider.isUserProfileAndUserEducationIsNull()) {
        /// set the flag to true so [SignUpPage] render in update mode
        signUpProvider.setIsUpdatingProfile = true;

        /// redirect user to fill the empty fields
        push(
          context: context,
          widget: SignUpScreen(isFromHomeScreen: true),
          transition: OpenUpwardsPageTransitionsBuilder(),
        );
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    HomeScreenProvider homeScreenProvider = context.watch<HomeScreenProvider>();
    AllEventProvider eventProvider = context.watch<AllEventProvider>();
    ProductProvider productProvider = context.watch<ProductProvider>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          showDialog(context: context, builder: (context) => ExitAppDialog());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          shape: Border(),
          leading: CustomContainer(
            padding: EdgeInsets.all(5),
            child: Image.asset(AppImageStrings.imageOnlyLogo),
          ),
          actions: [
            AppBarIcon(
              onTap:
                  () => push(
                    context: context,
                    widget: ProductListPage(),

                    transition: OpenUpwardsPageTransitionsBuilder(),
                  ),
              icon: AppImageStrings.shoppingBagIcon,
            ),
            AppBarIcon(
              icon: AppImageStrings.notificationBellIcon,
              iconH: 3.5.h,
              iconW: 3.5.h,
              onTap:
                  () => push(
                    context: context,
                    widget: NotificationScreen(),
                    transition: ScaleFadePageTransitionsBuilder(),
                  ),
            ),
          ],
          // ],
        ),
        body: AnimationLimiter(
          child: CustomRefreshIndicator(
            onRefresh: () async {
              await homeScreenProvider.getHomeScreenSlider(context: context);
              await productProvider.getProductList(context: context);
              await homeScreenProvider.getUserOverAllScore(context: context);
            },
            child: ListView(
              shrinkWrap: true,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: AnimationConfiguration.toStaggeredList(
                    childAnimationBuilder:
                        (widget) => SlideAnimation(
                          horizontalOffset: 10.w,
                          duration: Duration(milliseconds: 300),
                          child: FadeInAnimation(
                            duration: Duration(milliseconds: 300),
                            child: widget,
                          ),
                        ),
                    children: [
                      SizeHelper.height(),

                      /// search bar
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 5.w),
                      //   child: SearchBar(leading: AppIcons.search),
                      // ),
                      // SizeHelper.height(height: 4.h),

                      /// user score tracking
                      if (userProvider.isUserLoggedIn)
                        homeScreenProvider.isLoading
                            ? Center(child: CustomLoader())
                            : DashBoardUserScoreWidget(
                              onTap:
                                  () =>
                                      homeScreenProvider.setNavigationIndex = 4,
                              score:
                                  homeScreenProvider
                                      .overAllScoreModel
                                      ?.data
                                      ?.totalPoints
                                      .toString() ??
                                  "-",
                              pendingScore:
                                  homeScreenProvider
                                      .overAllScoreModel
                                      ?.data
                                      ?.pendingPoints
                                      .toString() ??
                                  "",
                              animationDuration: Duration(seconds: 3),
                            ),

                      SizeHelper.height(),
                      Selector<HomeScreenProvider, bool>(
                        builder:
                            (context, value, child) => SliderRenderWidget(),
                        selector:
                            (p0, homeScreenProduct) =>
                                homeScreenProduct.isLoading,
                      ),

                      /// user pashes
                      SizeHelper.height(),
                      if (userProvider.isUserLoggedIn) ...[
                        /// recent activity text
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: CustomText(
                            text: AppStrings.recentActivity,
                            style: TextStyleHelper.mediumHeading.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SizeHelper.height(),

                        /// progress
                        ChapterProgressWidget(),

                        SizeHelper.height(),
                      ],

                      /// recent activity text
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: CustomText(
                          text: AppStrings.announceMent,
                          style: TextStyleHelper.mediumHeading.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizeHelper.height(),
                      CustomAnnouncementSlider(eventProvider: eventProvider),
                      SizeHelper.height(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: CustomText(
                          text: AppStrings.products,
                          style: TextStyleHelper.mediumHeading.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizeHelper.height(),
                      ProductShowCase(),
                      SizeHelper.height(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppBarIcon extends StatelessWidget {
  const AppBarIcon({
    super.key,
    required this.onTap,
    required this.icon,
    this.iconH,
    this.iconW,
  });
  final void Function()? onTap;
  final String icon;
  final double? iconH;
  final double? iconW;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CustomContainer(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        width: iconW ?? 4.h,
        height: iconH ?? 4.h,
        child: Image.asset(icon),
      ),
    );
  }
}
