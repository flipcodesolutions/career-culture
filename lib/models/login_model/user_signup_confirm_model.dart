class UserSignUpConfirmModel {
  bool? success;
  String? message;
  UserSignUpConfirmModelData? data;

  UserSignUpConfirmModel({this.success, this.message, this.data});

  UserSignUpConfirmModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? new UserSignUpConfirmModelData.fromJson(json['data'])
            : null;
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

class UserSignUpConfirmModelData {
  User? user;
  UserProfile? userProfile;
  UserEducation? userEducation;
  String? token;

  UserSignUpConfirmModelData({
    this.user,
    this.userProfile,
    this.userEducation,
    this.token,
  });

  UserSignUpConfirmModelData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    userProfile =
        json['userProfile'] != null
            ? new UserProfile.fromJson(json['userProfile'])
            : null;
    userEducation =
        json['userEducation'] != null
            ? new UserEducation.fromJson(json['userEducation'])
            : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.userProfile != null) {
      data['userProfile'] = this.userProfile!.toJson();
    }
    if (this.userEducation != null) {
      data['userEducation'] = this.userEducation!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class User {
  String? name;
  String? email;
  String? isEmailVerified;
  String? isContactVerified;
  String? role;
  String? isApproved;
  String? status;
  int? id;

  User({
    this.name,
    this.email,
    this.isEmailVerified,
    this.isContactVerified,
    this.role,
    this.isApproved,
    this.status,
    this.id,
  });

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    isEmailVerified = json['is_email_verified'];
    isContactVerified = json['is_contact_verified'];
    role = json['role'];
    isApproved = json['isApproved'];
    status = json['status'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['is_email_verified'] = this.isEmailVerified;
    data['is_contact_verified'] = this.isContactVerified;
    data['role'] = this.role;
    data['isApproved'] = this.isApproved;
    data['status'] = this.status;
    data['id'] = this.id;
    return data;
  }
}

class UserProfile {
  String? images;
  int? userId;
  String? contactNo1;
  String? contactNo2;
  String? gender;
  String? dateOfBirth;
  String? addressLine1;
  String? addressLine2;
  String? city;
  String? state;
  String? country;
  String? district;
  int? id;

  UserProfile({
    this.images,
    this.userId,
    this.contactNo1,
    this.contactNo2,
    this.gender,
    this.dateOfBirth,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.district,
    this.id,
  });

  UserProfile.fromJson(Map<String, dynamic> json) {
    images = json['images'];
    userId = json['user_id'];
    contactNo1 = json['contactNo1'];
    contactNo2 = json['contactNo2'];
    gender = json['gender'];
    dateOfBirth = json['dateOfBirth'];
    addressLine1 = json['addressLine1'];
    addressLine2 = json['addressLine2'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    district = json['district'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['images'] = this.images;
    data['user_id'] = this.userId;
    data['contactNo1'] = this.contactNo1;
    data['contactNo2'] = this.contactNo2;
    data['gender'] = this.gender;
    data['dateOfBirth'] = this.dateOfBirth;
    data['addressLine1'] = this.addressLine1;
    data['addressLine2'] = this.addressLine2;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['district'] = this.district;
    data['id'] = this.id;
    return data;
  }
}

class UserEducation {
  int? userId;
  String? study;
  String? degree;
  String? university;
  String? workingStatus;
  String? nameOfCompanyOrBusiness;
  int? id;

  UserEducation({
    this.userId,
    this.study,
    this.degree,
    this.university,
    this.workingStatus,
    this.nameOfCompanyOrBusiness,
    this.id,
  });

  UserEducation.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    study = json['study'];
    degree = json['degree'];
    university = json['university'];
    workingStatus = json['workingStatus'];
    nameOfCompanyOrBusiness = json['nameOfCompanyOrBusiness'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['study'] = this.study;
    data['degree'] = this.degree;
    data['university'] = this.university;
    data['workingStatus'] = this.workingStatus;
    data['nameOfCompanyOrBusiness'] = this.nameOfCompanyOrBusiness;
    data['id'] = this.id;
    return data;
  }
}
