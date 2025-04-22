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

  /// if provider is Loading
  bool _isUpdatingProfile = false;
  bool get isUpdatingProfile => _isUpdatingProfile;
  set setIsUpdatingProfile(bool isUpdate) {
    _isUpdatingProfile = isUpdate;
    notifyListeners();
  }

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
    if ((!_isUpdatingProfile ? _signUpRequestModel.imageFile.isEmpty : false)) {
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
  set setIsEmailVerified(bool isVerified) {
    _isEmailVerified = isVerified;
    notifyListeners();
  }

  TextEditingController contactNo1 = TextEditingController();
  TextEditingController contactNo1Otp = TextEditingController();
  bool _isContactNo1Verified = false;
  bool get isContactNo1Verified => _isContactNo1Verified;
  set setIsContactNo1Verified(bool isVerified) {
    _isContactNo1Verified = isVerified;
    notifyListeners();
  }

  TextEditingController contactNo2 = TextEditingController();
  TextEditingController contactNo2Otp = TextEditingController();
  bool _isContactNo2Verified = false;
  bool get isContactNo2Verified => _isContactNo2Verified;
  set setIsContactNo2Verified(bool isVerified) {
    _isContactNo2Verified = isVerified;
    notifyListeners();
  }

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
    if (isEmailVerified && isContactNo1Verified && isValid) return true;
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
              keyboardType: TextInputType.numberWithOptions(),
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
  void buildSignUpRequestModel({
    required BuildContext context,
  }) async {
    _signUpRequestModel.name =
        "${firstName.text.trim()} ${middleName.text.trim()} ${lastName.text.trim()}";
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
    _signUpConfirmModel =
        _isUpdatingProfile
            ? await signUpService.updateUserInfo(
              context: context,
              signUp: _signUpRequestModel,
            )
            : await signUpService.registerUser(
              context: context,
              signUp: _signUpRequestModel,
            );

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();

    if (_signUpConfirmModel?.success == true) {
      SharedPrefs.saveToken(_signUpConfirmModel?.data?.token ?? "");

      refreshSignUpProvider();

      // /// navigate user to home screen
      // context.read<HomeScreenProvider>().setNavigationIndex = 0;
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
    _isEmailVerified = false;
    _isContactNo1Verified = false;
    _emailOtpModel = null;

    /// third page
    presentOrLastStudy.clear();
    collegeOrUniversity.clear();
    _areYouWorking.answer = "";
    companyOrBusiness.clear();
    notifyListeners();
  }

  Future<void> initControllerWithLocalStorage() async {
    /// first page
    String name = await SharedPrefs.getSharedString(AppStrings.userName);
    print(name);
    firstName.text = name.split(" ")[0];
    lastName.text = name.split(" ")[1];
    middleName.text = name.split(" ")[2];
    birthDate.text = await SharedPrefs.getSharedString(AppStrings.dateOfBirth);
    _genderQuestion.answer = await SharedPrefs.getSharedString(
      AppStrings.userGender,
    );
    _signUpConfirmModel
        ?.data
        ?.userProfile
        ?.images = await SharedPrefs.getSharedString(AppStrings.images);

    /// second page
    email.text = await SharedPrefs.getSharedString(AppStrings.userEmail);
    String emailCheck = await SharedPrefs.getSharedString(
      AppStrings.isEmailVerified,
    );
    setIsEmailVerified = emailCheck == "yes";
    contactNo1.text = await SharedPrefs.getSharedString(
      AppStrings.userContactNo1,
    );
    String contact1Check = await SharedPrefs.getSharedString(
      AppStrings.isContactVerified,
    );
    setIsContactNo1Verified = contact1Check == "yes";

    contactNo2.text = await SharedPrefs.getSharedString(
      AppStrings.userContactNo2,
    );
    // setIsContactNo2Verified = await SharedPrefs.getSharedBool(
    //   AppStrings.isContactVerified,
    // );
    address1.text = await SharedPrefs.getSharedString(AppStrings.addressLine1);
    address2.text = await SharedPrefs.getSharedString(AppStrings.addressLine2);
    city.text = await SharedPrefs.getSharedString(AppStrings.userCity);
    state.text = await SharedPrefs.getSharedString(AppStrings.userState);
    country.text = await SharedPrefs.getSharedString(AppStrings.userCountry);
    district.text = await SharedPrefs.getSharedString(AppStrings.userDistrict);

    /// third page
    presentOrLastStudy.text = await SharedPrefs.getSharedString(
      AppStrings.study,
    );
    collegeOrUniversity.text = await SharedPrefs.getSharedString(
      AppStrings.university,
    );
    areYouWorking.answer =
        await SharedPrefs.getSharedString(AppStrings.workingStatus) == "yes"
            ? "Yes"
            : "No";
    companyOrBusiness.text = await SharedPrefs.getSharedString(
      AppStrings.userNameOfCompanyOrBusiness,
    );
    notifyListeners();
  }
}
