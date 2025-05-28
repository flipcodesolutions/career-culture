import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/models/score_model/score_board_model.dart';
import 'package:mindful_youth/provider/score_board_provider/score_board_provider.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/utils/user_screen_time/tracking_mixin.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_score_with_animation.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/no_data_found.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';

class ScoreboardPage extends StatefulWidget {
  const ScoreboardPage({super.key});

  @override
  State<ScoreboardPage> createState() => _ScoreboardPageState();
}

class _ScoreboardPageState extends State<ScoreboardPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver, ScreenTracker {
  late TabController _tabController;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  String get screenName => 'ScoreBoardScreen';
  @override
  bool get debug => false; // Enable debug logs
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    Future.microtask(() {
      ScoreBoardProvider scoreBoardProvider =
          context.read<ScoreBoardProvider>();
      scoreBoardProvider.getScoreBoard(context: context);
      _tabController.addListener(() {
        setState(() {});
      });
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
      bottomNavigationBar: createUserScoreByTab(
        tab: _tabController.index,
        scoreProvider: scoreBoardProvider,
      ),
    );
  }

  Widget? createUserScoreByTab({
    required int tab,
    required ScoreBoardProvider? scoreProvider,
  }) {
    ScoreBoardModel? userData = scoreProvider?.userScore;
    if (userData == null) return null;

    final List<ScorePlayer>? userList =
        {
          0: userData.data?.today,
          1: userData.data?.weekly,
          2: userData.data?.monthly,
        }[tab];

    if (userList?.isEmpty ?? true) return null;

    ScorePlayer player = userList!.first;
    return CustomContainer(
      backGroundColor: AppColors.lightWhite,
      child: TopPlayerCard(
        isListTile: true,
        name: player.name?.split(" ").first ?? "",
        score: player.totalPoints ?? "",
        imageUrl: "${AppStrings.assetsUrl}${player.image ?? ""}",
      ),
    );
  }
}

class ScoreBoardPage<T extends ScorePlayer> extends StatelessWidget {
  const ScoreBoardPage({super.key, required this.score});
  final List<T>? score;
  @override
  Widget build(BuildContext context) {
    if (score?.isEmpty == true) {
      return Center(child: NoDataFoundWidget(text: AppStrings.noScoresFound));
    }
    if ((score?.length ?? 0) < 3) {
      return CustomContainer(
        child: ListView(
          shrinkWrap: true,
          children: List.generate(
            score?.length ?? 0,
            (index) => TopPlayerCard(
              index: (index + 1).toString(),
              isListTile: true,
              name: score?[index].name?.split(" ").first ?? '',
              isFirst: index == 0,
              score: score?[index].totalPoints ?? '0',
              imageUrl: '${AppStrings.assetsUrl}${score?[index].image}',
            ),
          ),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TopPlayerCard(
                name: score![2].name?.split(" ").first ?? '',
                score: score![2].totalPoints ?? '0',
                imageUrl: '${AppStrings.assetsUrl}${score![2].image}',
              ),
              TopPlayerCard(
                name: score![0].name?.split(" ").first ?? '',
                isFirst: true,
                score: score![0].totalPoints ?? '0',
                imageUrl: '${AppStrings.assetsUrl}${score![0].image}',
              ),
              TopPlayerCard(
                name: score![1].name?.split(" ").first ?? '',
                score: score![1].totalPoints ?? '0',
                imageUrl: '${AppStrings.assetsUrl}${score![1].image}',
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
                leading: CircleAvatarForScoreLeading(
                  index: "${(index + 4)}",
                  imageUrl: player?.image ?? "",
                ),
                title: CustomText(text: player?.name?.split(" ").first ?? ""),
                trailing: CustomText(text: "${player?.totalPoints} Coins"),
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
        tileColor: AppColors.white,
        leading: CircleAvatarForScoreLeading(index: index, imageUrl: imageUrl),
        title: CustomText(text: name),
        trailing: CustomText(text: "$score Coins"),
      );
    }
    return CustomContainer(
      margin: EdgeInsets.symmetric(horizontal: 2.5.w),
      child: Column(
        children: [
          CustomContainer(
            padding: EdgeInsets.only(top: 0),
            width: isFirst ? 25.w : 20.w,
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

class CircleAvatarForScoreLeading extends StatelessWidget {
  const CircleAvatarForScoreLeading({
    super.key,
    this.index,
    required this.imageUrl,
  });

  final String? index;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: index ?? "",
          style: TextStyleHelper.smallHeading.copyWith(
            color: AppColors.primary,
          ),
        ),
        SizeHelper.width(),
        CustomContainer(
          shape: BoxShape.circle,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSize.size20),
            child: CustomImageWithLoader(
              errorIconSize: AppSize.size20,
              width: AppSize.size40,
              height: AppSize.size40,
              imageUrl: imageUrl,
            ),
          ),
        ),
      ],
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
