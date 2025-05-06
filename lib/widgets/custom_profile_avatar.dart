import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:mindful_youth/provider/user_provider/user_provider.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_colors.dart';
import '../app_const/app_size.dart';
import '../app_const/app_strings.dart';
import '../provider/user_provider/sign_up_provider.dart';
import 'custom_container.dart';
import 'custom_image.dart';

class CustomProfileAvatar extends StatefulWidget {
  const CustomProfileAvatar({super.key});

  @override
  State<CustomProfileAvatar> createState() => _CustomProfileAvatarState();
}

class _CustomProfileAvatarState extends State<CustomProfileAvatar> {
  @override
  Widget build(BuildContext context) {
    SignUpProvider signUpProvider = context.watch<SignUpProvider>();
    UserProvider userProvider = context.watch<UserProvider>();
    log("${AppStrings.assetsUrl}${signUpProvider.signUpRequestModel.images}");
    return CustomContainer(
      height: 20.h,
      width: 100.w,
      child: Center(
        child:
            userProvider.isLoading
                ? CustomLoader()
                : Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomContainer(
                      width: AppSize.size100 + AppSize.size50,
                      height: AppSize.size100 + AppSize.size50,
                      shape: BoxShape.circle,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.size100),
                        child:
                            userProvider.imageBytes != null
                                ? GestureDetector(
                                  onTap:
                                      () => showDialog(
                                        context: context,
                                        builder:
                                            (context) => Dialog(
                                              child: InteractiveViewer(
                                                child: Image.memory(
                                                  userProvider.imageBytes ??
                                                      Uint8List(0),
                                                ),
                                              ),
                                            ),
                                      ),
                                  child: Image.memory(
                                    userProvider.imageBytes ?? Uint8List(0),
                                    fit: BoxFit.cover,
                                  ),
                                )
                                : CustomImageWithLoader(
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      (signUpProvider
                                                      .signUpRequestModel
                                                      .images ==
                                                  null ||
                                              signUpProvider
                                                      .signUpRequestModel
                                                      .images
                                                      ?.isEmpty ==
                                                  true)
                                          ? "https://img.freepik.com/free-vector/user-circles-set_78370-4704.jpg?t=st=1744778069~exp=1744781669~hmac=a88a2dbd6225ce1f2caf1382b814e2cf2f547172d909e75a5e8bc978d5d8ff03&w=826"
                                          : "${AppStrings.assetsUrl}${signUpProvider.signUpRequestModel.images}",
                                ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap:
                              () =>
                                  userProvider.isUpdating
                                      ? userProvider.uploadProfilePic(
                                        context: context,
                                      )
                                      : userProvider.showPickerOptions(context),
                          child: CustomContainer(
                            width: AppSize.size40,
                            height: AppSize.size40,
                            shape: BoxShape.circle,
                            backGroundColor: AppColors.white,
                            child: Icon(
                              userProvider.isUpdating
                                  ? Icons.done
                                  : Icons.camera_alt,
                              size: 20,
                              color:
                                  userProvider.isUpdating
                                      ? AppColors.primary
                                      : AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
