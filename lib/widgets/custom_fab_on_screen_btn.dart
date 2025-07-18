import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_image_strings.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/screens/selfie_zone_screens/selfie_zone_screens.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import '../app_const/app_svg.dart';

class CustomSpeedDial extends StatelessWidget with NavigateHelper {
  const CustomSpeedDial({super.key});
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      useRotationAnimation: true,
      icon: Icons.more_vert_outlined,
      activeIcon: Icons.close,
      backgroundColor: AppColors.secondary,
      foregroundColor: AppColors.white,
      overlayColor: Colors.black,
      overlayOpacity: 0.1,
      curve: Curves.linear,
      spacing: 10,
      spaceBetweenChildren: 8,
      buttonSize: const Size(56.0, 56.0),
      childrenButtonSize: const Size(50.0, 50.0),
      elevation: 8.0,
      shape: const CircleBorder(),

      // Prevent overlay from covering nav bar
      closeManually: false,

      children: [
        SpeedDialChild(
          child: Image.asset(
            AppImageStrings.giveUsCall,
            width: AppSize.size30,
            height: AppSize.size30,
          ),
          backgroundColor: AppColors.white,
          onTap: () => MethodHelper.makePhoneCall(),
        ),
        SpeedDialChild(
          child: CustomContainer(child: AppSvg.whatsAppLogo),
          backgroundColor: AppColors.white,
          onTap: () => MethodHelper.openWhatsApp(),
        ),
        SpeedDialChild(
          child: CustomContainer(
            child: Image.asset(
              AppImageStrings.selfieBtnIcon,
              width: AppSize.size30,
              height: AppSize.size30,
            ),
          ),
          backgroundColor: AppColors.white,
          onTap:
              () => push(
                context: context,
                widget: SelfieZoneScreen(),
                transition: FadeUpwardsPageTransitionsBuilder(),
              ),
        ),
      ],
    );
  }
}
