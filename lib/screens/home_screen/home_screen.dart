import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/screens/login/login_screen.dart';
import 'package:mindful_youth/screens/notification_screen/notification_screen.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/transitions/scale_fade_transiation.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';
import '../../models/product_model/product_model.dart';
import '../../provider/home_screen_provider/home_screen_provider.dart';
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

class _HomeScreenState extends State<HomeScreen> with NavigateHelper {
  @override
  void initState() {
    UserProvider userProvider = context.read<UserProvider>();
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      userProvider.checkIfUserIsLoggedIn();
    }).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    HomeScreenProvider homeScreenProvider = context.watch<HomeScreenProvider>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          showDialog(context: context, builder: (context) => ExitAppDialog());
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            if (!userProvider.isUserLoggedIn) ...[
              IconButton(
                onPressed:
                    () => push(
                      context: context,
                      widget: LoginScreen(),
                      transition: FadeUpwardsPageTransitionsBuilder(),
                    ),
                icon: Icon(Icons.login, color: AppColors.primary),
              ),
            ] else ...[
              IconButton(
                onPressed:
                    () => push(
                      context: context,
                      widget: ProductListPage(
                        products: List.generate(
                          5,
                          (index) => Product(
                            description:
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
                            imageUrl: "https://picsum.photos/536/354",
                            name:
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                            price: 200,
                          ),
                        ),
                      ),

                      transition: OpenUpwardsPageTransitionsBuilder(),
                    ),
                icon: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppColors.primary,
                ),
              ),
              IconButton(
                onPressed:
                    () => push(
                      context: context,
                      widget: NotificationScreen(),
                      transition: ScaleFadePageTransitionsBuilder(),
                    ),
                icon: Icon(Icons.notifications),
              ),
            ],
          ],
        ),
        body: AnimationLimiter(
          child: CustomRefreshIndicator(
            onRefresh: () async {
              await homeScreenProvider.getHomeScreenSlider(context: context);
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
                        DashBoardUserScoreWidget(
                          score: "5000",
                          animationDuration: Duration(seconds: 3),
                        ),

                      SizeHelper.height(),

                      /// user pashes
                      SliderRenderWidget(),
                      SizeHelper.height(),

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
                      // SliderRenderWidget(items: [SizedBox(), SizedBox(), SizedBox()]),
                      SizeHelper.height(),

                      /// recent activity text
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 5.w),
                      //   child: CustomText(
                      //     text: AppStrings.suggestedBooks,
                      //     style: TextStyleHelper.mediumHeading.copyWith(
                      //       color: AppColors.primary,
                      //     ),
                      //   ),
                      // ),
                      // SizeHelper.height(),
                      // CustomGridWidget(
                      //   isNotScroll: true,
                      //   data: List<String>.generate(10, (index) => ""),
                      //   itemBuilder:
                      //       (item, index) => CustomContainer(
                      //         backGroundColor: AppColors.cream,
                      //         child: CustomImageWithLoader(
                      //           imageUrl:
                      //               "https://picsum.photos/id/1084/536/354?grayscale",
                      //         ),
                      //       ),

                      //   axisCount: 3,
                      // ),
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
