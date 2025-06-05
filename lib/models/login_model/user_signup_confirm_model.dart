import 'package:mindful_youth/screens/home_screen/home_screen.dart';
import 'package:mindful_youth/screens/login/sign_up/sign_up.dart';

import '../../app_const/app_strings.dart';
import '../../utils/shared_prefs_helper/shared_prefs_helper.dart';

// class UserSignUpConfirmModel {
//   bool? success;
//   String? message;
//   UserSignUpConfirmModelData? data;

//   UserSignUpConfirmModel({this.success, this.message, this.data});

//   UserSignUpConfirmModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     data =
//         json['data'] != null
//             ? new UserSignUpConfirmModelData.fromJson(json['data'])
//             : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }

// class UserSignUpConfirmModelData {
//   User? user;
//   UserProfile? userProfile;
//   UserEducation? userEducation;
//   String? token;
//   bool? isNewUser;

//   UserSignUpConfirmModelData({
//     this.user,
//     this.userProfile,
//     this.userEducation,
//     this.token,
//     this.isNewUser,
//   });

//   UserSignUpConfirmModelData.fromJson(Map<String, dynamic> json) {
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//     userProfile =
//         json['profile'] != null
//             ? new UserProfile.fromJson(json['profile'])
//             : null;
//     userEducation =
//         (json.containsKey("user_education") && json['user_education'] != null)
//             ? UserEducation.fromJson(json['user_education'])
//             : json['userEducation'] != null
//             ? new UserEducation.fromJson(json['userEducation'])
//             : null;
//     token = json['token'];
//     isNewUser = json['isNewUser'];
//     _saveToLocalStorage();
//   }
//   // UserSignUpConfirmModelData.fromJson(Map<String, dynamic> json) {
//   //   // 1) show all incoming keys
//   //   print('⏱ [DEBUG] JSON keys: ${json.keys.toList()}');

//   //   // 2) user
//   //   if (json.containsKey('user')) {
//   //     print('⏱ [DEBUG] "user" -> ${json['user']}');
//   //     user = User.fromJson(json['user']);
//   //   } else {
//   //     print('⏱ [DEBUG] no "user" key found');
//   //     user = null;
//   //   }

//   //   // 3) profile
//   //   if (json.containsKey('profile')) {
//   //     print('⏱ [DEBUG] "profile" -> ${json['profile']}');
//   //     userProfile = UserProfile.fromJson(json['profile']);
//   //   } else {
//   //     print('⏱ [DEBUG] no "profile" key found');
//   //     userProfile = null;
//   //   }

//   //   // 4) education (two variants)
//   //   if (json.containsKey('user_education') && json['user_education'] != null) {
//   //     print(
//   //       '⏱ [DEBUG] using snake_case key "user_education": ${json['user_education']}',
//   //     );
//   //     userEducation = UserEducation.fromJson(json['user_education']);
//   //   } else if (json.containsKey('userEducation') &&
//   //       json['userEducation'] != null) {
//   //     print(
//   //       '⏱ [DEBUG] using camelCase key "userEducation": ${json['userEducation']}',
//   //     );
//   //     userEducation = UserEducation.fromJson(json['userEducation']);
//   //   } else {
//   //     print('⏱ [DEBUG] no education key present or value is null');
//   //     userEducation = null;
//   //   }

//   //   // 5) simple scalars
//   //   token = json['token'];
//   //   isNewUser = json['isNewUser'];
//   //   print('⏱ [DEBUG] token="$token", isNewUser=$isNewUser');

//   //   _saveToLocalStorage();
//   // }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.user != null) {
//       data['user'] = this.user!.toJson();
//     }
//     if (this.userProfile != null) {
//       data['profile'] = this.userProfile!.toJson();
//     }
//     if (this.userEducation != null) {
//       data['userEducation'] = this.userEducation!.toJson();
//     }
//     data['token'] = this.token;
//     data['isNewUser'] = this.isNewUser;
//     return data;
//   }

