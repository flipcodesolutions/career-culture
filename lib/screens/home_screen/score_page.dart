import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/models/score_model/score_board_model.dart';
import 'package:mindful_youth/provider/score_board_provider/score_board_provider.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_score_with_animation.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';

class ScoreboardPage extends StatefulWidget {
  const ScoreboardPage({super.key});

  @override
  State<ScoreboardPage> createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    Future.microtask(() {
      ScoreBoardProvider scoreBoardProvider =
          context.read<ScoreBoardProvider>();
      scoreBoardProvider.getScoreBoard(context: context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScoreBoardProvider scoreBoardProvider = context.watch<ScoreBoardProvider>();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.scoreBoard,
          style: TextStyleHelper.mediumHeading,
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: AppStrings.today),
            Tab(text: AppStrings.weekly),
            Tab(text: AppStrings.monthly),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ScoreBoardPage<Today>(
            score: scoreBoardProvider.scoreBoardModel?.data?.today,
          ),
          ScoreBoardPage<Weekly>(
            score: scoreBoardProvider.scoreBoardModel?.data?.weekly,
          ),
          ScoreBoardPage<Monthly>(
            score: scoreBoardProvider.scoreBoardModel?.data?.monthly,
          ),
        ],
      ),
    );
  }
}

class ScoreBoardPage<T extends ScorePlayer> extends StatelessWidget {
  const ScoreBoardPage({super.key, required this.score});
  final List<T>? score;
  @override
  Widget build(BuildContext context) {
    if ((score?.length ?? 0) < 3) {
      return CustomContainer(
        child: ListView(
          shrinkWrap: true,
          children: List.generate(
            score?.length ?? 0,
            (index) => TopPlayerCard(
              index: index.toString(),
              isListTile: true,
              name: score![0].name ?? '',
              isFirst: index == 0,
              score: score![0].totalPoints ?? '0',
              imageUrl: score![0].image ?? '',
            ),
          ),
        ),
      );
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TopPlayerCard(
                name: score![2].name ?? '',
                score: score![2].totalPoints ?? '0',
                imageUrl: score![2].image ?? '',
              ),
              TopPlayerCard(
                name: score![0].name ?? '',
                isFirst: true,
                score: score![0].totalPoints ?? '0',
                imageUrl: score![0].image ?? '',
              ),
              TopPlayerCard(
                name: score![1].name ?? '',
                score: score![1].totalPoints ?? '0',
                imageUrl: score![1].image ?? '',
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: (score?.length ?? 0) - 3,
            itemBuilder: (context, index) {
              final player = score?[index + 3]; // Players after top 3
              return ListTile(
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: (index + 4).toString(),
                      style: TextStyleHelper.smallHeading.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    SizeHelper.width(),
                    CustomImageWithLoader(
                      errorIconSize: AppSize.size20,
                      width: AppSize.size20,
                      height: AppSize.size20,
                      imageUrl: "${AppStrings.assetsUrl}${player?.image ?? ""}",
                    ),
                  ],
                ),
                title: CustomText(text: player?.name ?? ""),
                trailing: Text("${player?.totalPoints} pts"),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TopPlayerCard extends StatelessWidget {
  const TopPlayerCard({
    super.key,
    required this.name,
    this.isFirst = false,
    required this.score,
    required this.imageUrl,
    this.isListTile = false,
    this.index,
  });
  final String name;
  final bool isFirst;
  final String score;
  final String imageUrl;
  final bool isListTile;
  final String? index;
  @override
  Widget build(BuildContext context) {
    if (isListTile) {
      return ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: index ?? "",
              style: TextStyleHelper.smallHeading.copyWith(
                color: AppColors.primary,
              ),
            ),
            SizeHelper.width(),
            CustomImageWithLoader(
              errorIconSize: AppSize.size20,
              width: AppSize.size20,
              height: AppSize.size20,
              imageUrl: "https://picsum.photos/536/354",
            ),
          ],
        ),
        title: CustomText(text: name),
        trailing: Text("$score pts"),
      );
    }
    return CustomContainer(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          CustomContainer(
            padding: EdgeInsets.only(top: 0),
            borderWidth: 1,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSize.size50),
            ),
            borderColor: isFirst ? AppColors.primary : AppColors.secondary,
            child: Column(
              children: [
                CustomLoaderImage(
                  imageUrl: imageUrl,
                  radius: isFirst ? AppSize.size40 : AppSize.size30,
                ),
                SizeHelper.height(height: 1.h),
                CustomText(text: name, style: TextStyleHelper.smallHeading),
                CustomAnimatedScore(
                  score: score,
                  textStyle: TextStyleHelper.smallHeading,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
