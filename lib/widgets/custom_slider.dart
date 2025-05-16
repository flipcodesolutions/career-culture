import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_strings.dart';
import 'package:mindful_youth/provider/home_screen_provider/home_screen_provider.dart';
import 'package:mindful_youth/screens/programs_screen/individual_program_screen.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../provider/programs_provider/programs_provider.dart';
import '../provider/user_provider/user_provider.dart';
import '../utils/navigation_helper/navigation_helper.dart';
import 'custom_container.dart';
import 'custom_image.dart';

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
      homeScreenProvider.getHomeScreenSlider();
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
          child: CarouselSlider(
            items:
                homeScreenProvider.sliderModel?.data?.map((image) {
                  return GestureDetector(
                    onTap: () {
                      if (userProvider.isUserLoggedIn) {
                        context.read<ProgramsProvider>().setCurrentProgramInfo =
                            image;
                        push(
                          context: context,
                          widget: IndividualProgramScreen(
                            programName: image.title ?? "programScreen",
                          ),
                          transition: OpenUpwardsPageTransitionsBuilder(),
                        );
                      }
                    },
                    child: CustomContainer(
                      borderRadius: BorderRadius.circular(AppSize.size10),
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSize.size10),
                        child: CustomImageWithLoader(
                          showImageInPanel: false,
                          fit: BoxFit.cover,
                          imageUrl: "${AppStrings.assetsUrl}${image.image}",
                        ),
                      ),
                    ),
                  );
                }).toList(),
            options: CarouselOptions(
              enableInfiniteScroll: false,
              viewportFraction: 1,
              height: 25.h,
              disableCenter: true,
              autoPlay: true,
              padEnds: true,
            ),
          ),
        )
        : Center(child: NoDataFoundWidget(text: AppStrings.noProgramsFound));
  }
}
