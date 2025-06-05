import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:mindful_youth/provider/counseling_provider/counseling_provider.dart';
// import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/method_helpers/size_helper.dart';
import 'package:mindful_youth/utils/method_helpers/validator_helper.dart';
import 'package:mindful_youth/widgets/custom_refresh_indicator.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/custom_text_form_field.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_icons.dart';
import '../../app_const/app_strings.dart';
import '../../utils/text_style_helper/text_style_helper.dart';
import '../../widgets/custom_container.dart';
import '../../widgets/custom_drop_down.dart';

class CousilingFormScreen extends StatefulWidget {
  CousilingFormScreen({super.key});

  @override
  State<CousilingFormScreen> createState() => _CousilingFormScreenState();
}

class _CousilingFormScreenState extends State<CousilingFormScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() async {
      CounselingProvider counselingProvider =
          context.read<CounselingProvider>();
      Future.microtask(() async {
        await counselingProvider.getCounselignDatesAndSlots(context: context);
        counselingProvider.initControllerFromLocalStorage();
      });
    });
  }

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
      body: CustomRefreshIndicator(
        onRefresh:
            () async => await counselingProvider.getCounselignDatesAndSlots(
              context: context,
            ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: AnimationLimiter(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
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

                    /// student id
                    CustomTextFormField(
                      labelText: AppStrings.studentID,
                      // hintText: AppStrings.enterName,
                      maxLength: 100,
                      controller: counselingProvider.studentIdController,
                      enabled:
                          counselingProvider.studentIdController.text.isEmpty,
                      validator:
                          (value) => ValidatorHelper.validateValue(
                            value: value,
                            context: context,
                          ),
                    ),
                    SizeHelper.height(),

                    /// name
                    CustomTextFormField(
                      labelText: AppStrings.name,
                      // hintText: AppStrings.enterName,
                      maxLength: 100,
                      controller: counselingProvider.nameController,
                      enabled: counselingProvider.nameController.text.isEmpty,
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
                      // hintText: AppStrings.enterEmail,
                      maxLength: 100,
                      controller: counselingProvider.emailController,
                      enabled: counselingProvider.emailController.text.isEmpty,
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
                      // hintText: AppStrings.enterContact,
                      maxLength: 10,
                      controller: counselingProvider.contactController,
                      enabled:
                          counselingProvider.contactController.text.isEmpty,
                      validator:
                          (value) => ValidatorHelper.validateValue(
                            value: value,
                            context: context,
                          ),
                    ),
                    SizeHelper.height(),
                    CustomDropDownWidget<String>(
                      label: AppStrings.preferredModeOfCounseling,
                      hintText: AppStrings.selectMode,
                      dropdownMenuEntries: <DropdownMenuEntry<String>>[
                        DropdownMenuEntry<String>(
                          value: AppStrings.onlineMode,
                          label: AppStrings.onlineMode,
                        ),
                        DropdownMenuEntry<String>(
                          value: AppStrings.offlineMode,
                          label: AppStrings.offlineMode,
                        ),
                      ],
                      onSelected:
                          (dynamic pickedMode) =>
                              counselingProvider.selectModeForCounseling(
                                pickedMode: pickedMode as String,
                              ),
                    ),
                    SizeHelper.height(),
                    counselingProvider.isLoading
                        ? Center(child: CustomLoader())
                        : CustomDropDownWidget<String>(
                          label: AppStrings.dateAndTime,
                          hintText: AppStrings.selectDateForCounseling,
                          dropdownMenuEntries:
                              counselingProvider.getDatesForCounseling(),
                          onSelected:
                              (dynamic pickedDate) =>
                                  counselingProvider.selectDateForCounseling(
                                    pickedDate: pickedDate as String,
                                  ),
                        ),
                    SizeHelper.height(),
                    counselingProvider.isLoading
                        ? Center(child: CustomLoader())
                        : CustomDropDownWidget<String>(
                          label: AppStrings.availableSlots,
                          hintText: AppStrings.selectSlot,
                          onSelected:
                              (dynamic pickedSlot) =>
                                  counselingProvider.selectSlotForCounseling(
                                    pickedSlot: pickedSlot as String,
                                  ),
                          dropdownMenuEntries:
                              counselingProvider.getSlotsForCounseling(),
                          enabled: counselingProvider.isDatePicked,
                        ),
                    SizeHelper.height(),

                    // /// reason
                    // CustomTextFormField(
                    //   labelText: AppStrings.reasonForCounseling,
                    //   hintText: AppStrings.enterReason,
                    //   minLines: 5,
                    //   maxLines: 6,
                    //   maxLength: 500,
                    //   controller: TextEditingController(),
                    //   validator:
                    //       (value) => ValidatorHelper.validateValue(
                    //         value: value,
                    //         context: context,
                    //       ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        child: PrimaryBtn(
          btnText: AppStrings.submit,
          onTap:
              () => counselingProvider.createCounselingAppointment(
                context: context,
              ),
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
