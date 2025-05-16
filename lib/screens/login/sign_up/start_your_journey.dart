import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mindful_youth/models/login_model/convener_list_model.dart';
import 'package:mindful_youth/provider/user_provider/sign_up_provider.dart';
import 'package:mindful_youth/widgets/cutom_loader.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../app_const/app_colors.dart';
import '../../../app_const/app_icons.dart';
import '../../../app_const/app_size.dart';
import '../../../app_const/app_strings.dart';
import '../../../utils/method_helpers/size_helper.dart';
import '../../../utils/method_helpers/validator_helper.dart';
import '../../../utils/text_style_helper/text_style_helper.dart';
import '../../../widgets/custom_container.dart';
import '../../../widgets/custom_radio_question_widget_wtih_heading.dart';
import '../../../widgets/custom_searchable_drop_down.dart';
import '../../../widgets/custom_text.dart';
import '../../../widgets/custom_text_form_field.dart';
import 'sign_up.dart';

class StartYourJourney extends StatefulWidget {
  const StartYourJourney({super.key});

  @override
  State<StartYourJourney> createState() => _StartYourJourneyState();
}

class _StartYourJourneyState extends State<StartYourJourney> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      SignUpProvider signUpProvider = context.read<SignUpProvider>();
    Future.microtask(() {
      signUpProvider.getConveners();
    });
  }

  @override
  Widget build(BuildContext context) {
    SignUpProvider signUpProvider = context.watch<SignUpProvider>();
    // UserProvider userProvider = context.watch<UserProvider>();
    return CustomContainer(
      child: SingleChildScrollView(
        child: AnimationLimiter(
          child: Form(
            key: signUpProvider.firstPageFormKey,
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                childAnimationBuilder:
                    (widget) => SlideAnimation(
                      horizontalOffset: 30.w,
                      duration: Duration(milliseconds: 500),
                      child: FadeInAnimation(
                        duration: Duration(milliseconds: 500),
                        child: widget,
                      ),
                    ),
                children: [
                  SizeHelper.height(height: 5.h),
                  CustomText(
                    text:
                        signUpProvider.isUpdatingProfile
                            ? AppStrings.updateYourInfo
                            : AppStrings.startYourJourney,
                    style: TextStyleHelper.largeHeading,
                  ),
                  SizeHelper.height(height: 3.h),
                  CustomText(
                    text:
                        signUpProvider.isUpdatingProfile
                            ? AppStrings.onlyChangeWhatYouMust
                            : AppStrings.createAnAccountToJoinUS,
                    style: TextStyleHelper.smallText,
                  ),
                  SizeHelper.height(height: 5.h),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: CustomTextFormField(
                      labelText: AppStrings.firstName,
                      controller: signUpProvider.firstName,
                      validator:
                          (value) => ValidatorHelper.validateValue(
                            value: value,
                            context: context,
                          ),
                    ),
                  ),
                  SizeHelper.height(),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: CustomTextFormField(
                      labelText: AppStrings.middleName,
                      controller: signUpProvider.middleName,
                      validator:
                          (value) => ValidatorHelper.validateValue(
                            value: value,
                            context: context,
                          ),
                    ),
                  ),
                  SizeHelper.height(),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: CustomTextFormField(
                      labelText: AppStrings.lastName,
                      controller: signUpProvider.lastName,
                      validator:
                          (value) => ValidatorHelper.validateValue(
                            value: value,
                            context: context,
                          ),
                    ),
                  ),
                  SizeHelper.height(),
                  CustomContainer(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: CustomTextFormField(
                      labelText: AppStrings.birthDate,
                      hintText: AppStrings.dateFormate,
                      maxLength: 10,
                      suffix: CustomContainer(
                        width: 10.w,
                        child: GestureDetector(
                          child: AppIcons.calender,
                          onTap:
                              () => signUpProvider.selectBirthDateByDatePicker(
                                context: context,
                              ),
                        ),
                      ),
                      keyboardType: TextInputType.numberWithOptions(),
                      controller: signUpProvider.birthDate,
                      validator:
                          (value) => ValidatorHelper.validateDateFormate(
                            value: value,
                            context: context,
                          ),
                    ),
                  ),
                  SizeHelper.height(),

                  /// searchable convener drop down
                  if (!signUpProvider.isUpdatingProfile)
                    CustomContainer(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child:
                          signUpProvider.isLoading
                              ? Center(child: CustomLoader())
                              : ConvenerDropDown(
                                signUpProvider: signUpProvider,
                              ),
                    ),
                  SizeHelper.height(),
                  RadioQuestionWidgetWithHeading(
                    question: signUpProvider.genderQuestion,
                    onChanged:
                        (value) => signUpProvider.setGender(gender: value),
                  ),

                  SizeHelper.height(),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: CustomText(
                          text: AppStrings.uploadPhoto,
                          style: TextStyleHelper.smallHeading,
                        ),
                      ),
                    ],
                  ),
                  SizeHelper.height(),
                  CustomFilePickerV2(
                    allowMultiple: false,
                    allowedExtensions: ["jpg", "png", "jpeg"],
                    icon: AppIconsData.profile,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ConvenerDropDown extends StatelessWidget {
  const ConvenerDropDown({super.key, required this.signUpProvider});

  final SignUpProvider signUpProvider;

  @override
  Widget build(BuildContext context) {
    return CustomSearchableDropDown<Convener>(
      list: signUpProvider.convenerListModel?.data?.convener ?? [],
      itemAsString: (p0) => p0.name ?? "",
      itemBuilder:
          (context, convener, isDisabled, isSelected) => CustomContainer(
            padding: EdgeInsets.all(AppSize.size10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomText(
                  text: convener.name ?? "",
                  style: TextStyleHelper.smallHeading.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                CustomText(text: convener.city ?? "Not Provided"),
              ],
            ),
          ),
      compareFn: (p0, p1) => p0.name?.contains(p1.name ?? "") ?? false,
      onChanged: (p0) => signUpProvider.setConvener = p0,
      selectedItem: signUpProvider.selectedConvener,
      dropdownBuilder:
          (context, convener) =>
              convener != null
                  ? CustomContainer(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text: convener.name ?? "",
                          style: TextStyleHelper.smallHeading.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        CustomText(text: convener.city ?? "Not Provided"),
                      ],
                    ),
                  )
                  : SizedBox.shrink(),
      validator:
          (value) => ValidatorHelper.validateValue(
            value: value?.name ?? "",
            context: context,
          ),
    );
  }
}
