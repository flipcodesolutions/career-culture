import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/provider/user_provider/sign_up_provider.dart';
import 'package:mindful_youth/utils/border_helper/border_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_drop_down.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
import '../../../app_const/app_strings.dart';
import '../../../utils/method_helpers/validator_helper.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../../../widgets/new_custom_text_field.dart';

class ShareContactDetails extends StatefulWidget {
  const ShareContactDetails({super.key});

  @override
  State<ShareContactDetails> createState() => _ShareContactDetailsState();
}

class _ShareContactDetailsState extends State<ShareContactDetails>
    with NavigateHelper {
  @override
  Widget build(BuildContext context) {
    SignUpProvider signUpProvider = context.watch<SignUpProvider>();
    return PopScope(
      canPop: false,
      child: CustomContainer(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                childAnimationBuilder:
                    (widget) => SlideAnimation(
                      horizontalOffset: 30.w,
                      duration: Duration(milliseconds: 500),
                      child: FadeInAnimation(
                        duration: Duration(milliseconds: 500),
                        child: widget,
                      ),
                    ),
                children: [
                  if (!signUpProvider.isUpdatingProfile) ...[
                    SizeHelper.height(height: 5.h),

                    CustomText(
                      text: AppStrings.shareContactDetails,
                      style: TextStyleHelper.largeHeading,
                    ),
                    SizeHelper.height(height: 3.h),
                    CustomText(
                      text: AppStrings.shareContactDetailsToContinue,
                      style: TextStyleHelper.smallText,
                    ),
                  ] else ...[
                    SizeHelper.height(height: 5.h),
                    CustomText(
                      text: AppStrings.contactDetails,
                      style: TextStyleHelper.largeHeading,
                    ),
                  ],
                  SizeHelper.height(height: 5.h),
                  CustomFormFieldContainer(
                    errorText: signUpProvider.isEmailErr,
                    label: AppStrings.email,
                    icon: Icons.email,
                    child: CustomTextFieldWithAnimatedIconForVerification(
                      enabled: !signUpProvider.isEmailVerified,
                      onChanged: (value) => signUpProvider.validateEmail(),
                      decoration: BorderHelper.noBorder(
                        hintText: AppStrings.email,
                      ),
                      controller: signUpProvider.email,
                    ),
                  ),
                  SizeHelper.height(),
                  CustomFormFieldContainer(
                    errorText: signUpProvider.isContactNo1Err,
                    label: AppStrings.contactNo1,
                    icon: Icons.phone_android_outlined,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 6,
                          child: CustomTextFieldWithAnimatedIconForVerification(
                            maxLength: 10,
                            decoration: BorderHelper.noBorder(
                              hintText: AppStrings.contactNo1,
                            ),
                            enabled: !signUpProvider.isContactNo1Verified,
                            onChanged:
                                (value) => signUpProvider.validateContactNo1(),
                            keyboard: TextInputType.number,
                            controller: signUpProvider.contactNo1,
                          ),
                        ),
                        Expanded(
                          child: verificationBadge(
                            signUpProvider.isContactNo1Verified,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizeHelper.height(),
                  CustomFormFieldContainer(
                    errorText: signUpProvider.isContactNo2Err,
                    label: AppStrings.contactNo2,
                    icon: Icons.phone,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: CustomTextFieldWithAnimatedIconForVerification(
                            decoration: BorderHelper.noBorder(
                              hintText: AppStrings.contactNo2,
                            ),
                            maxLength: 10,
                            onChanged:
                                (value) =>
                                    signUpProvider.validateContactNo2(),
                                       
                            enabled:
                                signUpProvider.contactNo2.text.isEmpty ||
                                !signUpProvider.isContactNo2Verified,
                            label: AppStrings.contactNo2,
                            keyboard: TextInputType.number,
                            controller: signUpProvider.contactNo2,
                          ),
                        ),
                        Expanded(
                          child: verificationBadge(
                            signUpProvider.isContactNo2Verified,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizeHelper.height(),
                  CustomFormFieldContainer(
                    label: AppStrings.address1,
                    errorText: signUpProvider.isAddressL1Err,
                    icon: Icons.place,
                    child: CustomTextFormField(
                      decoration: BorderHelper.noBorder(
                        hintText: AppStrings.address1,
                      ),
                      controller: signUpProvider.address1,
                      onChanged: (value) => signUpProvider.validateAddressL1(),
                    ),
                  ),
                  SizeHelper.height(),
                  CustomFormFieldContainer(
                    label: AppStrings.address2,
                    errorText: signUpProvider.isAddressL2Err,
                    icon: Icons.place,
                    child: CustomTextFormField(
                      decoration: BorderHelper.noBorder(
                        hintText: AppStrings.address2,
                      ),
                      controller: signUpProvider.address2,
                      // onChanged:
                      //     (value) =>
                      //         value.trim().isNotEmpty
                      //             ? signUpProvider.validateAddressL2()
                      //             : null,
                    ),
                  ),
                  SizeHelper.height(),
                  CustomFormFieldContainer(
                    errorText: signUpProvider.isStateErr,
                    label: AppStrings.state,
                    icon: Icons.place,
                    child: CustomDropDownWidget<String>(
                      decoration: BorderHelper.noBorderDropDown(),
                      initialSelection: signUpProvider.state,
                      dropdownMenuEntries: signUpProvider.availableStates(),
                      onSelected:
                          (dynamic stateSelected) => signUpProvider.selectState(
                            stateSelected: stateSelected as String,
                          ),
                    ),
                  ),
                  SizeHelper.height(),
                  signUpProvider.cityLoader
                      ? Center(child: CustomLoader())
                      : CustomFormFieldContainer(
                        errorText: signUpProvider.isDistrictErr,
                        label: AppStrings.district,
                        icon: Icons.place,
                        child: CustomDropDownWidget<String>(
                          initialSelection: signUpProvider.city,
                          decoration: BorderHelper.noBorderDropDown(),
                          onSelected:
                              (dynamic citySelected) =>
                                  signUpProvider.selectCity(
                                    citySelected: citySelected as String,
                                  ),
                          dropdownMenuEntries: signUpProvider.availableCity(),
                        ),
                      ),
                  SizeHelper.height(),
                  CustomFormFieldContainer(
                    errorText: signUpProvider.isCityErr,
                    icon: Icons.place,
                    label: AppStrings.city,
                    child: CustomTextFormField(
                      decoration: BorderHelper.noBorder(
                        hintText: AppStrings.city,
                      ),
                      labelText: AppStrings.city,
                      controller: signUpProvider.district,
                      onChanged: (value) => signUpProvider.validateCity(),
                    ),
                  ),
                  SizeHelper.height(),

                  /// hiding country field for now
                  // CustomContainer(
                  //   padding: EdgeInsets.symmetric(horizontal: 5.w),
                  //   child: CustomTextFormField(
                  //     labelText: AppStrings.country,
                  //     controller: signUpProvider.country,
                  //     validator:
                  //         (value) => ValidatorHelper.validateValue(
                  //           value: value,
                  //           context: context,
                  //         ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFieldWithAnimatedIconForVerification extends StatelessWidget {
  const CustomTextFieldWithAnimatedIconForVerification({
    super.key,
    this.label,
    this.validator,
    required this.controller,
    this.onTap,
    this.maxLength = 100,
    this.keyboard,
    this.enabled = true,
    this.decoration,
    this.onChanged,
  });
  final TextEditingController? controller;
  final String? label;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final int? maxLength;
  final TextInputType? keyboard;
  final bool enabled;
  final InputDecoration? decoration;
  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      decoration: decoration,
      enabled: enabled,
      labelText: label,
      keyboardType: keyboard,
      maxLength: maxLength,
      onChanged: onChanged,
      controller: controller,
      // validator:
      //     validator ?? (value) => ValidatorHelper.validateValue(value: value),
      // suffix: GestureDetector(
      //   onTap: onTap,
      //   child: ,
      // ),
    );
  }
}

Widget verificationBadge(bool isVerified) {
  return CustomContainer(
    // width: 10.w,
    alignment: Alignment.center,
    child: AnimatedCrossFade(
      firstChild: Icon(Icons.verified_outlined, color: AppColors.grey),
      secondChild: Icon(Icons.verified, color: AppColors.primary),
      crossFadeState:
          isVerified ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 500),
    ),
  );
}
