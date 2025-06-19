import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/selfie_provider/selfie_provider.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_drop_down.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_strings.dart';
import '../../utils/method_helpers/image_picker_helper.dart';

class UploadSelfie extends StatefulWidget {
  const UploadSelfie({super.key});
  @override
  State<UploadSelfie> createState() => _UploadSelfieState();
}

class _UploadSelfieState extends State<UploadSelfie> with NavigateHelper {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final SelfieProvider selfieProvider = context.read<SelfieProvider>();
    Future.microtask(() async {
      await selfieProvider.getSelfieZone(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final SelfieProvider selfieProvider = context.watch<SelfieProvider>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          pop(context, result: true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(
            text: AppStrings.cherishAndInspire,
            style: TextStyleHelper.mediumHeading.copyWith(
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                selfieProvider.isLoading
                    ? Center(child: CustomLoader())
                    : CustomDropDownWidget<int?>(
                      hintText: AppStrings.selectQuestion,
                      dropdownMenuEntries: selfieProvider.dropdownMenuEntries(),
                      onSelected:
                          (dynamic questionId) => selfieProvider
                              .setSelectedQuestion(data: questionId as int?),
                    ),
                SizeHelper.height(height: 1.h),
                CustomContainer(
                  height: 25.h,
                  width: 90.w,
                  backGroundColor: AppColors.lightWhite,
                  borderRadius: BorderRadius.circular(AppSize.size10),
                  padding: EdgeInsets.all(AppSize.size10),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CustomContainer(
                          child:
                              selfieProvider.selectedImage != null
                                  ? Image.file(
                                    selfieProvider.selectedImage ?? File(""),
                                  )
                                  : Image.asset(
                                    AppImageStrings.uploadIcon,
                                    width: 20.w,
                                    height: 5.h,
                                  ),
                        ),
                      ),
                      SizeHelper.height(height: 1.h),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppSize.size10),
                          onTap:
                              () => ImagePickerHelper.showImagePicker(
                                context,
                                (image) async =>
                                    selfieProvider.setSelectedImage = image,
                              ),
                          child: CustomContainer(
                            alignment: Alignment.center,
                            borderRadius: BorderRadius.circular(AppSize.size10),
                            backGroundColor: AppColors.body2,
                            width: 87.w,
                            padding: EdgeInsets.symmetric(
                              horizontal: 5.w,
                              vertical: 1.h,
                            ),
                            child: CustomText(text: AppStrings.uploadSelfie),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizeHelper.height(height: 1.h),
                CustomContainer(
                  width: 90.w,
                  padding: EdgeInsets.all(AppSize.size10),
                  backGroundColor: AppColors.lightWhite,
                  borderRadius: BorderRadius.circular(AppSize.size10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: "Disclaimer :",
                        style: TextStyleHelper.smallHeading.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      SizeHelper.height(height: 1.h),
                      CustomText(
                        text:
                            "If Your Selfie gets Approved , It Will be Displayed In Wall Feed Posts, Please take note of this before you upload !!",
                        useOverflow: false,
                        style: TextStyleHelper.smallText.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: CustomContainer(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child:
              selfieProvider.isLoading
                  ? Center(child: CustomLoader())
                  : PrimaryBtn(
                    btnText: AppStrings.submit,
                    onTap: () {
                      if (formKey.currentState?.validate() == true) {
                        selfieProvider.uploadSelfie();
                      }
                    },
                  ),
        ),
      ),
    );
  }
}
