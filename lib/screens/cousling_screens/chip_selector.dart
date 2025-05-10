// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:mindful_youth/app_const/app_colors.dart';
// import 'package:mindful_youth/app_const/app_size.dart';
// import 'package:mindful_youth/provider/counseling_provider/counseling_provider.dart';
// import 'package:mindful_youth/screens/cousling_screens/cousiling_form_screen.dart';
// import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
// import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
// import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
// import 'package:mindful_youth/widgets/custom_container.dart';
// import 'package:mindful_youth/widgets/primary_btn.dart';
// import 'package:provider/provider.dart';
// import 'package:sizer/sizer.dart';
// import '../../app_const/app_strings.dart';
// import '../../widgets/custom_text.dart';

// class ChipSelector extends StatefulWidget {
//   const ChipSelector({super.key});
//   @override
//   _ChipSelectorState createState() => _ChipSelectorState();
// }

// class _ChipSelectorState extends State<ChipSelector> with NavigateHelper {
//   @override
//   Widget build(BuildContext context) {
//     CounselingProvider counselingProvider = context.watch<CounselingProvider>();
//     return Scaffold(
//       appBar: AppBar(),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(horizontal: 5.w),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizeHelper.height(),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 5.w),
//               child: CustomText(
//                 useOverflow: false,
//                 text: AppStrings.whatWouldYouLikeToConcentrateOn,
//                 style: TextStyleHelper.largeHeading.copyWith(
//                   color: AppColors.primary,
//                 ),
//               ),
//             ),
//             SizeHelper.height(),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 5.w),
//               child: CustomText(text: AppStrings.youCanSelectMultipleOptions),
//             ),
//             if (counselingProvider.selectedTopics.isNotEmpty)
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 8.0),
//                     child: CustomText(
//                       text:
//                           "${counselingProvider.selectedTopics.length} Selected",
//                     ),
//                   ),
//                   SizeHelper.width(),
//                   InkWell(
//                     onTap: () => counselingProvider.emptySelectedTopics(),
//                     child: Icon(
//                       Icons.delete_forever_rounded,
//                       size: AppSize.size20,
//                       color: AppColors.error,
//                     ),
//                   ),
//                 ],
//               ),
//             SizeHelper.height(),
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 4.w),
//               child: AnimationLimiter(
//                 child: Wrap(
//                   spacing: AppSize.size10,
//                   runSpacing: AppSize.size10,
//                   children: AnimationConfiguration.toStaggeredList(
//                     childAnimationBuilder:
//                         (widget) => SlideAnimation(
//                           horizontalOffset: 30.w,
//                           duration: Duration(milliseconds: 500),
//                           child: FadeInAnimation(
//                             duration: Duration(milliseconds: 500),
//                             child: widget,
//                           ),
//                         ),
//                     children:
//                         counselingProvider.topics.map((topic) {
//                           final isSelected = counselingProvider.selectedTopics
//                               .contains(topic);
//                           return FilterChip(
//                             label: CustomText(text: topic),
//                             selected: isSelected,
//                             onSelected: (bool selected) {
//                               setState(() {
//                                 if (selected) {
//                                   counselingProvider.selectedTopics.add(topic);
//                                 } else {
//                                   counselingProvider.selectedTopics.remove(
//                                     topic,
//                                   );
//                                 }
//                               });
//                             },
//                             selectedColor: Colors.amber.shade700,
//                             backgroundColor: Colors.white,
//                             checkmarkColor: Colors.white,
//                             labelStyle: TextStyle(
//                               color: isSelected ? Colors.white : Colors.black,
//                               fontWeight: FontWeight.w500,
//                             ),
//                             shape: StadiumBorder(
//                               side: BorderSide(color: Colors.grey.shade300),
//                             ),
//                           );
//                         }).toList(),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: CustomContainer(
//         padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
//         child: PrimaryBtn(
//           btnText: AppStrings.continueTEXT,
//           onTap:
//               () => push(
//                 context: context,
//                 widget: CousilingFormScreen(),
//                 transition: FadeUpwardsPageTransitionsBuilder(),
//               ),
//         ),
//       ),
//     );
//   }
// }
