import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/provider/user_provider/sign_up_provider.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_icons.dart';
import '../../../app_const/app_size.dart';
import '../../../app_const/app_strings.dart';
import '../../../utils/method_helpers/method_helper.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../utils/widget_helper/widget_helper.dart';

class SignUpScreen extends StatefulWidget {
  final bool isFromHomeScreen;
  final bool isRegisteredFromPanel;
  const SignUpScreen({
    super.key,
    this.isFromHomeScreen = false,
    this.isRegisteredFromPanel = false,
  });
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with NavigateHelper {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SignUpProvider signUpProvider = context.read<SignUpProvider>();
    UserProvider userProvider = context.read<UserProvider>();

    // if (signUpProvider.isUpdatingProfile) {
    Future.microtask(() async {
      userProvider.setCurrentSignupPageIndex = 0;
      await signUpProvider.initControllerWithLocalStorage(context: context);
    });
    // }
  }

  void _handleBackNavigation(BuildContext context) {
    // Access providers, assuming they are available in your widget's scope
    // For example, if you're using Provider:
    UserProvider userProvider = context.read<UserProvider>();
    SignUpProvider signUpProvider = context.read<SignUpProvider>();

    if (userProvider.currentSignUpPageIndex == 0) {
      if (widget.isFromHomeScreen) {
        WidgetHelper.customSnackBar(
          title: "Must Fill The Profile Details",
          isError: true,
          autoClose: false,
        );
        return;
      } else {
        pop(context);
      }
    } else {
      // Navigate to the previous page
      userProvider.setCurrentSignupPageIndex =
          userProvider.currentSignUpPageIndex - 1;
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    SignUpProvider signUpProvider = context.watch<SignUpProvider>();
    return PopScope(
      canPop:
          userProvider.currentSignUpPageIndex == 0 && !widget.isFromHomeScreen,
      onPopInvokedWithResult: (didPop, result) {
        signUpProvider.resetErrAllPage();
        if (!didPop) {
          _handleBackNavigation(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.xLightGrey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => _handleBackNavigation(context),
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
        bottomNavigationBar: SafeArea(
          child: CustomContainer(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            child:
                signUpProvider.isLoading
                    ? CustomContainer(
                      alignment: Alignment.center,
                      width: 90.w,
                      height: 5.h,
                      child: CustomLoader(),
                    )
                    : PrimaryBtn(
                      width: 90.w,
                      btnText:
                          userProvider.currentSignUpPageIndex ==
                                  userProvider.signUpSteps.length - 1
                              ? signUpProvider.isUpdatingProfile
                                  ? AppStrings.update
                                  : AppStrings.submit
                              : AppStrings.continue_,
                      onTap: () async {
                        // log(
                        //   "first ${signUpProvider.firstName.text} middle ${signUpProvider.middleName.text} last ${signUpProvider.lastName.text} birth ${signUpProvider.birthDate.text} convener ${signUpProvider.selectedConvener?.name} gender ${signUpProvider.genderQuestion.answer} image ${signUpProvider.signUpRequestModel.imageFile.length}",
                        // );
                        int currentPage = userProvider.currentSignUpPageIndex;

                        bool isValid = false;
                        switch (currentPage) {
                          case 0:
                            isValid = signUpProvider.validateFirstPage(context);
                            break;
                          case 1:
                            isValid = await signUpProvider.validateSecondPage(
                              context,
                            );
                            break;
                          case 2:
                            isValid = signUpProvider.validateThirdPage(context);
                            break;
                          // Add more cases for other pages
                        }

                        if (!isValid) return;
                        if (currentPage ==
                            userProvider.signUpSteps.length - 1) {
                          signUpProvider.buildSignUpRequestModel(
                            context: context,
                          );
                        }

                        if (currentPage <
                            (userProvider.signUpSteps.length - 1)) {
                          userProvider.setCurrentSignupPageIndex =
                              currentPage + 1;
                          pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
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
  Future<void> pickFiles({required SignUpProvider signUpProvider}) async {
    if (await Permission.storage.request().isGranted ||
        await Permission.mediaLibrary.request().isGranted) {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: widget.allowMultiple,
          type: FileType.custom,
          withData: true,
          allowedExtensions:
              widget.allowedExtensions ?? ["jpg", "pdf", "doc", "mp4"],
        );
        if (result == null) {
          signUpProvider.setProfilePicErr(AppStrings.noFilePicked);
          WidgetHelper.customSnackBar(
            title: AppStrings.noFilePicked,
            isError: true,
          );
        }
        if (result != null) {
          signUpProvider.setProfilePicErr(null);
          setState(() {
            /// do after pick up
            signUpProvider.signUpRequestModel.imageFile = result.files;
          });
        }
      } catch (e) {
        WidgetHelper.customSnackBar(title: e.toString(), isError: true);
      }
    } else {
      WidgetHelper.customSnackBar(
        autoClose: false,
        title: AppStrings.noPermissionFound,
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SignUpProvider signUpProvider = context.watch<SignUpProvider>();
    log("${AppStrings.assetsUrl}${signUpProvider.signUpRequestModel.images}");

    bool hasUploadedFiles =
        signUpProvider.signUpRequestModel.imageFile.isNotEmpty;

    return GestureDetector(
      onTap: () => pickFiles(signUpProvider: signUpProvider),
      child: Material(
        borderRadius: BorderRadius.circular(AppSize.size10),
        elevation: 1,
        color: Colors.transparent,
        child: CustomContainer(
          padding: EdgeInsets.all(2.h),
          width: 90.w,
          decoration: BoxDecoration(
            color: AppColors.lightWhite,
            borderRadius: BorderRadius.circular(AppSize.size10),
            border: Border.all(color: AppColors.grey.withOpacity(0.4)),
          ),
          child:
              signUpProvider.isUpdatingProfile && !hasUploadedFiles
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.size10),
                    child: CustomImageWithLoader(
                      icon: widget.icon,
                      imageUrl:
                          "${AppStrings.assetsUrl}${signUpProvider.signUpRequestModel.images}",
                      showImageInPanel: false,
                      fit: BoxFit.cover,
                    ),
                  )
                  : hasUploadedFiles
                  ? ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                        signUpProvider.signUpRequestModel.imageFile.length,
                    separatorBuilder: (_, __) => SizedBox(height: 1.h),
                    itemBuilder: (context, index) {
                      final file =
                          signUpProvider.signUpRequestModel.imageFile[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          leading: MethodHelper.buildFilePreview(file),
                          title: CustomText(
                            text: file.name,
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: CustomText(
                            text: '${(file.size / 1024).toStringAsFixed(2)} KB',
                          ),
                          trailing: IconButton(
                            icon: AppIcons.delete,
                            onPressed: () {
                              signUpProvider.signUpRequestModel.imageFile
                                  .removeWhere((e) => e.name == file.name);
                              setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                  )
                  : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        widget.icon ?? Icons.upload_file,
                        size: 40,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: 1.h),
                      CustomText(
                        text: "Tap to upload your file",
                        style: TextStyleHelper.smallText.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
