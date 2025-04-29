import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:mindful_youth/provider/counseling_provider/counseling_provider.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/method_helpers/validator_helper.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/custom_text_form_field.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_icons.dart';
import '../../app_const/app_strings.dart';
import '../../utils/text_style_helper/text_style_helper.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_drop_down.dart';

class CousilingFormScreen extends StatelessWidget {
  CousilingFormScreen({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    CounselingProvider counselingProvider = context.watch<CounselingProvider>();
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppStrings.counselingAppointment,
          style: TextStyleHelper.mediumHeading,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: AnimationLimiter(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: AnimationConfiguration.toStaggeredList(
                childAnimationBuilder:
                    (widget) => SlideAnimation(
                      duration: Duration(milliseconds: 500),
                      horizontalOffset: 50.w,
                      child: FadeInAnimation(
                        duration: Duration(milliseconds: 500),
                        child: widget,
                      ),
                    ),
                children: [
                  SizeHelper.height(height: 3.h),

                  /// name
                  CustomTextFormField(
                    labelText: AppStrings.name,
                    hintText: AppStrings.enterName,
                    maxLength: 100,
                    controller: TextEditingController(),
                    validator:
                        (value) => ValidatorHelper.validateValue(
                          value: value,
                          context: context,
                        ),
                  ),
                  SizeHelper.height(),

                  /// email
                  CustomTextFormField(
                    labelText: AppStrings.email,
                    hintText: AppStrings.enterEmail,
                    maxLength: 100,
                    controller: TextEditingController(),
                    validator:
                        (value) => ValidatorHelper.validateEmail(
                          value: value,
                          context: context,
                        ),
                  ),
                  SizeHelper.height(),

                  /// email
                  CustomTextFormField(
                    labelText: AppStrings.contactNo,
                    hintText: AppStrings.enterContact,
                    maxLength: 10,
                    controller: TextEditingController(),
                    validator:
                        (value) => ValidatorHelper.validateValue(
                          value: value,
                          context: context,
                        ),
                  ),
                  SizeHelper.height(),
                  CustomTextFormField(
                    labelText: AppStrings.birthDate,
                    hintText: AppStrings.dateFormate,
                    maxLength: 10,
                    suffix: CustomContainer(
                      width: 10.w,
                      child: GestureDetector(
                        child: AppIcons.calender,
                        onTap: () async {
                          String s =
                              await MethodHelper.selectBirthDateByDatePicker(
                                context: context,
                              );
                        },
                      ),
                    ),
                    keyboardType: TextInputType.numberWithOptions(),
                    controller: TextEditingController(),
                    validator:
                        (value) => ValidatorHelper.validateDateFormate(
                          value: value,
                          context: context,
                        ),
                  ),
                  SizeHelper.height(),
                  DateTimePickerFormField(
                    hintText: AppStrings.dateAndTimeFormate,
                    labelText: AppStrings.dateAndTime,
                  ),
                  SizeHelper.height(),
                  CustomDropDownWidget(
                    label: AppStrings.preferredModeOfCounseling,
                    hintText: "Select Mode",
                  ),
                  SizeHelper.height(),

                  /// email
                  CustomTextFormField(
                    labelText: AppStrings.reasonForCounseling,
                    hintText: AppStrings.enterReason,
                    minLines: 5,
                    maxLines: 6,
                    maxLength: 500,
                    controller: TextEditingController(),
                    validator:
                        (value) => ValidatorHelper.validateValue(
                          value: value,
                          context: context,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: PrimaryBtn(
          btnText: AppStrings.submit,
          onTap: () {
            /// logic to
          },
        ),
      ),
    );
  }
}

class DateTimePickerFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  const DateTimePickerFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.controller,
    this.validator,
  });

  @override
  State<DateTimePickerFormField> createState() =>
      _DateTimePickerFormFieldState();
}

class _DateTimePickerFormFieldState extends State<DateTimePickerFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(
        DateTime.now().year,
        DateTime.now().month + 1,
        DateTime.now().day,
      ),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        final DateTime dateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        final formatted = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
        setState(() {
          _controller.text = formatted;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: _controller,
      validator: widget.validator,
      labelText: widget.labelText,
      hintText: widget.hintText,
      suffix: CustomContainer(
        width: 10.w,
        child: GestureDetector(
          child: AppIcons.calender,
          onTap: () => _selectDateTime(context),
        ),
      ),
    );
  }
}
