import 'package:flutter/material.dart';
import 'package:mindful_youth/app_const/app_colors.dart';
import 'package:mindful_youth/app_const/app_size.dart';
import 'package:mindful_youth/app_const/app_states_and_city.dart';
import 'package:mindful_youth/models/login_model/convener_list_model.dart';
import 'package:mindful_youth/models/login_model/send_email_otp_model.dart';
import 'package:mindful_youth/models/login_model/sent_otp_model.dart';
import 'package:mindful_youth/models/login_model/user_signup_request_model.dart';
import 'package:intl/intl.dart';
import 'package:mindful_youth/models/login_model/verify_otp_model.dart';
import 'package:mindful_youth/screens/main_screen/main_screen.dart';
import 'package:mindful_youth/service/get_conveners_service/get_conveners_service.dart';
import 'package:mindful_youth/service/send_otp_services/send_otp_service.dart';
import 'package:mindful_youth/utils/method_helpers/method_helper.dart';
import 'package:mindful_youth/utils/method_helpers/validator_helper.dart';
import 'package:mindful_youth/utils/navigation_helper/navigation_helper.dart';
import 'package:mindful_youth/utils/shared_prefs_helper/shared_prefs_helper.dart';
import 'package:mindful_youth/utils/text_style_helper/text_style_helper.dart';
import 'package:mindful_youth/widgets/custom_container.dart';
import 'package:mindful_youth/widgets/custom_text.dart';
import 'package:mindful_youth/widgets/pin_put_widget.dart';
import 'package:mindful_youth/widgets/primary_btn.dart';
import 'package:sizer/sizer.dart';
import '../../app_const/app_strings.dart';
import '../../models/assessment_question_model/assessment_question_model.dart';
import '../../models/login_model/user_signup_confirm_model.dart';
import '../../service/sign_up_service/sign_up_service.dart';
import '../../utils/widget_helper/widget_helper.dart';

class SignUpProvider extends ChangeNotifier with NavigateHelper {
  // SignUpProvider() {
  //   initControllerWithLocalStorage();
  //   WidgetHelper.customSnackBar(title: "sign up provider invoked init");
  // }

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

  /// if user is registered from backend directly
  bool _isRegisteredFromBackEnd = false;
  bool get isRegisteredFromBackEnd => _isRegisteredFromBackEnd;
  set setIsRegisteredFromBackEnd(bool isRegistered) {
    _isRegisteredFromBackEnd = isRegistered;
    print("setting is registered from back is ==> $isRegistered");
    notifyListeners();
  }

  UserSignUpRequestModel _signUpRequestModel = UserSignUpRequestModel();
  UserSignUpRequestModel get signUpRequestModel => _signUpRequestModel;

  /// profile pic error
  String? isProfilePicErr;
  void setProfilePicErr(String? err) {
    // isProfilePicErr = _signUpRequestModel.imageFile.isEmpty ? err : null;
    validateProfilePic(err);
  }

  void validateProfilePic(String? err) {
    if (isUpdatingProfile) {
      // On update: check if 'images' has an image string (i.e., not empty)
      if (_signUpRequestModel.images?.isEmpty == true) {
        isProfilePicErr = err; // Assign error if images list is empty
      } else {
        isProfilePicErr = null; // No error if images list is not empty
      }
    } else {
      // Not updating (e.g., new signup): 'imageFile' should not be empty
      if (_signUpRequestModel.imageFile.isEmpty) {
        isProfilePicErr = err; // Assign error if imageFile is empty
      } else {
        isProfilePicErr = null; // No error if imageFile is not empty
      }
    }
    notifyListeners();
  }

  ///=================================================================
  ///
  /// first page form key
  ///
  /// ================================================================
  // GlobalKey<FormState> firstPageFormKey = GlobalKey<FormState>();

  // Page-wise validation logic
  bool validateFirstPage(BuildContext context) {
    /// run all validation so the next check can find if any err
    validateFirstName();
    validateMiddleName();
    validateLastName();
    validteBirthdate();
    validateConvener();
    validateGender();
    validateProfilePic(AppStrings.mustSelectProfilePic);
    bool isValid = [
      isFirstNameErr,
      isMiddleNameErr,
      isLastNameErr,
      isBirthDateErr,
      isConvenerErr,
      isGenderErr,
      isProfilePicErr,
    ].every((s) => s == null);
    // if ((!_isUpdatingProfile ? _signUpRequestModel.imageFile.isEmpty : false)) {
    //   isValid = false;
    //   notifyListeners();
    // }
    return isValid;
  }

