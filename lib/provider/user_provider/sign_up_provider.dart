import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/models/login_model/convener_list_model.dart';
import 'package:mindful_youth/models/login_model/send_email_otp_model.dart';
import 'package:mindful_youth/models/login_model/sent_otp_model.dart';
import 'package:mindful_youth/models/login_model/user_signup_request_model.dart';
import 'package:intl/intl.dart';
import 'package:mindful_youth/screens/main_screen/main_screen.dart';
import 'package:mindful_youth/service/get_conveners_service/get_conveners_service.dart';
import 'package:mindful_youth/service/send_otp_services/send_otp_service.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/custom_text_form_field.dart';
import 'package:mindful_youth/widgets/pin_put_widget.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';
import '../../models/assessment_question_model/assessment_question_model.dart';
import '../../models/login_model/user_signup_confirm_model.dart';
import '../../service/sign_up_service/sign_up_service.dart';
import '../../utils/widget_helper/widget_helper.dart';

class SignUpProvider extends ChangeNotifier with NavigateHelper {
  SignUpProvider() {
    initControllerWithLocalStorage();
  }

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
    if (!_isUpdatingProfile
        ? _selectedConvener?.id == null || _selectedConvener?.name == null
        : false) {
      WidgetHelper.customSnackBar(
        context: context,
        title: AppStrings.somethingWentWrong,
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

  /// convener
  /// Service and getter and setter
  GetConvenersService convenersService = GetConvenersService();
  ConvenerListModel? _convenerListModel;
  ConvenerListModel? get convenerListModel => _convenerListModel;
  Convener? _selectedConvener;
  Convener? get selectedConvener => _selectedConvener;
  set setConvener(Convener? convener) {
    _selectedConvener = convener;
    notifyListeners();
  }

  Future<void> getConveners({required BuildContext context}) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _convenerListModel = await convenersService.getConvenerList(
      context: context,
    );

    /// set _isLoading false
    _isLoading = false;
    notifyListeners();
  }

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
  SentOtpModel? _mobileOtpModel;
  SentOtpModel? get mobileOtpModel => _mobileOtpModel;
  UserModel? _verifyMobileModel;
  UserModel? get verifyMobileModel => _verifyMobileModel;
  UserModel? _verifyEmailModel;
  UserModel? get verifyEmailModel => _verifyEmailModel;

  /// Main validation method for the second page
  Future<bool> validateSecondPage(BuildContext context) async {
    final isValid = secondPageFormKey.currentState?.validate() ?? false;
    if (!isValid) return false;

    // 1) Email OTP
    if (!_isEmailVerified) {
      await sendEmailOtp(context: context);
      final ok = await _showEmailOtpDialog(context);
      setIsEmailVerified = ok;
      _signUpRequestModel.isEmailVerified = ok ? 'yes' : 'no';
      if (!ok) return false;
    }

    // 2) Contact #1 OTP
    if (!_isContactNo1Verified) {
      final sent1 = await sendMobileOtp(
        context: context,
        number: contactNo1.text,
      );
      if (!sent1) return false;

      final ok1 = await _showMobileOtpDialog(
        context: context,
        title: AppStrings.verifyContactNo1WithOtp,
        contact: contactNo1.text,
      );
      setIsContactNo1Verified = ok1;
      _signUpRequestModel.isContactVerified = ok1 ? 'yes' : 'no';
      if (!ok1) return false;
    }

    // 3) Contact #2 OTP (only if provided)
    if (contactNo2.text.isNotEmpty && !_isContactNo2Verified) {
      bool sent2 = await sendMobileOtp(
        context: context,
        number: contactNo2.text,
      );
      if (!sent2) return false;

      bool ok2 = await _showMobileOtpDialog(
        context: context,
        title: AppStrings.verifyContactNo2WithOtp,
        contact: contactNo2.text,
      );
      setIsContactNo2Verified = ok2;
      if (!ok2) return false;
    }

    // 4) Final sanity‑check
    return isValid &&
        isEmailVerified &&
        isContactNo1Verified &&
        (contactNo2.text.isEmpty || isContactNo2Verified);
  }

  /// Separate method for showing the OTP verification dialog
  Future<bool> _showEmailOtpDialog(BuildContext context) async {
    // Create a local TextEditingController for OTP input
    final TextEditingController otpController = TextEditingController();
    // Create a local form key for OTP verification
    final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

    _isEmailVerified =
        await showDialog<bool>(
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
                  onTap: () async {
                    if (otpFormKey.currentState?.validate() == true) {
                      bool success = await verifyEmailOtp(
                        context: context,
                        email: email.text,
                        otp: otpController.text,
                      );
                      if (success) {
                        Navigator.of(builderContext).pop(true);
                      }
                    }
                  },
                ),
              ],
            );
          },
        ) ??
        false;
    return _isEmailVerified;
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

  Future<bool> sendMobileOtp({
    required BuildContext context,
    required String number,
  }) async {
    _isLoading = true;
    notifyListeners();

    _mobileOtpModel = await otpService.sendMobileOtp(
      context: context,
      contactNo: number,
    );

    _isLoading = false;
    notifyListeners();
    if (_mobileOtpModel?.success == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> verifyEmailOtp({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    _isLoading = true;
    notifyListeners();

    _verifyMobileModel = await otpService.verifyEmailOtp(
      context: context,
      email: email,
      otp: otp,
    );

    _isLoading = false;
    notifyListeners();
    if (_verifyMobileModel?.success == true &&
        _verifyMobileModel?.data?.isEmailVerified == true) {
      return true;
    } else {
      WidgetHelper.customSnackBar(
        context: context,
        title: AppStrings.thisNumberIsTaken,
        isError: true,
      );
      return false;
    }
  }

  Future<bool> verifyMobileOtp({
    required BuildContext context,
    required String contactNo,
    required String otp,
  }) async {
    _isLoading = true;
    notifyListeners();

    _verifyMobileModel = await otpService.verifyMobileOtp(
      context: context,
      contactNo: contactNo,
      otp: otp,
    );

    _isLoading = false;
    notifyListeners();
    if (_verifyMobileModel?.success == true &&
        _verifyMobileModel?.data?.isNewUser == true) {
      return true;
    } else {
      WidgetHelper.customSnackBar(
        context: context,
        title: AppStrings.thisNumberIsTaken,
        isError: true,
      );
      return false;
    }
  }

  Future<bool> _showMobileOtpDialog({
    required BuildContext context,
    required String title,
    required String contact,
  }) async {
    // Create a local TextEditingController for OTP input
    final TextEditingController otpController = TextEditingController();
    // Create a local form key for OTP verification
    final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

    bool success =
        await showDialog<bool>(
          context: context,
          // barrierDismissible: false, // Force user to verify or cancel explicitly
          builder: (builderContext) {
            return AlertDialog(
              backgroundColor: AppColors.lightWhite,
              title: CustomText(
                text: title,
                style: TextStyleHelper.mediumHeading.copyWith(
                  color: AppColors.primary,
                ),
              ),
              content: Form(
                key: otpFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomContainer(
                      height: AppSize.size100,
                      child: CustomPinPut(
                        controller: otpController,
                        height: AppSize.size70,
                        width: AppSize.size80,
                      ),
                    ),
                  ],
                ),
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                PrimaryBtn(
                  width: 30.w,
                  btnText: AppStrings.resendOtp,
                  onTap: () async {
                    await sendMobileOtp(context: context, number: contact);
                  },
                ),
                PrimaryBtn(
                  width: 30.w,
                  btnText: AppStrings.verifyOtp,
                  onTap: () async {
                    if (otpFormKey.currentState?.validate() == true) {
                      bool success = await verifyMobileOtp(
                        context: context,
                        contactNo: contact,
                        otp: otpController.text,
                      );
                      if (success) {
                        Navigator.of(builderContext).pop(true);
                      }
                    }
                  },
                ),
              ],
            );
          },
        ) ??
        false;
    return success;
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
  UserModel? _signUpConfirmModel;
  UserModel? get signUpConfirmModel => _signUpConfirmModel;
  void buildSignUpRequestModel({required BuildContext context}) async {
    _signUpRequestModel.name =
        "${firstName.text.trim()} ${middleName.text.trim()} ${lastName.text.trim()}";
    _signUpRequestModel.email = email.text;
    _signUpRequestModel.isEmailVerified = isEmailVerified ? "yes" : "no";
    _signUpRequestModel.isContactVerified = isEmailVerified ? "yes" : "no";
    // _signUpRequestModel.contactNo1 = contactNo1.text;
    _signUpRequestModel.phone = contactNo1.text;
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
    _signUpRequestModel.convenerId = selectedConvener?.id;
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
      _isUpdatingProfile
          ? pop(context)
          : pushRemoveUntil(context: context, widget: MainScreen(setIndex: 0));
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
    _selectedConvener = null;

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
    _signUpRequestModel.imageFile = [];
    _signUpRequestModel.images = await SharedPrefs.getSharedString(
      AppStrings.images,
    );

    /// first page
    String name = await SharedPrefs.getSharedString(AppStrings.userName);
    print(name);
    List<String?> fullName = name.split(" ");
    firstName.text = fullName[0] ?? "";
    lastName.text = fullName[1] ?? "";
    middleName.text = fullName[2] ?? "";
    birthDate.text = await SharedPrefs.getSharedString(AppStrings.dateOfBirth);
    _genderQuestion.answer = await SharedPrefs.getSharedString(
      AppStrings.userGender,
    );
    _signUpConfirmModel
        ?.data
        ?.user
        ?.profile
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
