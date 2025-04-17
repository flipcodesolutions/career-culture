import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/models/login_model/send_email_otp_model.dart';
import 'package:mindful_youth/models/login_model/user_signup_request_model.dart';
import 'package:intl/intl.dart';
import 'package:mindful_youth/screens/main_screen/main_screen.dart';
import 'package:mindful_youth/service/send_otp_services/send_otp_service.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/custom_text_form_field.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';
import '../../models/assessment_question_model/assessment_question_model.dart';
import '../../models/login_model/user_signup_confirm_model.dart';
import '../../service/sign_up_service/sign_up_service.dart';
import '../../utils/widget_helper/widget_helper.dart';

class SignUpProvider extends ChangeNotifier with NavigateHelper {
  /// if provider is Loading
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserSignUpRequestModel _signUpRequestModel = UserSignUpRequestModel();
  UserSignUpRequestModel get signUpRequestModel => _signUpRequestModel;

  ///=================================================================
  ///
  /// first page form key
  ///
  /// ================================================================
  GlobalKey<FormState> firstPageFormKey = GlobalKey<FormState>();

  // Page-wise validation logic
  bool validateFirstPage(BuildContext context) {
    bool isValid = firstPageFormKey.currentState?.validate() ?? false;

    if (genderQuestion.answer?.isEmpty ?? true) {
      WidgetHelper.customSnackBar(
        context: context,
        title: AppStrings.genderNeeded,
        isError: true,
      );
      isValid = false;
    }
    if (_signUpRequestModel.imageFile?.isEmpty == true ||
        _signUpRequestModel.imageFile == null) {
      WidgetHelper.customSnackBar(
        context: context,
        title: AppStrings.mustSelectProfilePic,
        isError: true,
      );
      isValid = false;
    }

    return isValid;
  }

  /// user full name
  TextEditingController firstName = TextEditingController();
  TextEditingController middleName = TextEditingController();
  TextEditingController lastName = TextEditingController();

  /// select your gender
  final AssessmentQuestion _genderQuestion = AssessmentQuestion(
    question: AppStrings.gender,
    extractedOptions: [AppStrings.male, AppStrings.female],
  );
  AssessmentQuestion get genderQuestion => _genderQuestion;
  void setGender({String? gender}) {
    _genderQuestion.answer = gender;
    notifyListeners();
  }

