import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
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

class ReferralPage extends StatelessWidget {
  const ReferralPage({super.key});

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
            ReferralHeader(),
            SizedBox(height: 24),
            ReferralCodeCard(),
            SizedBox(height: 24),
            BenefitsList(),
            Spacer(),
            ShareButton(),
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
  const ReferralCodeCard({super.key});

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
        child: Column(
          children: [
            SelectableText(
              'CAREERCULTUREREFERCODE',
              style: TextStyleHelper.mediumHeading,
            ),
          ],
        ),
      ),
    );
  }
}

class BenefitsList extends StatelessWidget {
  BenefitsList({super.key});

  final List<BenefitItem> _items = [
    BenefitItem(
      icon: Icons.star,
      text: AppStrings.willGetThisMuchCoins(points: "100"),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          _items
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: BenefitTile(item: item),
                ),
              )
              .toList(),
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
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryBtn(
      width: 90.w,
      btnText: AppStrings.refer,
      onTap: () async {
        // Customize the message as you like:
        final message =
            'Hey! Use my referral code "100" to get ₹50 off on signup. '
            'Download the app here: https://yourapp.link';
        // SharePlus.share(message, subject: 'Join me on MyApp!');
        ShareResult refer = await SharePlus.instance.share(
          ShareParams(text: message, title: "title", subject: "subject"),
        );
        if (refer.status == ShareResultStatus.success) {
          WidgetHelper.customSnackBar(
            context: context,
            title: AppStrings.inviteRequestSent,
          );
        }
      },
    );
  }
}
