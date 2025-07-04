import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/provider/refer_provider/refer_provider.dart';
import 'package:mindful_youth/provider/user_provider/sign_up_provider.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/screens/events_screen/events_screen.dart';
import 'package:mindful_youth/screens/faq_screen/faq_screen.dart';
import 'package:mindful_youth/screens/feedback_screen/feedback_screen.dart';
import 'package:mindful_youth/screens/login/login_screen.dart';
import 'package:mindful_youth/screens/login/sign_up/sign_up.dart';
import 'package:mindful_youth/screens/shop_market_screen/order_list_screen.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/transitions/scale_fade_transiation.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
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
        ),
        body:
            userProvider.isUserLoggedIn
                ? AnimationLimiter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: SingleChildScrollView(
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
                            SizeHelper.height(),
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
                                  transition:
                                      OpenUpwardsPageTransitionsBuilder(),
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
                              titleText: AppStrings.myParticipants,
                            ),

                            /// certificates
                            ProfilePageListTiles(
                              leading: Icons.workspace_premium,
                              onTap:
                                  () => WidgetHelper.customSnackBar(
                                    title: "Coming Soon !!",
                                  ),
                              // () => push(
                              //   context: context,
                              //   widget: CousilingFormScreen(),
                              //   transition:
                              //       OpenUpwardsPageTransitionsBuilder(),
                              // ),
                              titleText: AppStrings.myCertificates,
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
                                  transition:
                                      FadeUpwardsPageTransitionsBuilder(),
                                );
                              },

                              titleText: AppStrings.refer,
                            ),

                            /// purchase history
                            ProfilePageListTiles(
                              leading: Icons.shopping_bag_outlined,
                              // onTap: () {},
                              onTap: () async {
                                push(
                                  context: context,
                                  widget: OrderListPage(),
                                  transition:
                                      FadeUpwardsPageTransitionsBuilder(),
                                );
                              },

                              titleText: AppStrings.purchaseHistory,
                            ),

                            /// faq history
                            ProfilePageListTiles(
                              leading: Icons.question_mark_sharp,
                              // onTap: () {},
                              onTap: () async {
                                push(
                                  context: context,
                                  widget: FaqScreen(),
                                  transition:
                                      FadeUpwardsPageTransitionsBuilder(),
                                );
                              },

                              titleText: AppStrings.faq,
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
