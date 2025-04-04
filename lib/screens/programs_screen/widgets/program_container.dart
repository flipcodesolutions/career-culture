import 'package:flutter/material.dart';
import 'package:mindful_youth/provider/programs_provider/programs_provider.dart';
import 'package:mindful_youth/screens/programs_screen/individual_program_screen.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:provider/provider.dart';
import '../../../app_const/app_colors.dart';
import '../../../app_const/app_size.dart';
import '../../../app_const/app_strings.dart';
import '../../../models/programs/programs_model.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';

class ProgramContainer extends StatelessWidget with NavigateHelper {
  const ProgramContainer({super.key, required this.item});
  final ProgramsInfo item;
  @override
  Widget build(BuildContext context) {
    ProgramsProvider programsProvider = context.watch<ProgramsProvider>();
    return GestureDetector(
      onTap:
          () => {
            programsProvider.setCurrentProgramInfo = item,
            push(
              context: context,
              widget: IndividualProgramScreen(),
              transition: OpenUpwardsPageTransitionsBuilder(),
            ),
          },
      child: CustomContainer(
        backGroundColor: AppColors.cream,
        borderRadius: BorderRadius.circular(AppSize.size10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: CustomContainer(
                child: CustomLoaderImage(
                  imageUrl: "${AppStrings.assetsUrl}${item.image}",
                ),
              ),
            ),
            Expanded(
              child: CustomText(
                text: item.title ?? "",
                style: TextStyleHelper.smallHeading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
