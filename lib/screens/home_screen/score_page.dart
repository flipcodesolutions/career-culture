import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_image.dart';
import 'package:mindful_youth/widgets/custom_score_with_animation.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
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

  // Dummy Data
  final List<Map<String, dynamic>> todayScores = [
    {'name': 'Alice', 'score': 950},
    {'name': 'Bob', 'score': 900},
    {'name': 'Charlie', 'score': 850},
    {'name': 'David', 'score': 800},
    {'name': 'Eve', 'score': 750},
    {'name': 'Frank', 'score': 720},
  ];

  final List<Map<String, dynamic>> weeklyScores = [
    {'name': 'Michael', 'score': 3500},
    {'name': 'Sarah', 'score': 3400},
    {'name': 'John', 'score': 3200},
    {'name': 'Anna', 'score': 3000},
    {'name': 'Steve', 'score': 2800},
  ];

  final List<Map<String, dynamic>> monthlyScores = [
    {'name': 'Max', 'score': 12000},
    {'name': 'Sophia', 'score': 11500},
    {'name': 'Liam', 'score': 11000},
    {'name': 'Emma', 'score': 10000},
    {'name': 'Oliver', 'score': 9500},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.scoreBoard,
          style: TextStyleHelper.mediumHeading,
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Today"),
            Tab(text: "Weekly"),
            Tab(text: "Monthly"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ScoreBoardPage(score: todayScores),
          ScoreBoardPage(score: weeklyScores),
          ScoreBoardPage(score: monthlyScores),
        ],
      ),
    );
  }
}

class ScoreBoardPage extends StatelessWidget {
  const ScoreBoardPage({super.key, required this.score});
  final List<Map<String, dynamic>> score;
  @override
  Widget build(BuildContext context) {
    if (score.length < 3) return Container();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TopPlayerCard(
                name: "Name",
                score: "10000",
                imageUrl: "https://picsum.photos/seed/picsum/536/354",
              ),
              TopPlayerCard(
                name: "Name",
                isFirst: true,
                score: "100000",
                imageUrl: "https://picsum.photos/seed/picsum/536/354",
              ),
              TopPlayerCard(
                name: "Name",
                score: "5000",
                imageUrl: "https://picsum.photos/seed/picsum/536/354",
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: score.length - 3,
            itemBuilder: (context, index) {
              final player = score[index + 3]; // Players after top 3
              return ListTile(
                leading: CircleAvatar(child: Text((index + 4).toString())),
                title: Text(player['name']),
                trailing: Text("${player['score']} pts"),
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
  });
  final String name;
  final bool isFirst;
  final String score;
  final String imageUrl;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      child: Column(
        children: [
          CustomContainer(
            padding: EdgeInsets.all(2),
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
                CustomText(text: name),
                CustomAnimatedScore(score: score),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
