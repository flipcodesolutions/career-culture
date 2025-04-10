import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/method_helpers/validator_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/custom_text_form_field.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_icons.dart';
import '../../../app_const/app_size.dart';
import '../../../app_const/app_strings.dart';
import '../../../utils/method_helpers/method_helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  List<Widget> signUpSteps = [
    CustomContainer(
      child: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            children: AnimationConfiguration.toStaggeredList(
              childAnimationBuilder:
                  (widget) => SlideAnimation(
                    duration: Duration(milliseconds: 500),
                    child: FadeInAnimation(
                      duration: Duration(milliseconds: 500),
                      child: widget,
                    ),
                  ),
              children: [
                SizeHelper.height(height: 5.h),
                CustomText(
                  text: AppStrings.startYourJourney,
                  style: TextStyleHelper.largeHeading,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: Border(bottom: BorderSide(color: AppColors.white)),
        bottom: PreferredSize(
          preferredSize: Size(0, 0),
          child: CustomContainer(
            backGroundColor: AppColors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Expanded(
                  child: CustomContainer(
                    margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.lightPrimary],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: PageView.builder(
        itemCount: signUpSteps.length,
        itemBuilder:
            (context, index) => CustomContainer(
              child: SingleChildScrollView(
                child: AnimationLimiter(
                  child: Column(
                    children: AnimationConfiguration.toStaggeredList(
                      childAnimationBuilder:
                          (widget) => SlideAnimation(
                            duration: Duration(milliseconds: 500),
                            child: FadeInAnimation(
                              duration: Duration(milliseconds: 500),
                              child: widget,
                            ),
                          ),
                      children: [
                        SizeHelper.height(height: 5.h),
                        CustomText(
                          text: AppStrings.startYourJourney,
                          style: TextStyleHelper.largeHeading,
                        ),
                        SizeHelper.height(height: 3.h),
                        CustomText(
                          text: AppStrings.createAnAccountToJoinUS,
                          style: TextStyleHelper.smallText,
                        ),
                        SizeHelper.height(height: 5.h),
                        CustomContainer(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: CustomTextFormField(
                            labelText: AppStrings.name,
                            controller: TextEditingController(),
                            validator:
                                (value) => ValidatorHelper.validateValue(
                                  value: value,
                                  context: context,
                                ),
                          ),
                        ),
                        SizeHelper.height(),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.w),
                              child: CustomText(text: AppStrings.uploadPhoto),
                            ),
                          ],
                        ),
                        SizeHelper.height(),
                        CustomFilePickerV2(
                          allowMultiple: true,
                          allowedExtensions: ["jpg", "png", "jpeg"],
                          icon: AppIconsData.audio,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }
}

class CustomFilePickerV2 extends StatefulWidget {
  final bool allowMultiple;
  final IconData? icon;
  final List<String>? allowedExtensions;
  const CustomFilePickerV2({
    super.key,
    this.allowMultiple = false,
    this.icon,
    this.allowedExtensions,
  });

  @override
  State<CustomFilePickerV2> createState() => _CustomFilePickerV2State();
}

class _CustomFilePickerV2State extends State<CustomFilePickerV2> {
  List<PlatformFile> _selectedFiles = [];

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: widget.allowMultiple,
      type: FileType.custom,
      withData: true,
      allowedExtensions:
          widget.allowedExtensions ?? ["jpg", "pdf", "doc", "mp4"],
    );

    if (result != null) {
      setState(() {
        _selectedFiles = result.files;
      });

      /// do after pick up
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => pickFiles(),
      child: CustomContainer(
        alignment: Alignment.center,
        width: 90.w,
        height: _selectedFiles.isEmpty ? 15.h : null,
        borderRadius: BorderRadius.circular(AppSize.size10),
        backGroundColor: AppColors.lightWhite,
        child:
            _selectedFiles.isNotEmpty
                ? ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    ..._selectedFiles.map(
                      (file) => ListTile(
                        leading: MethodHelper.buildFilePreview(file),
                        title: Text(file.name),
                        subtitle: Text(
                          '${(file.size / 1024).toStringAsFixed(2)} KB',
                        ),
                      ),
                    ),
                  ],
                )
                : Icon(
                  widget.icon ?? Icons.add,
                  size: AppSize.size30,
                  color: AppColors.primary,
                ),
      ),
    );
  }
}