  /// user birth date
  TextEditingController birthDate = TextEditingController();
  void selectBirthDateByDatePicker({required BuildContext context}) async {
    DateTime? initialDate;
    try {
      // Try parsing the existing text to a DateTime
      initialDate = DateFormat('yyyy-MM-dd').parse(birthDate.text);
      notifyListeners();
    } catch (_) {
      // Fallback if parsing fails or text is empty
      initialDate = null;
    }
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1947),
      lastDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
    if (date != null) {
      /// set the controller text in string like "1999-01-12"
      birthDate.text = DateFormat('yyyy-MM-dd').format(date);
      notifyListeners();
    }
  }

  /// In your Provider (or ViewModel)

  /// Second page form key
  GlobalKey<FormState> secondPageFormKey = GlobalKey<FormState>();

  /// OTP verification form key is now local to the dialog function
  /// GlobalKey<FormState> verifyOtpFormKey = GlobalKey<FormState>(); // no longer needed globally

  // Other fields
  TextEditingController email = TextEditingController();
  TextEditingController emailOtp = TextEditingController();

  bool _isEmailVerified = false;
  bool get isEmailVerified => _isEmailVerified;

  TextEditingController contactNo1 = TextEditingController();
  TextEditingController contactNo1Otp = TextEditingController();
  bool _isContactNo1Verified = false;
  bool get isContactNo1Verified => _isEmailVerified;

  TextEditingController contactNo2 = TextEditingController();
  TextEditingController contactNo2Otp = TextEditingController();

  /// address
  TextEditingController address1 = TextEditingController();
  TextEditingController address2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController country = TextEditingController();
  TextEditingController district = TextEditingController();

  SendOtpService otpService = SendOtpService();
  SendEmailOtpModel? _emailOtpModel;
  SendEmailOtpModel? get emailOtpModel => _emailOtpModel;

  /// Main validation method for the second page
  Future<bool> validateSecondPage(BuildContext context) async {
    // Validate the second-page form normally
    bool isValid = secondPageFormKey.currentState?.validate() ?? false;
    if (isEmailVerified && isValid) return true;
    if (!isValid) return false;

    // Send the OTP for email verification
    await sendEmailOtp(context: context);

    // Await the OTP verification dialog result
    final emailVerified = await _showEmailOtpDialog(context);
    if (emailVerified) {
      _isEmailVerified = true;
      _signUpRequestModel.isEmailVerified = "yes";
      // Assuming contact is verified in a similar manner:
      _signUpRequestModel.isContactVerified = "yes";
      notifyListeners();
    }
    return emailVerified;
  }

  /// Separate method for showing the OTP verification dialog
  Future<bool> _showEmailOtpDialog(BuildContext context) async {
    // Create a local TextEditingController for OTP input
    final TextEditingController otpController = TextEditingController();
    // Create a local form key for OTP verification
    final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      // barrierDismissible: false, // Force user to verify or cancel explicitly
      builder: (builderContext) {
        return AlertDialog(
          backgroundColor: AppColors.lightWhite,
          title: CustomText(
            text: AppStrings.verifyEmailWithOtp,
            style: TextStyleHelper.mediumHeading.copyWith(
              color: AppColors.primary,
            ),
          ),
          content: Form(
            key: otpFormKey,
            child: CustomTextFormField(
              labelText: AppStrings.otp,
              controller: otpController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter OTP";
                }
                if (value != _emailOtpModel?.data?.otp.toString()) {
                  return AppStrings.otpDoesNotMatch;
                }
                return null;
              },
            ),
          ),
          actions: [
            PrimaryBtn(
              width: 30.w,
              btnText: AppStrings.resendOtp,
              onTap: () async {
                await sendEmailOtp(context: context);
              },
            ),
            PrimaryBtn(
              width: 30.w,
              btnText: AppStrings.verifyOtp,
              onTap: () {
                if (otpFormKey.currentState?.validate() == true) {
                  Navigator.of(builderContext).pop(true);
                }
              },
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  /// Method to send the OTP
  Future<void> sendEmailOtp({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    _emailOtpModel = await otpService.sendEmailOtp(
      context: context,
      email: email.text,
    );

    _isLoading = false;
    notifyListeners();
  }

  ///==========================================================================
  ///
  /// page third form key
  ///
  /// =========================================================================
  GlobalKey<FormState> thirdPageFormKey = GlobalKey<FormState>();
  TextEditingController presentOrLastStudy = TextEditingController();
  TextEditingController collegeOrUniversity = TextEditingController();
  TextEditingController companyOrBusiness = TextEditingController();
  final AssessmentQuestion _areYouWorking = AssessmentQuestion(
    question: AppStrings.areYouWorking,
    extractedOptions: ["Yes", "No"],
  );
  AssessmentQuestion get areYouWorking => _areYouWorking;
  void setWorking({String? working}) {
    _areYouWorking.answer = working;
    notifyListeners();
  }

  // Page-wise validation logic
  bool validateThirdPage(BuildContext context) {
    bool isValid = thirdPageFormKey.currentState?.validate() ?? false;

    if (_areYouWorking.answer?.isEmpty ?? true) {
      WidgetHelper.customSnackBar(
        context: context,
        title: AppStrings.mustGiveAllAnswer,
        isError: true,
      );
      isValid = false;
    }
    return isValid;
  }

  ///==========================================================================
  ///
  /// page fourth form key
  ///
  /// =========================================================================
  GlobalKey<FormState> fourthPageFormKey = GlobalKey<FormState>();
  // TextEditingController na = TextEditingController();
  // TextEditingController collegeOrUniversity = TextEditingController();
  // TextEditingController companyOrBusiness = TextEditingController();

  // Page-wise validation logic
  bool validateFourthPage(BuildContext context) {
    bool isValid = fourthPageFormKey.currentState?.validate() ?? false;

    return isValid;
  }

  SignUpService signUpService = SignUpService();
  UserSignUpConfirmModel? _signUpConfirmModel;
  UserSignUpConfirmModel? get signUpConfirmModel => _signUpConfirmModel;
  void buildSignUpRequestModel({required BuildContext context}) async {
    _signUpRequestModel.name =
        "${firstName.text} ${middleName.text} ${lastName.text}";
    _signUpRequestModel.email = email.text;
    _signUpRequestModel.isEmailVerified = isEmailVerified ? "yes" : "no";
    _signUpRequestModel.isContactVerified = isEmailVerified ? "yes" : "no";
    _signUpRequestModel.contactNo1 = contactNo1.text;
    _signUpRequestModel.contactNo2 = contactNo2.text;
    _signUpRequestModel.gender = genderQuestion.answer;
    _signUpRequestModel.dateOfBirth = birthDate.text;
    _signUpRequestModel.addressLine1 = address1.text;
    _signUpRequestModel.addressLine2 = address2.text;
    _signUpRequestModel.city = city.text;
    _signUpRequestModel.state = state.text;
    _signUpRequestModel.country = country.text;
    _signUpRequestModel.district = district.text;
    _signUpRequestModel.study = presentOrLastStudy.text;
    _signUpRequestModel.degree = presentOrLastStudy.text;
    _signUpRequestModel.university = collegeOrUniversity.text;
    _signUpRequestModel.workingStatus =
        areYouWorking.answer?.toLowerCase() ?? "no";
    _signUpRequestModel.nameOfCompanyOrBusiness = companyOrBusiness.text;
    notifyListeners();

    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _signUpConfirmModel = await signUpService.registerUser(
      context: context,
      signUp: _signUpRequestModel,
    );

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();

    if (_signUpConfirmModel?.success == true) {
      SharedPrefs.saveToken(_signUpConfirmModel?.data?.token ?? "");

      ///store user info in locale
      MethodHelper.saveUserInfoInLocale(
        userName: _signUpConfirmModel?.data?.user?.name ?? "",
        userEmail: _signUpConfirmModel?.data?.user?.email ?? "",
        isEmailVerified: _signUpConfirmModel?.data?.user?.isEmailVerified ?? "",
        isContactVerified:
            _signUpConfirmModel?.data?.user?.isContactVerified ?? "",
        role: _signUpConfirmModel?.data?.user?.role ?? "",
        isApproved: _signUpConfirmModel?.data?.user?.isApproved ?? "",
        status: _signUpConfirmModel?.data?.user?.status ?? "",
        id: _signUpConfirmModel?.data?.user?.id?.toString() ?? "",
        images: _signUpConfirmModel?.data?.userProfile?.images ?? "",
        userId:
            _signUpConfirmModel?.data?.userProfile?.userId?.toString() ?? "",
        userContactNo1:
            _signUpConfirmModel?.data?.userProfile?.contactNo1 ?? "",
        userContactNo2:
            _signUpConfirmModel?.data?.userProfile?.contactNo2 ?? "",
        userGender: _signUpConfirmModel?.data?.userProfile?.gender ?? "",
        dateOfBirth: _signUpConfirmModel?.data?.userProfile?.dateOfBirth ?? "",
        addressLine1:
            _signUpConfirmModel?.data?.userProfile?.addressLine1 ?? "",
        addressLine2:
            _signUpConfirmModel?.data?.userProfile?.addressLine2 ?? "",
        userCity: _signUpConfirmModel?.data?.userProfile?.city ?? "",
        userState: _signUpConfirmModel?.data?.userProfile?.state ?? "",
        userCountry: _signUpConfirmModel?.data?.userProfile?.country ?? "",
        userDistrict: _signUpConfirmModel?.data?.userProfile?.district ?? "",
        study: _signUpConfirmModel?.data?.userEducation?.study ?? "",
        degree: _signUpConfirmModel?.data?.userEducation?.degree ?? "",
        university: _signUpConfirmModel?.data?.userEducation?.university ?? "",
        workingStatus:
            _signUpConfirmModel?.data?.userEducation?.workingStatus ?? "",
        userNameOfCompanyOrBusiness:
            _signUpConfirmModel?.data?.userEducation?.nameOfCompanyOrBusiness ??
            "",
        userToken: _signUpConfirmModel?.data?.token ?? "",
      );

      /// navigate user to home screen
      pushRemoveUntil(context: context, widget: MainScreen(setIndex: 0));
    }
  }

  void refreshSignUpProvider() {
    _signUpRequestModel = UserSignUpRequestModel();

    /// first page
    firstName.clear();
    lastName.clear();
    middleName.clear();
    birthDate.clear();
    _genderQuestion.answer = "";

    /// second page
    email.clear();
    emailOtp.clear();
    contactNo1.clear();
    contactNo1Otp.clear();
    contactNo2.clear();
    contactNo2Otp.clear();
    address1.clear();
    address2.clear();
    city.clear();
    district.clear();
    state.clear();
    country.clear();
    _emailOtpModel = null;

    /// third page
    presentOrLastStudy.clear();
    collegeOrUniversity.clear();
    _areYouWorking.answer = "";
    companyOrBusiness.clear();
  }
}
