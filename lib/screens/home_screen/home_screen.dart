import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/all_event_provider/all_event_provider.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/screens/login/sign_up/sign_up.dart';
import 'package:mindful_youth/screens/notification_screen/notification_screen.dart';
import 'package:mindful_youth/utils/list_helper/list_helper.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
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
import '../../provider/home_screen_provider/home_screen_provider.dart';
import '../../provider/product_provider/product_provider.dart';
import '../../provider/user_provider/sign_up_provider.dart';
import '../../utils/shared_prefs_helper/shared_prefs_helper.dart';
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
        if (Platform.isAndroid) {
          if (!didPop) {
            showDialog(context: context, builder: (context) => ExitAppDialog());
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          shape: Border(),
          leading: CustomContainer(
            padding: EdgeInsets.only(left: 4.w),
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
              // iconH: 7.h,
              iconW: 10.w,
              onTap:
                  () => push(
                    context: context,
                    widget: NotificationScreen(),
                    transition: ScaleFadePageTransitionsBuilder(),
                  ),
            ),
            SizeHelper.width(width: 3.w),
          ],
          // ],
        ),
        body: SafeArea(
          child: AnimationLimiter(
            child: CustomRefreshIndicator(
              onRefresh: () async {
                await homeScreenProvider.getHomeScreenSlider(context: context);
                await productProvider.getProductList(context: context);
                await homeScreenProvider.getUserOverAllScore(context: context);
                await eventProvider.getAllEvents(context: context);
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
                                        homeScreenProvider.setNavigationIndex =
                                            4,
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

                        /// whish user birth day card
                        BirthdayAppreciationContainer(),

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
                        /// only show annoncement if available
                        if (eventProvider.eventModel?.data
                                ?.where(
                                  (element) => element.isAnnouncement == "yes",
                                )
                                .toList()
                                .isNotEmpty ==
                            true)
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
                        if (productProvider
                                .productModel
                                ?.data
                                ?.product
                                ?.isNotEmpty ==
                            true) ...[
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

                        /// testimonial crousal
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: CustomText(
                            text: AppStrings.seeWhatExpertsSays,
                            style: TextStyleHelper.mediumHeading.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SizeHelper.height(),

                        ///
                        CarouselSlider(
                          items: ListHelper.testimonialList(),
                          options: CarouselOptions(
                            autoPlay: true,
                            viewportFraction: 0.9,
                            enlargeCenterPage: true,
                          ),
                        ),

                        SizeHelper.height(height: 7.h),
                      ],
                    ),
                  ),
                ],
              ),
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

/// using in testimonials in home screen
class TestimonialCard extends StatelessWidget {
  final String name;
  final String designation;
  final String testimonial;
  final String imageUrl;
  final bool isImageOnline;
  const TestimonialCard({
    super.key,
    required this.name,
    required this.designation,
    required this.testimonial,
    required this.imageUrl,
    this.isImageOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      borderColor: AppColors.black,
      borderWidth: 0.5,
      margin: EdgeInsets.only(bottom: 3.h),
      backGroundColor: AppColors.counselingBox,
      borderRadius: BorderRadius.circular(AppSize.size10),
      padding: EdgeInsets.all(AppSize.size10),
      boxShadow: ShadowHelper.scoreContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.lightPrimary,
                radius: AppSize.size30,
                backgroundImage: AssetImage(imageUrl),
                // child:
                //     isImageOnline
                //         ? Image.network(imageUrl)
                //         : Image.asset(imageUrl),
              ),
              SizeHelper.width(width: 1.h),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: name,
                      style: TextStyleHelper.mediumHeading,
                    ),
                    CustomText(
                      text: designation,
                      style: TextStyleHelper.smallText.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizeHelper.height(height: 1.h),
          Expanded(
            child: CustomText(
              text: '“$testimonial”',
              textAlign: TextAlign.center,
              style: TextStyleHelper.smallText.copyWith(
                fontStyle: FontStyle.italic,
              ),
              useOverflow: false,
              maxLines: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class BirthdayAppreciationContainer extends StatefulWidget {
  const BirthdayAppreciationContainer({super.key});

  @override
  State<BirthdayAppreciationContainer> createState() =>
      _BirthdayAppreciationContainerState();
}

class _BirthdayAppreciationContainerState
    extends State<BirthdayAppreciationContainer> {
  String? userName;
  DateTime? userDOB;
  bool isTodayBirthday(DateTime? birthday) {
    final now = DateTime.now();
    if (birthday != null) {
      return now.day == birthday.day && now.month == birthday.month;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetch();
  }

  void fetch() async {
    userName = await SharedPrefs.getSharedString(AppStrings.userName);
    userDOB = MethodHelper.parseDateFromString(
      await SharedPrefs.getSharedString(AppStrings.dateOfBirth),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!isTodayBirthday(userDOB)) return const SizedBox.shrink();

    return CustomContainer(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      padding: const EdgeInsets.all(AppSize.size20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.pinkAccent, Colors.orangeAccent],
        ),
        borderRadius: BorderRadius.circular(AppSize.size10),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.cake, color: Colors.white, size: 40),
          SizeHelper.width(width: 3.w),
          Expanded(
            child: Text(
              "Happy Birthday, $userName! 🎉\nWishing you a joyful and fulfilling year ahead!",
              style: TextStyleHelper.smallText.copyWith(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
