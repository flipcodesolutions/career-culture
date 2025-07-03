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
import 'package:timeline_tile/timeline_tile.dart';

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
      body: SafeArea(
        child: Column(
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
            SizeHelper.height(height: 4.h),
            ReferralTimeline(),
            SizeHelper.height(height: 3.h),
            CustomText(text: "Your Referral Code"),
            SizeHelper.height(),
            ReferralCodeCard(referCode: referCode),
            SizedBox(height: 2.h),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(child: ShareButton(referCode: referCode)),
    );
  }
}

class ReferralHeader extends StatelessWidget {
  const ReferralHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      borderColor: AppColors.black,
      borderWidth: 0.5,
      borderRadius: BorderRadius.circular(AppSize.size10),
      padding: EdgeInsets.all(AppSize.size10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomContainer(
            margin: EdgeInsets.only(right: 2.w),
            height: AppSize.size40,
            width: AppSize.size40,
            child: Image.asset(AppImageStrings.referCoinsIcon),
          ),
          Expanded(
            child: CustomText(
              text: AppStrings.inviteFriends,
              useOverflow: false,
              style: TextStyleHelper.smallHeading,
            ),
          ),
        ],
      ),
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
    return CustomContainer(
      height: 10.h,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ReferralTimeline(),
          TimelineTile(axis: TimelineAxis.horizontal),
          TimelineTile(axis: TimelineAxis.horizontal, isLast: true),
        ],
      ),
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({super.key, required this.referCode});
  final String referCode;
  // final String points;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      child: PrimaryBtn(
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
            WidgetHelper.customSnackBar(title: AppStrings.inviteRequestSent);
          }
        },
      ),
    );
  }
}

class ReferralTimeline extends StatelessWidget {
  const ReferralTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 4.5.w),
      height: 20.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_steps.length, (index) {
          final step = _steps[index];
          return Expanded(
            child: TimelineTile(
              axis: TimelineAxis.horizontal,
              alignment: TimelineAlign.start,
              isFirst: index == 0,
              isLast: index == _steps.length - 1,
              beforeLineStyle: LineStyle(color: Colors.teal, thickness: 2),
              afterLineStyle: LineStyle(color: Colors.teal, thickness: 2),
              indicatorStyle: IndicatorStyle(
                width: 20.w,
                height: 10.h,
                indicator: CustomContainer(
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CustomContainer(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.teal],
                        ),
                        shape: BoxShape.circle,
                        padding: const EdgeInsets.all(AppSize.size20),
                        child: step.icon,
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: CircleAvatar(
                          radius: AppSize.size10,
                          backgroundColor: Colors.red,
                          child: CustomText(
                            text: '${index + 1}',
                            style: TextStyleHelper.smallText.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              endChild: CustomContainer(
                width: 29.99.w,
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                child: CustomText(
                  text: step.label,
                  textAlign: TextAlign.center,
                  useOverflow: false,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

final _steps = [
  _StepData(
    label: 'Invite your friend\nby sharing code.',
    icon: Icon(Icons.people, color: Colors.white, size: 30),
  ),
  _StepData(
    label: 'Friend Install\nand signup.',
    icon: Icon(Icons.download, color: Colors.white, size: 30),
  ),
  _StepData(
    label: 'You  will get\nreward.',
    icon: Icon(Icons.card_giftcard, color: Colors.white, size: 30),
  ),
];

class _StepData {
  final String label;
  final Widget icon;

  _StepData({required this.label, required this.icon});
}
