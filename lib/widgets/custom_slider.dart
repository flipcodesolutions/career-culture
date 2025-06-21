import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/provider/home_screen_provider/home_screen_provider.dart';
import 'package:mindful_youth/screens/programs_screen/individual_program_screen.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_profile_pic_circle.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../models/programs/programs_model.dart';
import '../provider/programs_provider/programs_provider.dart';
import '../provider/user_provider/user_provider.dart';
import '../utils/navigation_helper/navigation_helper.dart';
import 'custom_container.dart';

class SliderRenderWidget extends StatefulWidget {
  const SliderRenderWidget({super.key});

  @override
  State<SliderRenderWidget> createState() => _SliderRenderWidgetState();
}

class _SliderRenderWidgetState extends State<SliderRenderWidget>
    with NavigateHelper {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    HomeScreenProvider homeScreenProvider = context.read<HomeScreenProvider>();
    Future.microtask(() {
      homeScreenProvider.getHomeScreenSlider(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    HomeScreenProvider homeScreenProvider = context.watch<HomeScreenProvider>();
    UserProvider userProvider = context.watch<UserProvider>();
    return homeScreenProvider.isLoading
        ? Center(child: CustomLoader())
        : homeScreenProvider.sliderModel?.data?.isNotEmpty == true
        ? CustomContainer(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            children: [
              InkWell(
                onTap: () => homeScreenProvider.setNavigationIndex = 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomText(
                      text: AppStrings.program,
                      style: TextStyleHelper.mediumHeading.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_right),
                  ],
                ),
              ),
              SizeHelper.height(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  homeScreenProvider.sliderModel?.data?.length ?? 0,
                  (index) => InkWell(
                    onTap: () {
                      if (userProvider.isUserLoggedIn) {
                        context.read<ProgramsProvider>().setCurrentProgramInfo =
                            homeScreenProvider.sliderModel?.data?.elementAt(
                              index,
                            ) ??
                            ProgramsInfo();
                        push(
                          context: context,
                          widget: IndividualProgramScreen(
                            programName:
                                homeScreenProvider.sliderModel?.data
                                    ?.elementAt(index)
                                    .title ??
                                "programScreen",
                          ),
                          transition: OpenUpwardsPageTransitionsBuilder(),
                        );
                      }
                    },
                    child: CustomContainer(
                      width: 28.w,
                      child: Column(
                        children: [
                          RoundImageInContainer(
                            photoLink:
                                homeScreenProvider.sliderModel?.data
                                    ?.elementAt(index)
                                    .image,
                          ),
                          SizeHelper.height(),
                          CustomText(
                            text:
                                homeScreenProvider.sliderModel?.data
                                    ?.elementAt(index)
                                    .title ??
                                "-",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
        : Center(child: SizedBox.shrink());
  }
}
