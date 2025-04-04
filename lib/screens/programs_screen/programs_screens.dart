import 'package:flutter/material.dart';
import 'package:mindful_youth/provider/programs_provider/programs_provider.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
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
                child: CustomGridWidget(
                  data: <ProgramsInfo>[
                    ...programsProvider.programsModel?.data ?? [],
                  ],
                  itemBuilder: (item, index) => ProgramContainer(item: item),
                  axisCount: 2,
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