  /// user full name
  TextEditingController firstName = TextEditingController();
  String? isFirstNameErr;
  void validateFirstName() {
    isFirstNameErr = ValidatorHelper.validateName(
      value: firstName.text,
      name: AppStrings.firstName,
    );
    notifyListeners();
  }

  TextEditingController middleName = TextEditingController();
  String? isMiddleNameErr;
  void validateMiddleName() {
    isMiddleNameErr = ValidatorHelper.validateName(
      minLength: 1,
      value: middleName.text,
      name: AppStrings.middleName,
    );
    notifyListeners();
  }

  TextEditingController lastName = TextEditingController();
  String? isLastNameErr;
  void validateLastName() {
    isLastNameErr = ValidatorHelper.validateName(
      value: lastName.text,
      name: AppStrings.lastName,
    );
    notifyListeners();
  }

  /// convener
  /// Service and getter and setter
  GetConvenersService convenersService = GetConvenersService();
  ConvenerListModel? _convenerListModel;
  ConvenerListModel? get convenerListModel => _convenerListModel;
  String? coordinatorIdFromLocal;
  Convener? _selectedConvener;
  String? isConvenerErr;
  Convener? get selectedConvener => _selectedConvener;
  set setConvener(Convener? convener) {
    _selectedConvener = convener;
    notifyListeners();
  }

  void validateConvener() {
    isConvenerErr =
        _selectedConvener == null ||
                _selectedConvener?.id == null ||
                _selectedConvener?.name?.trim().isEmpty == true
            ? AppStrings.selectConvener
            : null;
  }

