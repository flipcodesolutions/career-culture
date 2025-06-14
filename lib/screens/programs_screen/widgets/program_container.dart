import 'package:flutter/material.dart';
import 'package:mindful_youth/provider/programs_provider/programs_provider.dart';
import 'package:mindful_youth/screens/programs_screen/individual_program_screen.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
import '../../../app_const/app_size.dart';
import '../../../app_const/app_strings.dart';
import '../../../models/programs/programs_model.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';

class ProgramContainer extends StatelessWidget with NavigateHelper {
  const ProgramContainer({super.key, required this.item, this.gradient});
  final ProgramsInfo item;
  final Gradient? gradient;
  @override
  Widget build(BuildContext context) {
    ProgramsProvider programsProvider = context.watch<ProgramsProvider>();
    return GestureDetector(
      onTap:
          () => {
            programsProvider.setCurrentProgramInfo = item,
            push(
              context: context,
              widget: IndividualProgramScreen(
                programName: item.title ?? "ProgramScreen",
              ),
              transition: OpenUpwardsPageTransitionsBuilder(),
            ),
          },
      child: CustomContainer(
        boxShadow: ShadowHelper.scoreContainer,
        margin: EdgeInsets.only(bottom: 1.h),
        height: 10.h,
        backGroundColor: AppColors.lightWhite,
        borderRadius: BorderRadius.circular(AppSize.size10),
        gradient: gradient,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomContainer(
              height: 8.h,
              width: 17.w,
              margin: EdgeInsets.only(right: 5.w, left: 2.w),
              shape: BoxShape.circle,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.size40),
                child: CustomImageWithLoader(
                  fit: BoxFit.cover,
                  showImageInPanel: false,
                  imageUrl: "${AppStrings.assetsUrl}${item.image}",
                ),
              ),
            ),
            CustomText(
              text: item.title ?? "",
              style: TextStyleHelper.smallHeading,
            ),
          ],
        ),
      ),
    );
  }
}
