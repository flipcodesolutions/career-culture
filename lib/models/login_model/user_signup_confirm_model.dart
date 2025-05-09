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

  void _saveUserStorage() async {
    if (user != null) {
      await SharedPrefs.saveString(AppStrings.userName, user?.name ?? '');
      _log(AppStrings.userName, user?.name ?? '');

      await SharedPrefs.saveString(AppStrings.userEmail, user?.email ?? '');
      _log(AppStrings.userEmail, user?.email ?? '');

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

      await SharedPrefs.saveString(AppStrings.id, user?.id.toString() ?? '');
      _log(AppStrings.id, user?.id.toString() ?? '');
      await SharedPrefs.saveString(
        AppStrings.userApproved,
        user?.isApproved.toString() ?? '',
      );
      _log(AppStrings.userApproved, user?.isApproved.toString() ?? '');
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
}

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
  UserEducation? userEducation;
  UserProfile? profile;

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
    this.userEducation,
    this.profile,
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
    userEducation =
        json['user_education'] != null
            ? new UserEducation.fromJson(json['user_education'])
            : null;
    profile =
        json['profile'] != null
            ? new UserProfile.fromJson(json['profile'])
            : null;

    _saveUserProfileToLocalStorage();
    _saveUserEducationToLocalStorage();
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
    if (this.userEducation != null) {
      data['user_education'] = this.userEducation!.toJson();
    }
    if (this.profile != null) {
      data['profile'] = this.profile!.toJson();
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

  void _saveUserProfileToLocalStorage() async {
    if (profile != null) {
      await SharedPrefs.saveString(AppStrings.images, profile?.images ?? '');
      _log(AppStrings.images, profile?.images ?? '');

      await SharedPrefs.saveString(
        AppStrings.userId,
        profile?.userId.toString() ?? '',
      );
      _log(AppStrings.userId, profile?.userId.toString() ?? '');

      await SharedPrefs.saveString(
        AppStrings.userContactNo1,
        profile?.contactNo1 ?? '',
      );
      _log(AppStrings.userContactNo1, profile?.contactNo1 ?? '');
      await SharedPrefs.saveString(
        AppStrings.userContactNo1,
        phone ?? '',
      );
      _log(AppStrings.userContactNo1, phone ?? '');

      await SharedPrefs.saveString(
        AppStrings.userContactNo2,
        profile?.contactNo2 ?? '',
      );
      _log(AppStrings.userContactNo2, profile?.contactNo2 ?? '');

      await SharedPrefs.saveString(
        AppStrings.userGender,
        profile?.gender ?? '',
      );
      _log(AppStrings.userGender, profile?.gender ?? '');

      await SharedPrefs.saveString(
        AppStrings.dateOfBirth,
        profile?.dateOfBirth ?? '',
      );
      _log(AppStrings.dateOfBirth, profile?.dateOfBirth ?? '');

      await SharedPrefs.saveString(
        AppStrings.addressLine1,
        profile?.addressLine1 ?? '',
      );
      _log(AppStrings.addressLine1, profile?.addressLine1 ?? '');

      await SharedPrefs.saveString(
        AppStrings.addressLine2,
        profile?.addressLine2 ?? '',
      );
      _log(AppStrings.addressLine2, profile?.addressLine2 ?? '');

      await SharedPrefs.saveString(AppStrings.userCity, profile?.city ?? '');
      _log(AppStrings.userCity, profile?.city ?? '');

      await SharedPrefs.saveString(AppStrings.userState, profile?.state ?? '');
      _log(AppStrings.userState, profile?.state ?? '');

      await SharedPrefs.saveString(
        AppStrings.userCountry,
        profile?.country ?? '',
      );
      _log(AppStrings.userCountry, profile?.country ?? '');

      await SharedPrefs.saveString(
        AppStrings.userDistrict,
        profile?.district ?? '',
      );
      _log(AppStrings.userDistrict, profile?.district ?? '');
    }
  }

  void _saveUserEducationToLocalStorage() async {
    if (userEducation != null) {
      await SharedPrefs.saveString(
        AppStrings.study,
        userEducation?.study ?? '',
      );
      _log(AppStrings.study, userEducation?.study ?? '');

      await SharedPrefs.saveString(
        AppStrings.degree,
        userEducation?.degree ?? '',
      );
      _log(AppStrings.degree, userEducation?.degree ?? '');

      await SharedPrefs.saveString(
        AppStrings.university,
        userEducation?.university ?? '',
      );
      _log(AppStrings.university, userEducation?.university ?? '');

      await SharedPrefs.saveString(
        AppStrings.workingStatus,
        userEducation?.workingStatus ?? '',
      );
      _log(AppStrings.workingStatus, userEducation?.workingStatus ?? '');

      await SharedPrefs.saveString(
        AppStrings.userNameOfCompanyOrBusiness,
        userEducation?.nameOfCompanyOrBusiness ?? '',
      );
      _log(
        AppStrings.userNameOfCompanyOrBusiness,
        userEducation?.nameOfCompanyOrBusiness ?? '',
      );
    }
  }
}

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

class UserProfile {
  int? id;
  int? userId;
  String? gender;
  String? dateOfBirth;
  String? contactNo1;
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
    this.contactNo1,
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
    contactNo1 = json['contactNo1'];
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
    data['contactNo1'] = this.contactNo1;
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
