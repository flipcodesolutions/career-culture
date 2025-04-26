import 'package:flutter/material.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
import '../../../app_const/app_size.dart';
import '../../../utils/method_helpers/shadow_helper.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_image.dart';
import '../../../widgets/custom_text.dart';

class ChapterProgressWidget extends StatelessWidget {
  const ChapterProgressWidget({
    super.key,
    required this.imageUrl,
    required this.chapter,
    required this.description,
    required this.progressPercent,
  });
  final String imageUrl;
  final String chapter;
  final String description;
  final double progressPercent;
  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 90.w,
      height: 15.h,
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      borderRadius: BorderRadius.circular(AppSize.size10),
      backGroundColor: AppColors.white,
      borderColor: AppColors.grey,
      borderWidth: 0.5,
      boxShadow: ShadowHelper.scoreContainer,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: CustomContainer(
              // padding: EdgeInsets.symmetric(horizontal: AppSize.size10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSize.size10),
                child: CustomImageWithLoader(imageUrl: imageUrl),
              ),
            ),
          ),
          SizeHelper.width(),
          Expanded(
            flex: 6,
            child: CustomContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: chapter,
                    style: TextStyleHelper.mediumHeading,
                  ),
                  CustomText(text: description),
                ],
              ),
            ),
          ),
          // Expanded(
          //   flex: 3,
          //   child: CustomContainer(
          //     child: AnimatedCircularProgress(
          //       percentage: progressPercent, // Pass the desired percentage
          //       size: AppSize.size100, // Size of the widget
          //       duration: Duration(seconds: 3), // Animation duration
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

///
class RecentActivityModel {
  String? imageUrl;
  String? chapter;
  String? description;
  int? progressPercent;

  RecentActivityModel({
    this.imageUrl,
    this.chapter,
    this.description,
    this.progressPercent,
  });

  RecentActivityModel.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    chapter = json['chapter'];
    description = json['description'];
    progressPercent = json['progressPercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageUrl'] = this.imageUrl;
    data['chapter'] = this.chapter;
    data['description'] = this.description;
    data['progressPercent'] = this.progressPercent;
    return data;
  }
}

// class RecentActivityStorage {
//   static const String _key = 'recent_activity';

//   static Future<void> saveRecentActivity(RecentActivityModel activity) async {
//     await SharedPrefs.saveString(_key, activity)
//     final jsonString = jsonEncode(activity.toJson());
//     await prefs.setString(_key, jsonString);
//   }

//   static Future<RecentActivityModel?> loadRecentActivity() async {
//     final prefs = await SharedPreferences.getInstance();
//     final jsonString = prefs.getString(_key);

//     if (jsonString == null) return null;

//     final jsonMap = jsonDecode(jsonString);
//     return RecentActivityModel.fromJson(jsonMap);
//   }
// }