//   final bool _shouldPrint =
//       true; // 👈 Set to false when you want to disable logging

//   void _log(String key, String value) {
//     if (_shouldPrint) {
//       print("$key ======> $value");
//     }
//   }

//   void _saveToLocalStorage() async {
//     if (user != null) {
//       await SharedPrefs.saveString(AppStrings.userName, user?.name ?? '');
//       _log(AppStrings.userName, user?.name ?? '');

//       await SharedPrefs.saveString(AppStrings.userEmail, user?.email ?? '');
//       _log(AppStrings.userEmail, user?.email ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.isEmailVerified,
//         user?.isEmailVerified ?? "no",
//       );
//       _log(AppStrings.isEmailVerified, user?.isEmailVerified ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.isContactVerified,
//         user?.isContactVerified ?? "no",
//       );
//       _log(AppStrings.isContactVerified, user?.isContactVerified ?? '');

//       await SharedPrefs.saveString(AppStrings.role, user?.role ?? '');
//       _log(AppStrings.role, user?.role ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.isApproved,
//         user?.isApproved ?? '',
//       );
//       _log(AppStrings.isApproved, user?.isApproved ?? '');

//       await SharedPrefs.saveString(AppStrings.status, user?.status ?? '');
//       _log(AppStrings.status, user?.status ?? '');

//       await SharedPrefs.saveString(AppStrings.id, user?.id.toString() ?? '');
//       _log(AppStrings.id, user?.id.toString() ?? '');
//     }

//     if (userProfile != null) {
//       await SharedPrefs.saveString(
//         AppStrings.images,
//         userProfile?.images ?? '',
//       );
//       _log(AppStrings.images, userProfile?.images ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.userId,
//         userProfile?.userId.toString() ?? '',
//       );
//       _log(AppStrings.userId, userProfile?.userId.toString() ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.userContactNo1,
//         userProfile?.contactNo1 ?? '',
//       );
//       _log(AppStrings.userContactNo1, userProfile?.contactNo1 ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.userContactNo2,
//         userProfile?.contactNo2 ?? '',
//       );
//       _log(AppStrings.userContactNo2, userProfile?.contactNo2 ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.userGender,
//         userProfile?.gender ?? '',
//       );
//       _log(AppStrings.userGender, userProfile?.gender ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.dateOfBirth,
//         userProfile?.dateOfBirth ?? '',
//       );
//       _log(AppStrings.dateOfBirth, userProfile?.dateOfBirth ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.addressLine1,
//         userProfile?.addressLine1 ?? '',
//       );
//       _log(AppStrings.addressLine1, userProfile?.addressLine1 ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.addressLine2,
//         userProfile?.addressLine2 ?? '',
//       );
//       _log(AppStrings.addressLine2, userProfile?.addressLine2 ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.userCity,
//         userProfile?.city ?? '',
//       );
//       _log(AppStrings.userCity, userProfile?.city ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.userState,
//         userProfile?.state ?? '',
//       );
//       _log(AppStrings.userState, userProfile?.state ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.userCountry,
//         userProfile?.country ?? '',
//       );
//       _log(AppStrings.userCountry, userProfile?.country ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.userDistrict,
//         userProfile?.district ?? '',
//       );
//       _log(AppStrings.userDistrict, userProfile?.district ?? '');
//     }

//     if (userEducation != null) {
//       await SharedPrefs.saveString(
//         AppStrings.study,
//         userEducation?.study ?? '',
//       );
//       _log(AppStrings.study, userEducation?.study ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.degree,
//         userEducation?.degree ?? '',
//       );
//       _log(AppStrings.degree, userEducation?.degree ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.university,
//         userEducation?.university ?? '',
//       );
//       _log(AppStrings.university, userEducation?.university ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.workingStatus,
//         userEducation?.workingStatus ?? '',
//       );
//       _log(AppStrings.workingStatus, userEducation?.workingStatus ?? '');

