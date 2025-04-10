import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/method_helpers/validator_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/custom_text_form_field.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
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

class _SignUpScreenState extends State<SignUpScreen> with NavigateHelper {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed:
              () =>
                  userProvider.currentSignUpPageIndex == 0
                      ? pop(context)
                      : {
                        userProvider.setCurrentSignupPageIndex =
                            userProvider.currentSignUpPageIndex - 1,
                        pageController.previousPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                      },
          icon: AppIcons.backArrow,
        ),
        shape: Border(bottom: BorderSide(color: AppColors.white)),

        bottom: PreferredSize(
          preferredSize: Size(0, 0),
          child: CustomContainer(
            backGroundColor: AppColors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                userProvider.signUpSteps.length,
                (index) => Expanded(
                  child: CustomContainer(
                    margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                    backGroundColor:
                        index < userProvider.currentSignUpPageIndex
                            ? AppColors.primary
                            : AppColors.lightPrimary,
                    gradient:
                        index == userProvider.currentSignUpPageIndex
                            ? LinearGradient(
                              colors: [
                                AppColors.primary,
                                AppColors.lightPrimary,
                              ],
                            )
                            : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: PageView.builder(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        itemCount: userProvider.signUpSteps.length,
        itemBuilder: (context, index) => userProvider.signUpSteps[index],
      ),
      bottomNavigationBar: CustomContainer(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: PrimaryBtn(
          width: 90.w,
          btnText: AppStrings.continue_,
          onTap: () {
            if (userProvider.currentSignUpPageIndex <
                (userProvider.signUpSteps.length - 1)) {
              userProvider.setCurrentSignupPageIndex =
                  userProvider.currentSignUpPageIndex + 1;
              pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
            setState(() {});
          },
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
                        title: CustomText(text: file.name),
                        subtitle: CustomText(
                          text: '${(file.size / 1024).toStringAsFixed(2)} KB',
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            _selectedFiles.removeWhere(
                              (e) => e.name == file.name,
                            );
                            setState(() {});
                          },
                          child: AppIcons.delete,
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
