import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/user_provider/login_provider.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/screens/login/sign_up/sign_up.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/method_helpers/validator_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/custom_text_form_field.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';
import '../../provider/user_provider/sign_up_provider.dart';
import '../../utils/method_helpers/google_login_helper.dart';
import 'otp_screen/otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.isToNavigateHome = false});
  final bool isToNavigateHome;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with NavigateHelper {
  // final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isPassNotVisible = true;

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = context.watch<LoginProvider>();
    return Scaffold(
      body: SingleChildScrollView(
        child: AnimationLimiter(
          child: Form(
            key: formKey,
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: Duration(milliseconds: 350),
                childAnimationBuilder:
                    (widget) => SlideAnimation(
                      duration: Duration(milliseconds: 350),
                      horizontalOffset: 20.w,
                      child: FadeInAnimation(
                        duration: Duration(milliseconds: 350),
                        child: widget,
                      ),
                    ),
                children: [
                  CustomContainer(
                    padding: EdgeInsets.only(left: 5.w, right: 20.w),
                    alignment: Alignment.centerLeft,
                    height: 30.h,
                    width: 100.w,
                    backGroundColor: AppColors.primary,
                    child: CustomText(
                      useOverflow: false,
                      text: AppStrings.signInToYourAccount,
                      style: TextStyleHelper.largeText.copyWith(
                        color: AppColors.white,
                        fontSize: 23.sp,
                      ),
                    ),
                  ),
                  SizeHelper.height(height: 5.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: CustomTextFormField(
                      controller: loginProvider.mobileController,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      labelText: AppStrings.enterMobileNo,
                      validator:
                          (value) => ValidatorHelper.validateMobileNumber(
                            value: value,
                            context: context,
                          ),
                    ),
                  ),
                  // SizeHelper.height(height: 5.h),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 5.w),
                  //   child: CustomTextFormField(
                  //     controller: passwordController,
                  //     labelText: AppStrings.password,
                  //     obscureText: isPassNotVisible,
                  //     suffix: GestureDetector(
                  //       onTap: () {
                  //         setState(() {
                  //           isPassNotVisible = !isPassNotVisible;
                  //         });
                  //       },
                  //       child: Icon(
                  //         isPassNotVisible
                  //             ? Icons.visibility_off
                  //             : Icons.visibility,
                  //       ),
                  //     ),
                  //     validator:
                  //         (value) => ValidatorHelper.validateValue(
                  //           value: value,
                  //           context: context,
                  //         ),
                  //   ),
                  // ),
                  // SizeHelper.height(),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     CustomContainer(
                  //       padding: EdgeInsets.symmetric(horizontal: 5.w),
                  //       child: InkWell(
                  //         onTap:
                  //             () => push(
                  //               context: context,
                  //               widget: ForgotPasswordScreen(),
                  //               transition: OpenUpwardsPageTransitionsBuilder(),
                  //             ),
                  //         child: CustomText(text: AppStrings.forgetPassword),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizeHelper.height(height: 3.h),

                  CustomContainer(
                    child:
                        loginProvider.isLoading
                            ? Center(child: CustomLoader())
                            : PrimaryBtn(
                              width: 90.w,
                              textStyle: TextStyleHelper.mediumHeading,
                              btnText: AppStrings.login,
                              onTap: () async {
                                if (formKey.currentState?.validate() == true) {
                                  bool success = await loginProvider
                                      .sentOtpToMobileNumber();
                                  if (success) {
                                    push(
                                      context: context,
                                      widget: OtpScreen(
                                        isNavigateHome: widget.isToNavigateHome,
                                      ),
                                      transition:
                                          FadeForwardsPageTransitionsBuilder(),
                                    );
                                    // widget.isToNavigateHome
                                    //     ? pushRemoveUntil(
                                    //       context: context,
                                    //       widget: MainScreen(setIndex: 0),
                                    //     )
                                    //     : pop(context);
                                  }
                                }
                              },
                            ),
                  ),
                  SizeHelper.height(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomContainer(
                        width: 20.w,
                        child: Divider(color: AppColors.grey),
                      ),
                      CustomText(text: AppStrings.orLoginWith),
                      CustomContainer(
                        width: 20.w,
                        child: Divider(color: AppColors.grey),
                      ),
                    ],
                  ),
                  SizeHelper.height(height: 3.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SignInSocialOptions(
                          logo: AppImageStrings.googleLogo,
                          name: AppStrings.google,
                          onTap:
                              () => GoogleLoginHelper.signInWithGoogle(
                                context: context,
                              ),
                        ),
                        SizeHelper.width(width: 20.w),
                        SignInSocialOptions(
                          logo: AppImageStrings.facebookLogo,
                          name: AppStrings.facebook,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () {
                context.read<UserProvider>().setCurrentSignupPageIndex = 0;
                context.read<SignUpProvider>().setIsUpdatingProfile = false;
                push(
                  context: context,
                  widget: SignUpScreen(),
                  transition: OpenUpwardsPageTransitionsBuilder(),
                );
              },
              child: CustomText(text: AppStrings.dontHaveAccount),
            ),
            SizeHelper.height(height: 1.h),
            Divider(
              color: AppColors.primary,
              thickness: 3,
              endIndent: 30.w,
              indent: 30.w,
            ),
          ],
        ),
      ),
    );
  }
}

class SignInSocialOptions extends StatelessWidget {
  const SignInSocialOptions({
    super.key,
    required this.logo,
    required this.name,
    this.onTap,
  });
  final String logo;
  final String name;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        padding: EdgeInsets.all(AppSize.size10),
        borderWidth: 0.2,
        borderColor: AppColors.black,
        borderRadius: BorderRadius.circular(AppSize.size10),
        // boxShadow: ShadowHelper.scoreContainer,
        backGroundColor: AppColors.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              width: AppSize.size30,
              height: AppSize.size30,
              image: AssetImage(logo),
            ),
            // SizeHelper.width(),
            CustomText(text: name),
          ],
        ),
      ),
    );
  }
}
