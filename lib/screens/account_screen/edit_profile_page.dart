import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/method_helpers/validator_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/custom_text_form_field.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:sizer/sizer.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    contactController.dispose();
    educationController.dispose();
    addressController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.editAccount,
          style: TextStyleHelper.mediumHeading,
        ),
      ),
      body: AnimationLimiter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
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
                SizeHelper.height(),
                CustomTextFormField(
                  labelText: AppStrings.name,
                  controller: nameController,
                  validator:
                      (value) => ValidatorHelper.validateValue(value: value),
                ),
                SizeHelper.height(),
                CustomTextFormField(
                  labelText: AppStrings.email,
                  controller: emailController,
                  validator:
                      (value) => ValidatorHelper.validateEmail(value: value),
                ),
                SizeHelper.height(),
                CustomTextFormField(
                  labelText: AppStrings.contactNo,
                  controller: contactController,
                  validator:
                      (value) => ValidatorHelper.validateValue(value: value),
                ),
                SizeHelper.height(),
                CustomTextFormField(
                  labelText: AppStrings.educationalDetails,
                  controller: educationController,
                  validator:
                      (value) => ValidatorHelper.validateValue(value: value),
                ),
                SizeHelper.height(),
                CustomTextFormField(
                  labelText: AppStrings.address,
                  controller: addressController,
                  validator:
                      (value) => ValidatorHelper.validateValue(value: value),
                ),
                SizeHelper.height(height: 5.h),
                PrimaryBtn(
                  width: 90.w,
                  btnText: AppStrings.submit,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