  Future<void> getConveners({required BuildContext context}) async {
    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _convenerListModel = await convenersService.getConvenerList(
      context: context,
    );
    _convenerListModel?.data?.convener?.forEach((e) {
      if (e.id.toString() == coordinatorIdFromLocal) {
        _selectedConvener = e;
        notifyListeners();
      }
    });

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
  String? isGenderErr;
  void validateGender() {
    isGenderErr =
        _genderQuestion.answer?.trim().isEmpty == true
            ? AppStrings.genderNeeded
            : null;
    notifyListeners();
  }

  void setGender({String? gender}) {
    _genderQuestion.answer = gender;
    validateGender();
  }

  /// user birth date
  TextEditingController birthDate = TextEditingController();
  String? isBirthDateErr;
  void validteBirthdate() {
    isBirthDateErr = ValidatorHelper.validateDateFormate(value: birthDate.text);
    notifyListeners();
  }

  int _lastLength = 0;

  void addHyphen() {
    final oldText = birthDate.text;
    final oldSelection = birthDate.selection;

    // Remove all hyphens first
    String rawText = oldText.replaceAll('-', '');

    // Limit length to 8 (DDMMMYYYY without hyphens)
    if (rawText.length > 9) {
      rawText = rawText.substring(0, 8);
    }

    String day = '';
    String month = '';
    String year = '';

    if (rawText.length >= 2) {
      day = rawText.substring(0, 2);
    } else {
      day = rawText; // partial day input
    }

    if (rawText.length > 2) {
      int monthEndIndex = rawText.length >= 5 ? 5 : rawText.length;
      month = rawText.substring(2, monthEndIndex);
    }

    if (rawText.length > 5) {
      year = rawText.substring(5);
    }

    // Capitalize first letter of month, rest lowercase
    if (month.isNotEmpty) {
      month =
          month[0].toUpperCase() +
          (month.length > 1 ? month.substring(1).toLowerCase() : '');
    }

    // Build new formatted string with hyphens
    String newText = day;
    if (month.isNotEmpty) newText += '-$month';
    if (year.isNotEmpty) newText += '-$year';

    // If text didn't change, no need to update
    if (newText == oldText) return;

    // Calculate new cursor position
    int cursorPos = oldSelection.baseOffset;

    // Count hyphens before cursor in old and new text to adjust cursor correctly
    int hyphensBeforeCursorOld =
        '-'.allMatches(oldText.substring(0, cursorPos)).length;
    int hyphensBeforeCursorNew =
        '-'
            .allMatches(
              newText.substring(
                0,
                cursorPos + (newText.length - oldText.length),
              ),
            )
            .length;

    int diff = hyphensBeforeCursorNew - hyphensBeforeCursorOld;
    int newCursorPos = cursorPos + diff;

    // Clamp cursor within newText length
    if (newCursorPos > newText.length) newCursorPos = newText.length;
    if (newCursorPos < 0) newCursorPos = 0;

    // Update controller text and selection
    birthDate.text = newText;
    birthDate.selection = TextSelection.fromPosition(
      TextPosition(offset: newCursorPos),
    );

    _lastLength = newText.length;
    notifyListeners();
  }

  void selectBirthDateByDatePicker({required BuildContext context}) async {
    DateTime? initialDate;
    try {
      // Try parsing the existing text to a DateTime
      initialDate = DateFormat('dd-MMM-yyyy').parse(birthDate.text);
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
      birthDate.text = DateFormat('dd-MMM-yyyy').format(date);
      validteBirthdate();
    }
  }

  void resetErrAllPage() {
    resetErrVarsFirstPage();
    resetErrVarsSecondPage();
    resetErrVarsThirdPage();
  }

  void resetErrVarsFirstPage() {
    isFirstNameErr = null;
    isMiddleNameErr = null;
    isLastNameErr = null;
    isBirthDateErr = null;
    isConvenerErr = null;
    isGenderErr = null;
    // isProfilePicErr = null;
    notifyListeners();
  }

  /// Second page form key
  // GlobalKey<FormState> secondPageFormKey = GlobalKey<FormState>();
  AppStatesAndCity statesAndDistrict = AppStatesAndCity();

  /// OTP verification form key is now local to the dialog function
  /// GlobalKey<FormState> verifyOtpFormKey = GlobalKey<FormState>(); // no longer needed globally

  // Other fields
  TextEditingController email = TextEditingController();
  String? isEmailErr;
  void validateEmail() {
    isEmailErr = ValidatorHelper.validateEmail(value: email.text);
    notifyListeners();
  }

  TextEditingController emailOtp = TextEditingController();

  bool _isEmailVerified = false;
  bool get isEmailVerified => _isEmailVerified;
  set setIsEmailVerified(bool isVerified) {
    _isEmailVerified = isVerified;
    notifyListeners();
  }

  TextEditingController contactNo1 = TextEditingController();
  String? isContactNo1Err;
  void validateContactNo1() {
    isContactNo1Err = ValidatorHelper.validateMobileNumber(
      value: contactNo1.text,
    );
    notifyListeners();
  }

  TextEditingController contactNo1Otp = TextEditingController();
  bool _isContactNo1Verified = false;
  bool get isContactNo1Verified => _isContactNo1Verified;
  set setIsContactNo1Verified(bool isVerified) {
    _isContactNo1Verified = isVerified;
    notifyListeners();
  }

  TextEditingController contactNo2 = TextEditingController();
  String? isContactNo2Err;
  void validateContactNo2() {
    isContactNo2Err =
        contactNo2.text.trim().isNotEmpty
            ? ValidatorHelper.validateMobileNumber(value: contactNo2.text)
            : null;
    notifyListeners();
  }

  TextEditingController contactNo2Otp = TextEditingController();
  bool _isContactNo2Verified = false;
  bool get isContactNo2Verified => _isContactNo2Verified;
  set setIsContactNo2Verified(bool isVerified) {
    _isContactNo2Verified = isVerified;
    notifyListeners();
  }

  /// address
  TextEditingController address1 = TextEditingController();
  String? isAddressL1Err;
  void validateAddressL1() {
    isAddressL1Err = ValidatorHelper.validateValue(
      value: address1.text,
      message: AppStrings.addressIsMust,
    );
    notifyListeners();
  }

  TextEditingController address2 = TextEditingController();
  String? isAddressL2Err;
  void validateAddressL2() {
    isAddressL2Err =
        address2.text.trim().isNotEmpty
            ? ValidatorHelper.validateValue(value: address2.text)
            : null;
    notifyListeners();
  }

  // TextEditingController city = TextEditingController();
  String district = "";
  String? isDistrictErr;
  void validateDistrict() {
    isDistrictErr = ValidatorHelper.validateValue(
      value: district,
      message: AppStrings.noDistrictFound,
    );
    notifyListeners();
  }

  /// if provider is Loading
  bool _cityLoader = false;
  bool get cityLoader => _cityLoader;

  /// get drop down list for states
  void selectDistrict({required String district}) {
    district = district;
    validateDistrict();
  }

  List<DropdownMenuEntry<String>> availableDistrict() {
    MapEntry<String, List<String>> stateWithDistrict = statesAndDistrict
        .stateAndCity
        .entries
        .firstWhere(
          (e) => e.key == state,
          orElse:
              () => MapEntry(AppStrings.noDataFound, <String>[
                AppStrings.noDistrictFound,
              ]),
        );
    List<DropdownMenuEntry<String>> cities =
        List<DropdownMenuEntry<String>>.generate(
          stateWithDistrict.value.length,
          (index) => DropdownMenuEntry(
            value: stateWithDistrict.value.elementAt(index),
            label: stateWithDistrict.value.elementAt(index),
          ),
        );
    cities.sort((a, b) => a.label.compareTo(b.label));
    return cities;
  }

  TextEditingController country = TextEditingController();
  // TextEditingController state = TextEditingController();
  String state = "";
  String? isStateErr;
  void validateState() {
    isStateErr = ValidatorHelper.validateValue(
      value: state,
      message: AppStrings.noStateFound,
    );
    notifyListeners();
  }

  /// get drop down list for states
  void selectState({required String stateSelected}) async {
    /// set _isLoading true
    _cityLoader = true;
    notifyListeners();
    state = stateSelected;
    district = AppStrings.noCitiesFound;
    await Future.delayed(Duration(milliseconds: 300));

    /// set _isLoading false
    _cityLoader = false;
    validateState();
  }

  List<DropdownMenuEntry<String>> availableStates() {
    List<DropdownMenuEntry<String>> states =
        List<DropdownMenuEntry<String>>.generate(
          statesAndDistrict.stateAndCity.keys.length,
          (index) => DropdownMenuEntry(
            value: statesAndDistrict.stateAndCity.keys.elementAt(index),
            label: statesAndDistrict.stateAndCity.keys.elementAt(index),
          ),
        );

    // Sort alphabetically by label
    states.sort((a, b) => a.label.compareTo(b.label));

    return states;
  }

  TextEditingController city = TextEditingController();

  String? isCityErr;
  void validateCity() {
    isCityErr = ValidatorHelper.validateValue(
      value: city.text,
      message: AppStrings.noCitiesFound,
    );
    notifyListeners();
  }

  SendOtpService otpService = SendOtpService();
  SendEmailOtpModel? _emailOtpModel;
  SendEmailOtpModel? get emailOtpModel => _emailOtpModel;
  SentOtpModel? _mobileOtpModel;
  SentOtpModel? get mobileOtpModel => _mobileOtpModel;
  bool? _verifyMobile;
  bool? get verifyMobile => _verifyMobile;
  UserModel? _verifyEmailModel;
  UserModel? get verifyEmailModel => _verifyEmailModel;

  /// Main validation method for the second page
  Future<bool> validateSecondPage(BuildContext context) async {
    // final isValid = secondPageFormKey.currentState?.validate() ?? false;
    validateEmail();
    validateContactNo1();
    validateContactNo2();
    validateAddressL1();
    validateAddressL2();
    validateState();
    validateDistrict();
    validateCity();
    bool isValid = [
      isEmailErr,
      isContactNo1Err,
      isContactNo2Err,
      isAddressL1Err,
      isAddressL2Err,
      isStateErr,
      isCityErr,
      isDistrictErr,
    ].every((s) => s == null);
    if (!isValid) return false;
    if (state == "" || state == AppStrings.noStateFound) {
      validateState();
      return false;
    }
    if (city.text == "" || city.text == AppStrings.noCitiesFound) {
      validateCity();
      return false;
    }

    if (district == "" || district == AppStrings.noDistrictFound) {
      validateDistrict();
      return false;
    }
    // 1) Email OTP
    if (!_isEmailVerified) {
      final bool sent = await sendEmailOtp(context: context);
      final ok = sent ? await _showEmailOtpDialog(context) : false;
      if (!ok) return false;
      setIsEmailVerified = ok;
      _signUpRequestModel.isEmailVerified = ok ? 'yes' : 'no';
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
      if (!ok1) {
        contactNo1.clear();
        return false;
      }
      setIsContactNo1Verified = ok1;
      _signUpRequestModel.isContactVerified = ok1 ? 'yes' : 'no';
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
      if (!ok2) {
        contactNo2.clear();
        return false;
      }
      setIsContactNo2Verified = ok2;
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
              content: Column(
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
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                PrimaryBtn(
                  width: 30.w,
                  btnText: AppStrings.resendOtp,
                  onTap: () async {
                    final bool sent = await sendEmailOtp(context: context);
                    if (!sent) {
                      Navigator.of(builderContext).pop(false);
                    }
                  },
                ),
                PrimaryBtn(
                  width: 30.w,
                  btnText: AppStrings.verifyOtp,
                  onTap: () async {
                    if (ValidatorHelper.validateOtp(
                          value: otpController.text,
                        ) ==
                        null) {
                      bool success = await verifyEmailOtp(
                        context: context,
                        email: email.text,
                        otp: otpController.text,
                      );
                      if (success) {
                        Navigator.of(builderContext).pop(true);
                      }
                    } else {
                      WidgetHelper.customSnackBar(
                        title:
                            ValidatorHelper.validateOtp(
                              value: otpController.text,
                            ) ??
                            "",
                        isError: true,
                      );
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
  Future<bool> sendEmailOtp({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    _emailOtpModel = await otpService.sendEmailOtp(
      context: context,
      email: email.text,
    );

    _isLoading = false;
    notifyListeners();
    if (_emailOtpModel?.success == true) {
      WidgetHelper.customSnackBar(title: _emailOtpModel?.message ?? "");
    } else {
      email.clear();
      notifyListeners();
    }
    return _emailOtpModel?.success == true;
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

    _verifyMobile = await otpService.verifyEmailOtp(
      context: context,
      email: email,
      otp: otp,
    );

    _isLoading = false;
    notifyListeners();
    if (_verifyMobile == true) {
      return true;
    } else {
      WidgetHelper.customSnackBar(
        title: AppStrings.otpVerificationFailed,
        isError: true,
      );
      return false;
    }
  }

  Future<bool?> verifyMobileOtp({
    required BuildContext context,
    required String contactNo,
    required String otp,
  }) async {
    _isLoading = true;
    notifyListeners();

    // _verifyMobile = await otpService.verifyMobileOtp(
    //   context: context,
    //   contactNo: contactNo,
    //   otp: otp,
    // );
    final OtpVerifyModel? otpModel = await otpService.verifyMobileOtp(
      context: context,
      contactNo: contactNo,
      otp: otp,
    );

    _isLoading = false;
    notifyListeners();
    if (otpModel != null && otpModel.data?.isNewUser == true) {
      _verifyMobile = true;
      return true;
    } else if (otpModel?.data == null && otpModel?.success == false) {
      return null;
    } else {
      if (otpModel?.success == true && otpModel?.data?.isNewUser == false) {
        WidgetHelper.customSnackBar(
          autoClose: false,
          title: AppStrings.thisNumberIsTaken,
          isError: true,
        );
        return false;
      } else {
        WidgetHelper.customSnackBar(
          title: AppStrings.somethingWentWrong,
          isError: true,
        );
      }

      return null;
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
    // final GlobalKey<FormState> otpFormKey = GlobalKey<FormState>();

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
              content: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomContainer(
                    child: CustomPinPut(
                      controller: otpController,
                      height: AppSize.size70,
                      width: AppSize.size80,
                    ),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                PrimaryBtn(
                  width: 30.w,
                  btnText: AppStrings.resendOtp,
                  onTap: () async {
                    await sendMobileOtp(number: contact, context: context);
                  },
                ),
                PrimaryBtn(
                  width: 30.w,
                  btnText: AppStrings.verifyOtp,
                  onTap: () async {
                    if (ValidatorHelper.validateOtp(
                          value: otpController.text,
                        ) ==
                        null) {
                      bool? success = await verifyMobileOtp(
                        context: context,
                        contactNo: contact,
                        otp: otpController.text,
                      );
                      if (success == true) {
                        Navigator.of(builderContext).pop(true);
                      } else if (success == false) {
                        Navigator.of(builderContext).pop(false);
                      }
                    } else {
                      WidgetHelper.customSnackBar(
                        title:
                            ValidatorHelper.validateOtp(
                              value: otpController.text,
                            ) ??
                            "",
                        isError: true,
                      );
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

  void resetErrVarsSecondPage() {
    isEmailErr = null;
    isContactNo1Err = null;
    isContactNo2Err = null;
    isAddressL1Err = null;
    isAddressL2Err = null;
    isStateErr = null;
    isDistrictErr = null;
    isCityErr = null;
    notifyListeners();
  }

  ///==========================================================================
  ///
  /// page third form key
  ///
  /// =========================================================================
  // GlobalKey<FormState> thirdPageFormKey = GlobalKey<FormState>();
  TextEditingController presentStudy = TextEditingController();
  String? isPresentStudyErr;
  void validatePresentStudy() {
    isPresentStudyErr = ValidatorHelper.validateValue(
      value: presentStudy.text.trim(),
    );
    notifyListeners();
  }

  TextEditingController lastStudy = TextEditingController();
  String? isLastStudyErr;
  void validateLastStudy() {
    isLastStudyErr =
        lastStudy.text.trim().isNotEmpty
            ? ValidatorHelper.validateValue(value: lastStudy.text.trim())
            : null;
    notifyListeners();
  }

  TextEditingController collegeOrUniversity = TextEditingController();
  String? isCollegeUniErr;
  void validateCollegeUni() {
    isCollegeUniErr = ValidatorHelper.validateValue(
      value: collegeOrUniversity.text.trim(),
    );
    notifyListeners();
  }

  TextEditingController companyOrBusiness = TextEditingController();
  String? isCompanyOrBussinessErr;
  void validateCompanyOrBussiness() {
    isCompanyOrBussinessErr =
        _areYouWorking.answer?.trim() == "Yes"
            ? ValidatorHelper.validateValue(
              value: companyOrBusiness.text,
              message: AppStrings.enterCompanyOrBuissness,
            )
            : null;
    notifyListeners();
  }

  TextEditingController referCode = TextEditingController();
  String? isReferCodeErr;
  void validateReferCode() {
    isReferCodeErr =
        referCode.text.trim().isNotEmpty && referCode.text.trim().length < 6
            ? AppStrings.provideValidReferCode
            : null;
  }

  final AssessmentQuestion _areYouWorking = AssessmentQuestion(
    question: AppStrings.areYouWorking,
    extractedOptions: ["Yes", "No"],
  );
  AssessmentQuestion get areYouWorking => _areYouWorking;
  void setWorking({String? working}) {
    _areYouWorking.answer = working;
    validateWorkingOrNot();
  }

  String? isWorkingErr;
  void validateWorkingOrNot() {
    isWorkingErr =
        _areYouWorking.answer?.trim().isEmpty == true
            ? AppStrings.pleaseSpecifyThis
            : null;
    notifyListeners();
  }

  // Page-wise validation logic
  bool validateThirdPage(BuildContext context) {
    validatePresentStudy();
    validateLastStudy();
    validateCollegeUni();
    validateWorkingOrNot();
    validateCompanyOrBussiness();
    validateReferCode();
    bool isValid = [
      isPresentStudyErr,
      isLastStudyErr,
      isCollegeUniErr,
      isWorkingErr,
      isCompanyOrBussinessErr,
      isReferCodeErr,
    ].every((e) => e == null);

    // if (_areYouWorking.answer?.isEmpty ?? true) {
    //   WidgetHelper.customSnackBar(
    //     autoClose: false,
    //     title: AppStrings.mustGiveAllAnswer,
    //     isError: true,
    //   );
    //   isValid = false;
    // }
    return isValid;
  }

  void resetErrVarsThirdPage() {
    isPresentStudyErr = null;
    isLastStudyErr = null;
    isCollegeUniErr = null;
    isWorkingErr = null;
    isCompanyOrBussinessErr = null;
    isReferCodeErr = null;
    notifyListeners();
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
    _signUpRequestModel.contactNo1 = contactNo1.text;
    _signUpRequestModel.contactNo2 = contactNo2.text;
    _signUpRequestModel.gender = genderQuestion.answer;
    _signUpRequestModel.dateOfBirth = MethodHelper.convertDateToBackendFormat(
      birthDate.text,
    );
    _signUpRequestModel.addressLine1 = address1.text;
    _signUpRequestModel.addressLine2 = address2.text;
    // _signUpRequestModel.city = city.text;
    _signUpRequestModel.city = city.text;
    // _signUpRequestModel.state = state.text; instead using string to select state
    _signUpRequestModel.state = state;
    // _signUpRequestModel.country = country.text; // for now making india as default country
    _signUpRequestModel.country = AppStrings.india;
    _signUpRequestModel.district = district;
    _signUpRequestModel.study = presentStudy.text;
    _signUpRequestModel.degree = lastStudy.text;
    _signUpRequestModel.university = collegeOrUniversity.text;
    _signUpRequestModel.workingStatus =
        areYouWorking.answer?.toLowerCase() ?? "no";
    _signUpRequestModel.nameOfCompanyOrBusiness = companyOrBusiness.text;
    _signUpRequestModel.convenerId = selectedConvener?.id;
    _signUpRequestModel.referCode = referCode.text;
    notifyListeners();

    /// set _isLoading true
    _isLoading = true;
    notifyListeners();
    _signUpConfirmModel =
        _isUpdatingProfile || _isRegisteredFromBackEnd
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

      // /// navigate user to home screen
      // context.read<HomeScreenProvider>().setNavigationIndex = 0;
      _isUpdatingProfile
          ? pop(context)
          : pushRemoveUntil(context: context, widget: MainScreen(setIndex: 0));
      refreshSignUpProvider();
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
    _convenerListModel = null;

    /// reset form keys
    // firstPageFormKey.currentState?.reset();
    // secondPageFormKey.currentState?.reset();
    // thirdPageFormKey.currentState?.reset();

    /// second page
    email.clear();
    emailOtp.clear();
    contactNo1.clear();
    contactNo1Otp.clear();
    contactNo2.clear();
    contactNo2Otp.clear();
    address1.clear();
    address2.clear();
    // city.clear();
    city.text = "";
    district = "";
    // state.clear();
    state = "";
    country.clear();
    _isEmailVerified = false;
    _isContactNo1Verified = false;
    _isContactNo2Verified = false;
    _emailOtpModel = null;
    _mobileOtpModel = null;
    _signUpConfirmModel = null;
    _verifyMobile = false;

    /// third page
    presentStudy.clear();
    lastStudy.clear();
    collegeOrUniversity.clear();
    _areYouWorking.answer = "";
    companyOrBusiness.clear();
    referCode.clear();

    /// important
    _isUpdatingProfile = false;
    notifyListeners();
  }

  Future<void> initControllerWithLocalStorage({
    required BuildContext context,
  }) async {
    // print('\n🔄 Initializing SignUpProvider from local storage...');
    if (_isUpdatingProfile) {
      _isLoading = true;
      notifyListeners();
      await signUpService.getUserDetails(context: context);
      _isLoading = false;
      notifyListeners();
    }
    // Reset image file
    _signUpRequestModel.imageFile = [];
    _signUpRequestModel.images = await SharedPrefs.getSharedString(
      AppStrings.images,
    );
    _signUpConfirmModel?.data?.user?.profile?.images =
        _signUpRequestModel.images;
    // print('📷 Loaded images: ${_signUpRequestModel.images}');

    /// ------------------------ FIRST PAGE ------------------------
    String name = await SharedPrefs.getSharedString(AppStrings.userName);
    // print('🧑 Full name from storage: "$name"');

    List<String> parts = name.trim().split(RegExp(r'\s+'));
    // print('🔍 Name parts: $parts');

    if (parts.length == 1) {
      firstName.text = parts[0];
      middleName.text = '';
      lastName.text = '';
    } else if (parts.length == 2) {
      firstName.text = parts[0];
      middleName.text = '';
      lastName.text = parts[1];
    } else {
      firstName.text = parts.first;
      middleName.text = parts.sublist(1, parts.length - 1).join(' ');
      lastName.text = parts.last;
    }

    // print('✅ First Name: ${firstName.text}');
    // print('✅ Middle Name: ${middleName.text}');
    // print('✅ Last Name: ${lastName.text}');

    birthDate.text = MethodHelper.convertToDisplayFormat(
      inputDate: await SharedPrefs.getSharedString(AppStrings.dateOfBirth),
    );

    /// this is used to know if user is adding date field or deleting
    _lastLength = birthDate.text.length;
    // print('📅 Date of Birth: ${birthDate.text}');

    _genderQuestion.answer = await SharedPrefs.getSharedString(
      AppStrings.userGender,
    );
    _selectedConvener = null;
    coordinatorIdFromLocal = await SharedPrefs.getSharedString(
      AppStrings.coordinatorId,
    );
    _selectedConvener = Convener(
      id: int.tryParse(coordinatorIdFromLocal ?? "0"),
    );
    // print('🚻 Gender: ${_genderQuestion.answer}');

    /// ------------------------ SECOND PAGE ------------------------
    email.text = await SharedPrefs.getSharedString(AppStrings.userEmail);
    String emailCheck = await SharedPrefs.getSharedString(
      AppStrings.isEmailVerified,
    );
    setIsEmailVerified = emailCheck == "yes";
    // print('📧 Email: ${email.text} | Verified: $isEmailVerified');

    contactNo1.text = await SharedPrefs.getSharedString(AppStrings.phone);
    String contact1Check = await SharedPrefs.getSharedString(
      AppStrings.isContactVerified,
    );
    setIsContactNo1Verified = contact1Check == "yes";
    // print(
    //   '📞 Contact No. 1: ${contactNo1.text} | Verified: $isContactNo1Verified',
    // );

    contactNo2.text = await SharedPrefs.getSharedString(
      AppStrings.userContactNo2,
    );
    setIsContactNo2Verified =
        contactNo2.text.isNotEmpty && contactNo2.text.length == 10;
    // print(
    //   '📞 Contact No. 2: ${contactNo2.text} | Verified: $isContactNo2Verified',
    // );

    address1.text = await SharedPrefs.getSharedString(AppStrings.addressLine1);
    address2.text = await SharedPrefs.getSharedString(AppStrings.addressLine2);
    city.text = await SharedPrefs.getSharedString(AppStrings.userCity);
    state = await SharedPrefs.getSharedString(AppStrings.userState);
    country.text = await SharedPrefs.getSharedString(AppStrings.userCountry);
    district = await SharedPrefs.getSharedString(AppStrings.userDistrict);

    // print('🏠 Address:');
    // print('  Line 1: ${address1.text}');
    // print('  Line 2: ${address2.text}');
    // print('  City: $city');
    // print('  State: $state');
    // print('  District: ${district.text}');
    // print('  Country: ${country.text}');

    /// ------------------------ THIRD PAGE ------------------------
    presentStudy.text = await SharedPrefs.getSharedString(AppStrings.study);
    lastStudy.text = await SharedPrefs.getSharedString(AppStrings.degree);
    collegeOrUniversity.text = await SharedPrefs.getSharedString(
      AppStrings.university,
    );
    String workingStatus = await SharedPrefs.getSharedString(
      AppStrings.workingStatus,
    );
    areYouWorking.answer = workingStatus == "yes" ? "Yes" : "No";
    companyOrBusiness.text = await SharedPrefs.getSharedString(
      AppStrings.userNameOfCompanyOrBusiness,
    );

    // print('🎓 Study: ${presentOrLastStudy.text}');
    // print('🏫 University: ${collegeOrUniversity.text}');
    // print('💼 Working: ${areYouWorking.answer}');
    // print('🏢 Company/Business: ${companyOrBusiness.text}');

    // print('✅ Initialization complete.');
    notifyListeners();
  }

  Future<Map<String, dynamic>> buildUserMap() async {
    String name = await SharedPrefs.getSharedString(AppStrings.userName);
    // print('🧑 Full name from storage: "$name"');
    String first = '';
    String middle = '';
    String last = '';
    List<String> parts = name.trim().split(RegExp(r'\s+'));
    // print('🔍 Name parts: $parts');

    if (parts.length == 1) {
      first = parts[0];
      middle = '';
      last = '';
    } else if (parts.length == 2) {
      first = parts[0];
      middle = '';
      last = parts[1];
    } else {
      first = parts.first;
      middle = parts.sublist(1, parts.length - 1).join(' ');
      last = parts.last;
    }
    return {
      "firstName": first,
      "middleName": middle,
      "lastName": last,
      'birthdate': MethodHelper.convertToDisplayFormat(
        inputDate: await SharedPrefs.getSharedString(AppStrings.dateOfBirth),
      ),
      'gender': await SharedPrefs.getSharedString(AppStrings.userGender),
      'email': await SharedPrefs.getSharedString(AppStrings.userEmail),
      'contact1': await SharedPrefs.getSharedString(AppStrings.userContactNo1),
      'contact2': await SharedPrefs.getSharedString(AppStrings.userContactNo2),
      'address1': await SharedPrefs.getSharedString(AppStrings.addressLine1),
      'address2': await SharedPrefs.getSharedString(AppStrings.addressLine2),
      'state': await SharedPrefs.getSharedString(AppStrings.userState),
      'district': await SharedPrefs.getSharedString(AppStrings.userCity),
      'city': await SharedPrefs.getSharedString(AppStrings.userDistrict),
      'currentStudy': await SharedPrefs.getSharedString(AppStrings.study),
      'degree': await SharedPrefs.getSharedString(AppStrings.degree),
      'college': await SharedPrefs.getSharedString(AppStrings.university),
      'company': await SharedPrefs.getSharedString(
        AppStrings.userNameOfCompanyOrBusiness,
      ),
      'profileImage': _signUpConfirmModel?.data?.user?.profile?.images ?? "",
    };
  }
}