//       await SharedPrefs.saveString(
//         AppStrings.userNameOfCompanyOrBusiness,
//         userEducation?.nameOfCompanyOrBusiness ?? '',
//       );
//       _log(
//         AppStrings.userNameOfCompanyOrBusiness,
//         userEducation?.nameOfCompanyOrBusiness ?? '',
//       );
//     }

//     if (token != null) {
//       await SharedPrefs.saveString(AppStrings.userToken, token!);
//       _log(AppStrings.userToken, token!);
//     }
//     if (isNewUser != null) {
//       await SharedPrefs.saveBool(AppStrings.isNewUser, isNewUser!);
//       _log(AppStrings.isNewUser, isNewUser.toString());
//     }
//   }
// }

// class User {
//   String? name;
//   String? email;
//   String? isEmailVerified;
//   String? isContactVerified;
//   String? role;
//   String? isApproved;
//   String? status;
//   int? id;

//   User({
//     this.name,
//     this.email,
//     this.isEmailVerified,
//     this.isContactVerified,
//     this.role,
//     this.isApproved,
//     this.status,
//     this.id,
//   });

//   User.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     email = json['email'];
//     isEmailVerified = json['is_email_verified'];
//     isContactVerified = json['is_contact_verified'];
//     role = json['role'];
//     isApproved = json['isApproved'];
//     status = json['status'];
//     id = json['id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['is_email_verified'] = this.isEmailVerified;
//     data['is_contact_verified'] = this.isContactVerified;
//     data['role'] = this.role;
//     data['isApproved'] = this.isApproved;
//     data['status'] = this.status;
//     data['id'] = this.id;
//     return data;
//   }
// }

// class UserProfile {
//   String? images;
//   int? userId;
//   String? contactNo1;
//   String? contactNo2;
//   String? gender;
//   String? dateOfBirth;
//   String? addressLine1;
//   String? addressLine2;
//   String? city;
//   String? state;
//   String? country;
//   String? district;
//   int? id;

//   UserProfile({
//     this.images,
//     this.userId,
//     this.contactNo1,
//     this.contactNo2,
//     this.gender,
//     this.dateOfBirth,
//     this.addressLine1,
//     this.addressLine2,
//     this.city,
//     this.state,
//     this.country,
//     this.district,
//     this.id,
//   });

//   UserProfile.fromJson(Map<String, dynamic> json) {
//     images = json['images'];
//     userId = json['user_id'];
//     contactNo1 = json['contactNo1'];
//     contactNo2 = json['contactNo2'];
//     gender = json['gender'];
//     dateOfBirth = json['dateOfBirth'];
//     addressLine1 = json['addressLine1'];
//     addressLine2 = json['addressLine2'];
//     city = json['city'];
//     state = json['state'];
//     country = json['country'];
//     district = json['district'];
//     id = json['id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['images'] = this.images;
//     data['user_id'] = this.userId;
//     data['contactNo1'] = this.contactNo1;
//     data['contactNo2'] = this.contactNo2;
//     data['gender'] = this.gender;
//     data['dateOfBirth'] = this.dateOfBirth;
//     data['addressLine1'] = this.addressLine1;
//     data['addressLine2'] = this.addressLine2;
//     data['city'] = this.city;
//     data['state'] = this.state;
//     data['country'] = this.country;
//     data['district'] = this.district;
//     data['id'] = this.id;
//     return data;
//   }
// }

// class UserEducation {
//   int? userId;
//   String? study;
//   String? degree;
//   String? university;
//   String? workingStatus;
//   String? nameOfCompanyOrBusiness;
//   int? id;

//   UserEducation({
//     this.userId,
//     this.study,
//     this.degree,
//     this.university,
//     this.workingStatus,
//     this.nameOfCompanyOrBusiness,
//     this.id,
//   });

