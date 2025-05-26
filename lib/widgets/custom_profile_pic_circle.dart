import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../app_const/app_colors.dart';
import '../app_const/app_size.dart';
import '../app_const/app_strings.dart';
import 'custom_container.dart';
import 'custom_image.dart';

class CustomUserProfilePicCircle extends StatelessWidget {
  const CustomUserProfilePicCircle({
    super.key,
    required this.isPhotoString,
    this.photoLink,
  });
  final bool isPhotoString;
  final String? photoLink;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      borderColor: AppColors.grey,
      borderWidth: 0.2,
      height: AppSize.size50,
      width: AppSize.size50,
      shape: BoxShape.circle,
      child:
          isPhotoString
              ? ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.size40),
                child: CustomImageWithLoader(
                  errorIconSize: AppSize.size30,
                  showImageInPanel: false,
                  fit: BoxFit.cover,
                  width: 15.w,
                  height: 8.h,
                  imageUrl: "${AppStrings.assetsUrl}$photoLink",
                ),
              )
              : Icon(
                Icons.star_rate_rounded,
                size: AppSize.size40,
                color: AppColors.secondary,
              ),
    );
  }
}
