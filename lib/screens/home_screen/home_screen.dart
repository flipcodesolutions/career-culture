import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_icons.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/screens/login/login_screen.dart';
import 'package:mindful_youth/screens/notification_screen/notification_screen.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/transitions/scale_fade_transiation.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_grid.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';
import '../../utils/widget_helper/widget_helper.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_slider.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        actions: [
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
      ),
      body: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: SearchBar(leading: AppIcons.search),
                ),
                SizeHelper.height(height: 4.h),

                /// user score tracking
                if (userProvider.isUserLoggedIn) ...[
                  DashBoardUserScoreWidget(
                    score: "5000",
                    animationDuration: Duration(seconds: 3),
                  ),
                  SizeHelper.height(),
                ] else ...[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: PrimaryBtn(
                      width: 90.w,
                      btnText: AppStrings.login,
                      onTap: () {
                        push(
                          context: context,
                          widget: LoginScreen(),
                          transition: FadeUpwardsPageTransitionsBuilder(),
                        );
                        WidgetHelper.customSnackBar(
                          context: context,
                          title: AppStrings.pleaseLoginFirst,
                          isError: true,
                        );
                      },
                    ),
                  ),
                  SizeHelper.height(),
                ],

                /// user pashes
                SliderRenderWidget(items: [SizedBox(), SizedBox(), SizedBox()]),
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
                ChapterProgressWidget(
                  imageUrl: "https://picsum.photos/id/237/200/300",
                  chapter: "Chapter 1:",
                  description: "Analysis Thought Process.",
                  progressPercent: 90,
                ),

                SizeHelper.height(),
                SliderRenderWidget(items: [SizedBox(), SizedBox(), SizedBox()]),
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
        ),
      ),
    );
  }
}
