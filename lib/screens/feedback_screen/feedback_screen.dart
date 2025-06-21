import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/utils/border_helper/border_helper.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/method_helpers/shadow_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/method_helpers/validator_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/utils/widget_helper/widget_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text_form_field.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_colors.dart';
import '../../app_const/app_strings.dart';
import '../../models/feedback_model/feedback_model.dart';
import '../../provider/feedback_provider/feedback_provider.dart';
import '../../widgets/custom_text.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key, required this.model});
  final FeedbackModelPayload model;
  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> with NavigateHelper {
  // State variables for the rating and checkboxes
  int? _selectedRating; // Stores the index of the selected emoji rating
  String? goal;
  final TextEditingController _commentController = TextEditingController();

  // Map to hold emoji icons and their descriptions
  final List<Map<String, dynamic>> _ratings = [
    {'icon': '😠', 'description': 'Terrible'},
    {'icon': '😞', 'description': 'Bad'},
    {'icon': '😐', 'description': 'Neutral'},
    {'icon': '😮', 'description': 'Good'},
    {'icon': '🥰', 'description': 'Excellent'},
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FeedbackProvider feedbackProvider = context.watch<FeedbackProvider>();
    final FeedbackModelPayload model = widget.model;
    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(color: AppColors.lightWhite, width: 0.01),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomContainer(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: '💬', // Emoji icon
                    style: TextStyleHelper.mediumHeading,
                  ),
                  SizeHelper.width(),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          useOverflow: false,
                          text: 'We Care About Your Experience',
                          style: TextStyleHelper.mediumHeading.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        SizeHelper.height(height: 1.h),
                        CustomText(
                          useOverflow: false,
                          text:
                              'Please take a moment to share your thoughts about today\'s session.',
                          style: TextStyleHelper.smallText.copyWith(
                            color: AppColors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizeHelper.height(),

            // Counselor Information Card
            CustomContainer(
              borderRadius: BorderRadius.circular(AppSize.size10),
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
              boxShadow: ShadowHelper.scoreContainer,
              backGroundColor: AppColors.body2,
              child: Row(
                children: [
                  // Counselor Avatar/Icon
                  CircleAvatar(
                    radius: AppSize.size30,
                    backgroundColor: AppColors.lightWhite,
                    child: const Icon(
                      Icons.person_outline, // Placeholder for counselor avatar
                      size: AppSize.size30,
                      color: AppColors.darkBlue,
                    ),
                  ),
                  SizeHelper.width(width: 4.w),
                  // Counselor Details
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleWithInfo("Counselor:", model.counselingBy?.name),
                      titleWithInfo(
                        "Date:",
                        MethodHelper.convertToDisplayFormat(
                          inputDate: "${model.appointment?.appointmentDate}",
                        ),
                      ),
                      titleWithInfo("Time Slot:", model.appointment?.slot),
                    ],
                  ),
                ],
              ),
            ),
            SizeHelper.height(),

            // "How would you rate this session?" Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: CustomText(
                useOverflow: false,
                text: 'How would you rate this session?',
                style: TextStyleHelper.mediumHeading,
              ),
            ),
            SizeHelper.height(),
            // Emoji Rating Row
            CustomContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_ratings.length, (index) {
                  bool isSelected = _selectedRating == index;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedRating = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(50),
                    child: Column(
                      children: [
                        CustomContainer(
                          padding: const EdgeInsets.all(AppSize.size10),
                          shape: BoxShape.circle,
                          backGroundColor:
                              isSelected
                                  ? AppColors.lightWhite
                                  : Colors.transparent,
                          borderColor:
                              isSelected ? AppColors.black : Colors.transparent,
                          borderWidth: 0.3,
                          child: Text(
                            _ratings[index]['icon'],
                            style: TextStyleHelper.largeHeading,
                          ),
                        ),
                        if (isSelected) // Show description only for the selected emoji
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: CustomText(
                              text: _ratings[index]['description'],
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            SizeHelper.height(),

            // "Do this session helps you to move closer to your goal?" Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: CustomText(
                useOverflow: false,
                text: 'Do this session helps you to move closer to your goal?',
                style: TextStyleHelper.mediumHeading,
              ),
            ),
            // Checkbox options
            CustomContainer(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                children: [
                  CheckboxListTile(
                    title: CustomText(text: 'Yes'),
                    value: goal == "Yes",
                    onChanged: (bool? newValue) {
                      setState(() {
                        goal = "Yes";
                        // if (newValue) {
                        //   _helpsGoalNo = false;
                        //   _helpsGoalNotSure = false;
                        // }
                      });
                    },
                    controlAffinity:
                        ListTileControlAffinity.leading, // Checkbox on the left
                    contentPadding: EdgeInsets.zero, // Remove default padding
                    activeColor: Colors.orange, // Checkbox color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  CheckboxListTile(
                    title: const CustomText(text: 'No'),
                    value: goal == "No",
                    onChanged: (bool? newValue) {
                      setState(() {
                        goal = "No";
                        // if (newValue) {
                        //   _helpsGoalYes = false;
                        //   _helpsGoalNotSure = false;
                        // }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  CheckboxListTile(
                    title: const CustomText(text: 'Not sure yet'),
                    value: goal == "Not sure yet",
                    onChanged: (bool? newValue) {
                      setState(() {
                        goal = "Not sure yet";
                        // if (newValue) {
                        //   _helpsGoalYes = false;
                        //   _helpsGoalNo = false;
                        // }
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    activeColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
            SizeHelper.height(),

            // "Comment (Optional)" Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: CustomText(
                text: 'Comment (Optional)',
                style: TextStyleHelper.mediumHeading,
              ),
            ),
            SizeHelper.height(),
            CustomContainer(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: CustomTextFormField(
                controller: _commentController,
                maxLines: 5,
                minLines: 3,
                decoration: BorderHelper.containerLikeTextField(
                  hintText: "Enter Your Message Here...",
                ),
                validator:
                    (value) => ValidatorHelper.validateValue(value: value),
              ),
            ),
            SizeHelper.height(),
          ],
        ),
      ),
      bottomNavigationBar: CustomContainer(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
        child:
            feedbackProvider.isLoading
                ? Center(child: CustomLoader())
                : PrimaryBtn(
                  btnText: AppStrings.submit,
                  onTap: () async {
                    if (_selectedRating == null || goal == null) {
                      WidgetHelper.customSnackBar(
                        title:
                            "Must Provide Expression and Check one of the box",
                        isError: true,
                      );
                    } else {
                      final bool success = await feedbackProvider.feedback(
                        context: context,
                        mentorId: model.counselingBy?.id.toString() ?? "",
                        counselingDate:
                            model.appointment?.appointmentDate ?? "",
                        slotTime: model.appointment?.slot ?? "",
                        rating: _selectedRating.toString(),
                        goal: goal ?? "",
                        message: _commentController.text,
                      );

                      if (success) {
                        _selectedRating = null;
                        goal = null;
                        _commentController.text = "";
                        pop(context);
                      }
                    }
                  },
                ),
      ),
    );
  }

  Row titleWithInfo(String title, String? info) {
    return Row(
      children: [
        CustomText(text: '$title ', style: TextStyleHelper.smallHeading),
        CustomText(text: info ?? "Not Found"),
      ],
    );
  }
}
