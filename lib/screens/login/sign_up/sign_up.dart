import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/provider/user_provider/sign_up_provider.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_icons.dart';
import '../../../app_const/app_size.dart';
import '../../../app_const/app_strings.dart';
import '../../../utils/method_helpers/method_helper.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.isUpdateProfile});
  final bool isUpdateProfile;
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with NavigateHelper {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isUpdateProfile) {
      Future.microtask(() async {
        await context.read<SignUpProvider>().initControllerWithLocalStorage();
      });
    }
  }

  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = context.watch<UserProvider>();
    SignUpProvider signUpProvider = context.watch<SignUpProvider>();
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
                  btnText: AppStrings.continue_,
                  onTap: () async {
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
                    if (currentPage == userProvider.signUpSteps.length - 1) {
                      signUpProvider.buildSignUpRequestModel(context: context);
                    }

                    if (currentPage < (userProvider.signUpSteps.length - 1)) {
                      userProvider.setCurrentSignupPageIndex = currentPage + 1;
                      pageController.nextPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
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
  final String? oldPicUrl;
  const CustomFilePickerV2({
    super.key,
    this.allowMultiple = false,
    this.icon,
    this.allowedExtensions,
    this.oldPicUrl,
  });

  @override
  State<CustomFilePickerV2> createState() => _CustomFilePickerV2State();
}

class _CustomFilePickerV2State extends State<CustomFilePickerV2> {
  Future<void> pickFiles({required SignUpProvider signUpProvider}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: widget.allowMultiple,
      type: FileType.custom,
      withData: true,
      allowedExtensions:
          widget.allowedExtensions ?? ["jpg", "pdf", "doc", "mp4"],
    );

    if (result != null) {
      setState(() {
        /// do after pick up
        signUpProvider.signUpRequestModel.imageFile = result.files;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SignUpProvider signUpProvider = context.watch<SignUpProvider>();
    return GestureDetector(
      onTap: () => pickFiles(signUpProvider: signUpProvider),
      child:
          widget.oldPicUrl?.isNotEmpty == true &&
                      signUpProvider.signUpRequestModel.imageFile?.isEmpty ==
                          true ||
                  signUpProvider.signUpRequestModel.imageFile == null
              ? CustomImageWithLoader(imageUrl: "", showImageInPanel: false)
              : CustomContainer(
                alignment: Alignment.center,
                width: 90.w,
                height:
                    signUpProvider.signUpRequestModel.imageFile?.isEmpty ==
                                true ||
                            signUpProvider.signUpRequestModel.imageFile == null
                        ? 15.h
                        : null,
                borderRadius: BorderRadius.circular(AppSize.size10),
                backGroundColor: AppColors.lightWhite,
                child:
                    signUpProvider.signUpRequestModel.imageFile?.isNotEmpty ==
                            true
                        ? ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            ...signUpProvider.signUpRequestModel.imageFile?.map(
                                  (file) => ListTile(
                                    leading: MethodHelper.buildFilePreview(
                                      file,
                                    ),
                                    title: CustomText(text: file.name),
                                    subtitle: CustomText(
                                      text:
                                          '${(file.size / 1024).toStringAsFixed(2)} KB',
                                    ),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        signUpProvider
                                            .signUpRequestModel
                                            .imageFile
                                            ?.removeWhere(
                                              (e) => e.name == file.name,
                                            );
                                        setState(() {});
                                      },
                                      child: AppIcons.delete,
                                    ),
                                  ),
                                ) ??
                                [],
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
