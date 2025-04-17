import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/home_screen_provider/home_screen_provider.dart';
import 'package:mindful_youth/provider/user_provider/login_provider.dart';
import 'package:mindful_youth/provider/user_provider/sign_up_provider.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/screens/login/login_screen.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';

class ExitAppDialog extends StatelessWidget with NavigateHelper {
  const ExitAppDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      child: CustomContainer(
        padding: EdgeInsets.all(AppSize.size20),
        child: AnimationLimiter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AnimationConfiguration.toStaggeredList(
              childAnimationBuilder:
                  (widget) => ScaleAnimation(
                    duration: Duration(milliseconds: 500),
                    child: FadeInAnimation(
                      duration: Duration(milliseconds: 500),
                      child: widget,
                    ),
                  ),
              children: [
                CustomText(
                  text: AppStrings.areYouSureWantToExit,
                  style: TextStyleHelper.mediumHeading.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                SizeHelper.height(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PrimaryBtn(
                      width: 30.w,
                      btnText: AppStrings.cancel,
                      onTap: () => pop(context),
                    ),
                    PrimaryBtn(
                      borderColor: AppColors.error,
                      backGroundColor: AppColors.error,
                      width: 30.w,
                      btnText: AppStrings.exit,
                      textStyle: TextStyleHelper.smallHeading.copyWith(
                        color: AppColors.white,
                      ),
                      onTap: () {
                        SystemNavigator.pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LogoutDialog extends StatelessWidget with NavigateHelper {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      child: CustomContainer(
        padding: EdgeInsets.all(AppSize.size20),
        child: AnimationLimiter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AnimationConfiguration.toStaggeredList(
              childAnimationBuilder:
                  (widget) => ScaleAnimation(
                    duration: Duration(milliseconds: 500),
                    child: FadeInAnimation(
                      duration: Duration(milliseconds: 500),
                      child: widget,
                    ),
                  ),
              children: [
                CustomText(
                  text: AppStrings.areYouSureWantToLogout,
                  style: TextStyleHelper.mediumHeading.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                SizeHelper.height(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PrimaryBtn(
                      width: 30.w,
                      btnText: AppStrings.cancel,
                      onTap: () => pop(context),
                    ),
                    PrimaryBtn(
                      borderColor: AppColors.error,
                      backGroundColor: AppColors.error,
                      width: 30.w,
                      btnText: AppStrings.logOut,
                      textStyle: TextStyleHelper.smallHeading.copyWith(
                        color: AppColors.white,
                      ),
                      onTap: () async {
                        /// delete locale storage
                        await SharedPrefs.clearShared();
                        if (!context.mounted) return;

                        /// set home screen to 0 index
                        context.read<HomeScreenProvider>().setNavigationIndex =
                            0;

                        /// set sign up provider to init
                        context.read<UserProvider>().setIsUserLoggedIn = false;
                        context.read<SignUpProvider>().refreshSignUpProvider();
                        pushRemoveUntil(
                          context: context,
                          widget: LoginScreen(isToNavigateHome: true),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteAccount extends StatelessWidget with NavigateHelper {
  const DeleteAccount({super.key,required this.uId});
  final String uId;
  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = context.watch<LoginProvider>();
    return Dialog(
      backgroundColor: AppColors.white,
      child: CustomContainer(
        padding: EdgeInsets.all(AppSize.size20),
        child: AnimationLimiter(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AnimationConfiguration.toStaggeredList(
              childAnimationBuilder:
                  (widget) => ScaleAnimation(
                    duration: Duration(milliseconds: 500),
                    child: FadeInAnimation(
                      duration: Duration(milliseconds: 500),
                      child: widget,
                    ),
                  ),
              children: [
                CustomText(
                  text: AppStrings.areYouSureWantToDeleteYourAccount,
                  useOverflow: false,
                  style: TextStyleHelper.mediumHeading.copyWith(
                    color: AppColors.error,
                  ),
                ),
                SizeHelper.height(),
                CustomText(
                  text: AppStrings.thisWillActionIsIrreversible,
                  useOverflow: false,
                  style: TextStyleHelper.smallText.copyWith(
                    color: AppColors.error,
                  ),
                ),
                SizeHelper.height(height: 5.h),
                loginProvider.isLoading
                    ? Center(child: CustomLoader())
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PrimaryBtn(
                          width: 30.w,
                          backGroundColor: AppColors.primary,
                          borderColor: AppColors.primary,
                          btnText: AppStrings.cancel,
                          textStyle: TextStyleHelper.smallHeading.copyWith(
                            color: AppColors.white,
                          ),
                          onTap: () => pop(context),
                        ),
                        PrimaryBtn(
                          borderColor: AppColors.error,
                          backGroundColor: AppColors.error,
                          width: 30.w,
                          btnText: AppStrings.logOut,
                          textStyle: TextStyleHelper.smallHeading.copyWith(
                            color: AppColors.white,
                          ),
                          onTap: () async {
                            loginProvider.deleteUser(
                              context: context,
                              uId: uId,
                            );
                          },
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
