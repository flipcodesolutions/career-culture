import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/provider/programs_provider/programs_provider.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_strings.dart';
import '../../models/programs/programs_model.dart';
import '../../widgets/custom_grid.dart';
import 'widgets/program_container.dart';

class ProgramsScreens extends StatefulWidget {
  const ProgramsScreens({super.key});

  @override
  State<ProgramsScreens> createState() => _ProgramsScreensState();
}

class _ProgramsScreensState extends State<ProgramsScreens> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      ProgramsProvider programsProvider = context.read<ProgramsProvider>();
      programsProvider.getAllPrograms(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    ProgramsProvider programsProvider = context.watch<ProgramsProvider>();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.programs,
          style: TextStyleHelper.mediumHeading,
        ),
      ),
      body:
          programsProvider.isLoading
              ? Center(child: CustomLoader())
              : programsProvider.programsModel?.data?.isNotEmpty == true
              ? CustomRefreshIndicator(
                onRefresh:
                    () async =>
                        await programsProvider.getAllPrograms(context: context),
                child: Column(
                  children: [
                    CustomContainer(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 1.h,
                      ),
                      // backGroundColor: AppColors.error,
                      // height: 5.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PrimaryBtn(
                            width: 25.w,
                            height: 4.h,
                            // borderColor: ,
                            backGroundColor:
                                programsProvider.isGridView
                                    ? null
                                    : AppColors.white,
                            btnText: AppStrings.allTopics,
                            onTap:
                                () =>
                                    programsProvider.setGridView =
                                        !programsProvider.isGridView,
                          ),
                        ],
                      ),
                    ),
                    if (!programsProvider.isGridView) ...[
                      Expanded(
                        child: CustomGridWidget(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          data: <ProgramsInfo>[
                            ...programsProvider.programsModel?.data ?? [],
                          ],
                          itemBuilder:
                              (item, index) => ProgramContainer(item: item),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: CustomGridWidget(
                          padding: EdgeInsets.all(0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                          data: List.generate(24, (index) => ""),
                          itemBuilder:
                              (item, index) => CustomContainer(
                                backGroundColor:
                                    index.isEven
                                        ? AppColors.cream
                                        : AppColors.secondary,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            AppSize.size10,
                                          ),
                                          child: CustomImageWithLoader(
                                            width: 33.w,
                                            height: 12.h,
                                            imageUrl:
                                                "https://placehold.jp/150x150.png",
                                          ),
                                        ),
                                        CustomContainer(
                                          child: CustomText(
                                            text: "hihisdiii  isddnisi isib",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          axisCount: 2,
                        ),
                      ),
                    ],
                  ],
                ),
              )
              : CustomRefreshIndicator(
                onRefresh:
                    () async =>
                        await programsProvider.getAllPrograms(context: context),
                child: ListView(children: [NoDataFoundWidget(height: 80.h)]),
              ),
    );
  }
}