//   UserEducation.fromJson(Map<String, dynamic> json) {
//     userId = json['user_id'];
//     study = json['study'];
//     degree = json['degree'];
//     university = json['university'];
//     workingStatus = json['workingStatus'];
//     nameOfCompanyOrBusiness = json['nameOfCompanyOrBusiness'];
//     id = json['id'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['user_id'] = this.userId;
//     data['study'] = this.study;
//     data['degree'] = this.degree;
//     data['university'] = this.university;
//     data['workingStatus'] = this.workingStatus;
//     data['nameOfCompanyOrBusiness'] = this.nameOfCompanyOrBusiness;
//     data['id'] = this.id;
//     return data;
//   }
// }
//////// user model v2

/// This file defines the user-related models used in authentication or profile-related
/// features of the application. It handles parsing user data from a backend response,
/// converting it to Dart objects, saving relevant data to local storage using `SharedPrefs`,
/// and serializing data back to JSON when needed.
///
///
/// ---------------------------
/// CLASS OVERVIEW
/// ---------------------------

/// UserModel
/// - Top-level model for a user response.
/// - Contains success status, message, and a nested UserModelData object.
class UserModel {
  bool? success;
  String? message;
  UserModelData? data;

  UserModel({this.success, this.message, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null ? new UserModelData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

/// UserModelData
/// - Represents the core data of the user such as token, email verification, contact details,
///   and the User object.
/// - Automatically saves certain user details and preferences to local storage
///   on instantiation via `_saveUserStorage()`.
class UserModelData {
  String? token;
  bool? isNewUser;
  bool? isEmailVerified;
  String? contactNo;
  String? email;
  User? user;

  UserModelData({this.token, this.isNewUser, this.contactNo, this.user});

  UserModelData.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    isNewUser = json['isNewUser'];
    isEmailVerified = json['isEmailVerify'];
    contactNo = json['contactNo'];
    email = json['email'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    _saveUserStorage();
    _saveUserProfileToLocalStorage();
    _saveUserEducationToLocalStorage();
    _saveCoordinatorToLocal();
  }

  ///
  Future<void> saveAllToLocalStorage() async {
    await _saveUserStorage();
    await _saveUserProfileToLocalStorage();
    await _saveUserEducationToLocalStorage();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['isNewUser'] = this.isNewUser;
    data['isEmailVerify'] = this.isEmailVerified;
    data['contactNo'] = this.contactNo;
    data['email'] = this.email;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }

  final bool _shouldPrint =
      true; // 👈 Set to false when you want to disable logging

  void _log(String key, String value) {
    if (_shouldPrint) {
      print("$key ======> $value");
    }
  }

  Future<void> _saveUserStorage() async {
    if (email != null) {
      await SharedPrefs.saveString(AppStrings.userEmail, email ?? "");
    }
    if (user != null) {
      await SharedPrefs.saveString(AppStrings.userName, user?.name ?? '');
      _log(AppStrings.userName, user?.name ?? '');
      await SharedPrefs.saveString(
        AppStrings.userId,
        user?.id.toString() ?? "",
      );
      await SharedPrefs.saveString(AppStrings.userEmail, user?.email ?? "");
      _log(AppStrings.userEmail, user?.email ?? email ?? "");
      await SharedPrefs.saveString(AppStrings.phone, user?.phone ?? '');
      _log(AppStrings.phone, user?.phone ?? '');

      await SharedPrefs.saveString(
        AppStrings.isEmailVerified,
        user?.isEmailVerified ?? "no",
      );
      _log(AppStrings.isEmailVerified, user?.isEmailVerified ?? '');

      await SharedPrefs.saveString(
        AppStrings.isContactVerified,
        user?.isContactVerified ?? "no",
      );
      _log(AppStrings.isContactVerified, user?.isContactVerified ?? '');

      await SharedPrefs.saveString(AppStrings.role, user?.role ?? '');
      _log(AppStrings.role, user?.role ?? '');

      await SharedPrefs.saveString(
        AppStrings.isApproved,
        user?.isApproved ?? '',
      );
      _log(AppStrings.isApproved, user?.isApproved ?? '');

      await SharedPrefs.saveString(AppStrings.status, user?.status ?? '');
      _log(AppStrings.status, user?.status ?? '');
      await SharedPrefs.saveString(
        AppStrings.studentId,
        user?.studentId.toString() ?? '',
      );
      _log(AppStrings.studentId, user?.studentId.toString() ?? '');

      await SharedPrefs.saveString(AppStrings.id, user?.id.toString() ?? '');
      _log(AppStrings.id, user?.id.toString() ?? '');
      await SharedPrefs.saveString(
        AppStrings.userApproved,
        user?.isApproved.toString() ?? '',
      );
      _log(AppStrings.userApproved, user?.isApproved.toString() ?? '');
      await SharedPrefs.saveString(
        AppStrings.myReferralCode,
        user?.myReferralCode ?? '',
      );
      _log(AppStrings.myReferralCode, user?.myReferralCode ?? '');
    }

    if (token != null) {
      await SharedPrefs.saveString(AppStrings.userToken, token!);
      _log(AppStrings.userToken, token!);
    }
    if (isNewUser != null) {
      await SharedPrefs.saveBool(AppStrings.isNewUser, isNewUser!);
      _log(AppStrings.isNewUser, isNewUser.toString());
    }
  }

  Future<void> _saveUserProfileToLocalStorage() async {
    if (user?.profile != null) {
      /// set a check flag for backend registered users
      await saveBoolChecks(
        key: AppStrings.isProfileDataIsEmpty,
        value: user?.profile == null,
      );
      await SharedPrefs.saveString(
        AppStrings.images,
        user?.profile?.images ?? '',
      );
      _log(AppStrings.images, user?.profile?.images ?? '');

      await SharedPrefs.saveString(
        AppStrings.userContactNo1,
        user?.phone ?? '',
      );
      _log(AppStrings.userContactNo1, user?.phone ?? '');

      await SharedPrefs.saveString(
        AppStrings.userContactNo2,
        user?.profile?.contactNo2 ?? '',
      );
      _log(AppStrings.userContactNo2, user?.profile?.contactNo2 ?? '');

      await SharedPrefs.saveString(
        AppStrings.userGender,
        user?.profile?.gender ?? '',
      );
      _log(AppStrings.userGender, user?.profile?.gender ?? '');

      await SharedPrefs.saveString(
        AppStrings.dateOfBirth,
        user?.profile?.dateOfBirth ?? '',
      );
      _log(AppStrings.dateOfBirth, user?.profile?.dateOfBirth ?? '');

      await SharedPrefs.saveString(
        AppStrings.addressLine1,
        user?.profile?.addressLine1 ?? '',
      );
      _log(AppStrings.addressLine1, user?.profile?.addressLine1 ?? '');

      await SharedPrefs.saveString(
        AppStrings.addressLine2,
        user?.profile?.addressLine2 ?? '',
      );
      _log(AppStrings.addressLine2, user?.profile?.addressLine2 ?? '');

      await SharedPrefs.saveString(
        AppStrings.userCity,
        user?.profile?.city ?? '',
      );
      _log(AppStrings.userCity, user?.profile?.city ?? '');

      await SharedPrefs.saveString(
        AppStrings.userState,
        user?.profile?.state ?? '',
      );
      _log(AppStrings.userState, user?.profile?.state ?? '');

      await SharedPrefs.saveString(
        AppStrings.userCountry,
        user?.profile?.country ?? '',
      );
      _log(AppStrings.userCountry, user?.profile?.country ?? '');

      await SharedPrefs.saveString(
        AppStrings.userDistrict,
        user?.profile?.district ?? '',
      );
      _log(AppStrings.userDistrict, user?.profile?.district ?? '');
    } else {
      /// set a check flag for backend registered users
      await saveBoolChecks(
        key: AppStrings.isProfileDataIsEmpty,
        value: user?.profile == null,
      );
    }
  }

  Future<void> _saveUserEducationToLocalStorage() async {
    if (user?.userEducation != null) {
      /// set a check flag for backend registered users
      await saveBoolChecks(
        key: AppStrings.isUserEducationDataIsEmpty,
        value: user?.userEducation == null,
      );
      await SharedPrefs.saveString(
        AppStrings.study,
        user?.userEducation?.study ?? '',
      );
      _log(AppStrings.study, user?.userEducation?.study ?? '');

      await SharedPrefs.saveString(
        AppStrings.degree,
        user?.userEducation?.degree ?? '',
      );
      _log(AppStrings.degree, user?.userEducation?.degree ?? '');

      await SharedPrefs.saveString(
        AppStrings.university,
        user?.userEducation?.university ?? '',
      );
      _log(AppStrings.university, user?.userEducation?.university ?? '');

      await SharedPrefs.saveString(
        AppStrings.workingStatus,
        user?.userEducation?.workingStatus ?? '',
      );
      _log(AppStrings.workingStatus, user?.userEducation?.workingStatus ?? '');

      await SharedPrefs.saveString(
        AppStrings.userNameOfCompanyOrBusiness,
        user?.userEducation?.nameOfCompanyOrBusiness ?? '',
      );
      _log(
        AppStrings.userNameOfCompanyOrBusiness,
        user?.userEducation?.nameOfCompanyOrBusiness ?? '',
      );
    } else {
      /// set a check flag for backend registered users
      await saveBoolChecks(
        key: AppStrings.isUserEducationDataIsEmpty,
        value: user?.userEducation == null,
      );
    }
  }

  /// use to save coordinator id to local
  Future<void> _saveCoordinatorToLocal() async {
    if (user?.coordinator != null) {
      await SharedPrefs.saveString(
        AppStrings.coordinatorId,
        user?.coordinator?.convenerId.toString() ?? '',
      );
      _log(
        AppStrings.coordinatorId,
        user?.coordinator?.convenerId.toString() ?? '',
      );
    }
  }

  /// This key indicates whether a [UserModel] is being initialized for a user originating from the backend.
  /// If `user.profile` and `user.userEducation` are null, this flag will redirect the user to the
  /// [SignUpScreen] from the [HomeScreen], prompting them to complete their profile information.
  Future<void> saveBoolChecks({
    required String key,
    required bool value,
  }) async {
    await SharedPrefs.saveBool(key, value);
    _log(key, (value).toString());
  }
}

/// User
/// - Represents detailed user information including ID, name, email, status flags,
///   and nested models like `UserProfile` and `UserEducation`.
/// - On creation, saves user profile and education data to local storage.
class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? emailVerifiedAt;
  String? isEmailVerified;
  String? isContactVerified;
  String? role;
  String? isApproved;
  String? otp;
  String? status;
  String? studentId;
  String? myReferralCode;
  UserEducation? userEducation;
  UserProfile? profile;
  Coordinator? coordinator;

  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.emailVerifiedAt,
    this.isEmailVerified,
    this.isContactVerified,
    this.role,
    this.isApproved,
    this.otp,
    this.status,
    this.myReferralCode,
    this.userEducation,
    this.profile,
    this.coordinator,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    emailVerifiedAt = json['email_verified_at'];
    isEmailVerified = json['is_email_verified'];
    isContactVerified = json['is_contact_verified'];
    role = json['role'];
    isApproved = json['isApproved'];
    otp = json['otp'];
    status = json['status'];
    studentId = json['student_id'];
    myReferralCode = json['my_referral_code'];
    userEducation =
        json['user_education'] != null
            ? new UserEducation.fromJson(json['user_education'])
            : null;
    profile =
        json['profile'] != null
            ? new UserProfile.fromJson(json['profile'])
            : null;
    coordinator =
        json['convener'] != null
            ? new Coordinator.fromJson(json['convener'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['is_email_verified'] = this.isEmailVerified;
    data['is_contact_verified'] = this.isContactVerified;
    data['role'] = this.role;
    data['isApproved'] = this.isApproved;
    data['otp'] = this.otp;
    data['status'] = this.status;
    data['student_id'] = this.studentId;
    data['my_referral_code'] = this.status;
    if (this.userEducation != null) {
      data['user_education'] = this.userEducation!.toJson();
    }
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
    }
    if (this.coordinator != null) {
      data['convener'] = this.coordinator!.toJson();
    }
    return data;
  }

  final bool _shouldPrint =
      true; // 👈 Set to false when you want to disable logging

  void _log(String key, String value) {
    if (_shouldPrint) {
      print("$key ======> $value");
    }
  }
}

/// UserEducation
/// - Stores the user's education and work-related information.
/// - Includes degree, university, and job/business-related info.
class UserEducation {
  int? id;
  int? userId;
  String? study;
  String? degree;
  String? university;
  String? workingStatus;
  String? nameOfCompanyOrBusiness;

  UserEducation({
    this.id,
    this.userId,
    this.study,
    this.degree,
    this.university,
    this.workingStatus,
    this.nameOfCompanyOrBusiness,
  });

  UserEducation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    study = json['study'];
    degree = json['degree'];
    university = json['university'];
    workingStatus = json['workingStatus'];
    nameOfCompanyOrBusiness = json['nameOfCompanyOrBusiness'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['study'] = this.study;
    data['degree'] = this.degree;
    data['university'] = this.university;
    data['workingStatus'] = this.workingStatus;
    data['nameOfCompanyOrBusiness'] = this.nameOfCompanyOrBusiness;
    return data;
  }
}

/// UserProfile
/// - Contains personal information such as gender, birth date, contact numbers,
///   and address.
/// - Used to display or store user identity in more detail.
class UserProfile {
  int? id;
  int? userId;
  String? gender;
  String? dateOfBirth;
  // String? contactNo1;
  String? contactNo2;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? country;
  String? district;
  String? images;

  UserProfile({
    this.id,
    this.userId,
    this.gender,
    this.dateOfBirth,
    // this.contactNo1,
    this.contactNo2,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.district,
    this.images,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    // contactNo1 = json['contactNo1'];
    contactNo2 = json['contactNo2'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    district = json['district'];
    images = json['images'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['gender'] = this.gender;
    data['dateOfBirth'] = this.dateOfBirth;
    // data['contactNo1'] = this.contactNo1;
    data['contactNo2'] = this.contactNo2;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['district'] = this.district;
    data['images'] = this.images;
    return data;
  }
}

/// this coordinator class will be used in [SignUpScreen] to load coordinator for user registered from admin panel
class Coordinator {
  int? id;
  int? studentId;
  int? convenerId;

  Coordinator({this.id, this.studentId, this.convenerId});

  Coordinator.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    convenerId = json['convener_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_id'] = this.studentId;
    data['convener_id'] = this.convenerId;
    return data;
  }
}

/// ---------------------------
/// KEY BEHAVIORS
/// ---------------------------

/// ✅ JSON Serialization/Deserialization:
/// All classes implement `fromJson` and `toJson` methods to easily convert between
/// JSON (usually received from the server) and Dart objects.

/// ✅ Local Storage:
/// - `UserModelData`, `User`, and nested objects automatically store specific
///   fields to shared preferences (`SharedPrefs`) when instantiated.
/// - These fields are typically essential for session management, verification states,
///   and profile pre-filling.

/// ✅ Logging:
/// - Each class contains a `_log()` method controlled by a `_shouldPrint` flag
///   that prints key-value pairs to the console for debugging purposes when saving to local storage.

/// ---------------------------
/// EXAMPLES
/// ---------------------------
/// Typical usage:
/// ```dart
/// final userModel = UserModel.fromJson(apiResponse);
/// final token = userModel.data?.token;
/// ```
///
/// Automatically saves user data on parsing:
/// ```dart
/// UserModelData.fromJson(json) // Triggers _saveUserStorage()
/// ```

/// ---------------------------
/// DEPENDENCIES
/// ---------------------------
/// - SharedPrefs: Utility class used for saving key-value pairs.
/// - AppStrings: A constant holder for all the keys used in shared preferences.
///
/// Note: Ensure these utilities (`SharedPrefs`, `AppStrings`) are implemented in your project
/// for this model to function correctly.
