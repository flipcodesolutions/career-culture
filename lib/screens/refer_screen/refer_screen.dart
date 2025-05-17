import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_size.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart'; // For Clipboard

class ReferralPage extends StatelessWidget {
  const ReferralPage({
    super.key,
    required this.referCode,
    required this.points,
  });
  final String referCode;
  final String points;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.refer,
          style: TextStyleHelper.mediumHeading,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomContainer(
              width: 100.w,
              height: 30.h,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(AppImageStrings.referPage),
              ),
            ),
            ReferralHeader(),
            SizedBox(height: 24),
            ReferralCodeCard(referCode: referCode),
            SizedBox(height: 24),
            BenefitsList(points: points),
            Spacer(),
            ShareButton(referCode: referCode),
          ],
        ),
      ),
    );
  }
}

class ReferralHeader extends StatelessWidget {
  const ReferralHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppStrings.inviteFriends,
          style: TextStyleHelper.largeHeading.copyWith(
            color: AppColors.primary,
          ),
        ),
        SizedBox(height: 8),
        CustomText(
          text: AppStrings.earnRewards,
          style: TextStyleHelper.mediumHeading,
          useOverflow: false,
        ),
      ],
    );
  }
}

class ReferralCodeCard extends StatelessWidget {
  const ReferralCodeCard({super.key, required this.referCode});
  final String referCode;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      borderRadius: BorderRadius.circular(AppSize.size10),
      borderColor: AppColors.primary,
      borderWidth: 0.3,
      backGroundColor: AppColors.white,
      boxShadow: ShadowHelper.scoreContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: AppSize.size10,
          horizontal: AppSize.size20,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(text: referCode, style: TextStyleHelper.mediumHeading),
            SizeHelper.width(width: AppSize.size10),
            InkWell(
              onTap: () {
                Clipboard.setData(ClipboardData(text: referCode));
                WidgetHelper.customSnackBar(title: AppStrings.referCodeCopied);
              },
              child: Icon(Icons.copy, size: AppSize.size20),
            ),
          ],
        ),
      ),
    );
  }
}

class BenefitsList extends StatelessWidget {
  const BenefitsList({super.key, required this.points});
  final String points;
  @override
  Widget build(BuildContext context) {
    return BenefitTile(
      item: BenefitItem(
        icon: Icons.star,
        text: AppStrings.willGetThisMuchCoins(points: points),
      ),
    );
  }
}

class BenefitItem {
  final IconData icon;
  final String text;

  BenefitItem({required this.icon, required this.text});
}

class BenefitTile extends StatelessWidget {
  final BenefitItem item;

  const BenefitTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomContainer(
          padding: const EdgeInsets.all(AppSize.size10),
          backGroundColor: AppColors.white,
          borderColor: AppColors.primary,
          borderWidth: 0.5,
          boxShadow: ShadowHelper.scoreContainer,
          borderRadius: BorderRadius.circular(AppSize.size10),
          child: Icon(
            item.icon,
            size: AppSize.size20,
            color: AppColors.secondary,
          ),
        ),
        SizeHelper.width(width: 2.w),
        Expanded(
          child: CustomText(
            text: item.text,
            style: TextStyleHelper.mediumText,
            useOverflow: false,
          ),
        ),
      ],
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({super.key, required this.referCode});
  final String referCode;
  // final String points;
  @override
  Widget build(BuildContext context) {
    return PrimaryBtn(
      width: 90.w,
      btnText: AppStrings.refer,
      onTap: () async {
        // Customize the message as you like:
        final message =
            'Hey! Use my referral code "$referCode", And Join The Career Culture App To Change Your Life.';
        // SharePlus.share(message, subject: 'Join me on MyApp!');
        ShareResult refer = await SharePlus.instance.share(
          ShareParams(text: message, title: AppStrings.inviteFriends),
        );
        if (refer.status == ShareResultStatus.success) {
          WidgetHelper.customSnackBar(
            // context: context,
            title: AppStrings.inviteRequestSent,
          );
        }
      },
    );
  }
}
