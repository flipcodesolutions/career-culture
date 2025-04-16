import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_profile_avatar.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:sizer/sizer.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.account,
          style: TextStyleHelper.mediumHeading,
        ),
      ),
      body: AnimationLimiter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
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
                /// profile circle avatar
                CustomProfileAvatar(onImagePicked: (bytes) {}),
                SizeHelper.height(),

                /// profile btn
                ProfilePageListTiles(
                  leading: Icons.person,
                  onTap: () {},
                  titleText: AppStrings.profile,
                ),

                /// event history
                ProfilePageListTiles(
                  leading: Icons.event_note_rounded,
                  onTap: () {},
                  titleText: AppStrings.eventHistory,
                ),

                /// program history
                ProfilePageListTiles(
                  leading: Icons.event_sharp,
                  onTap: () {},
                  titleText: AppStrings.programsHistory,
                ),

                /// certificates
                ProfilePageListTiles(
                  leading: Icons.workspace_premium,
                  onTap: () {},
                  titleText: AppStrings.certificates,
                ),

                /// saved
                ProfilePageListTiles(
                  leading: Icons.folder_special,
                  onTap: () {},
                  titleText: AppStrings.saved,
                ),

                /// refer
                ProfilePageListTiles(
                  leading: Icons.share,
                  onTap: () {},
                  titleText: AppStrings.refer,
                ),

                /// delete account
                ProfilePageListTiles(
                  leading: Icons.delete_forever,
                  color: AppColors.error,
                  onTap: () {},
                  titleText: AppStrings.deleteAccount,
                ),

                /// delete account
                ProfilePageListTiles(
                  leading: Icons.logout,
                  color: AppColors.error,
                  onTap: () {},
                  titleText: AppStrings.logOut,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePageListTiles extends StatelessWidget {
  const ProfilePageListTiles({
    super.key,
    required this.titleText,
    required this.onTap,
    required this.leading,
    this.showTrailing = true,
    this.color,
  });
  final IconData leading;
  final bool showTrailing;
  final String titleText;
  final void Function()? onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      // shape: Border(bottom: BorderSide(color: AppColors.grey)),
      splashColor: color?.withOpacity(0.3),
      leading: CustomContainer(
        child: Icon(leading, color: color ?? AppColors.grey),
      ),
      title: CustomText(
        text: titleText,
        style: TextStyleHelper.smallHeading.copyWith(color: color),
      ),
      trailing:
          showTrailing
              ? Icon(Icons.keyboard_arrow_right, color: color ?? AppColors.grey)
              : null,
      onTap: () {},
    );
  }
}
