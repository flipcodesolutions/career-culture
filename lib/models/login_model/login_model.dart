class LoginResponseModel {
  bool? success;
  String? message;
  UserInfo? data;

  LoginResponseModel({this.success, this.message, this.data});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new UserInfo.fromJson(json['data']) : null;
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

class UserInfo {
  User? user;
  String? token;

  UserInfo({this.user, this.token});

  UserInfo.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? contactNo;
  String? contactNo2;
  String? emailVerifiedAt;
  String? role;
  String? isApproved;
  String? isEmailVerified;
  String? isContactVerified;
  String? status;

  User({
    this.id,
    this.name,
    this.email,
    this.contactNo,
    this.contactNo2,
    this.emailVerifiedAt,
    this.role,
    this.isApproved,
    this.isEmailVerified,
    this.isContactVerified,
    this.status,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    contactNo = json['contactNo'];
    contactNo2 = json['contactNo2'];
    emailVerifiedAt = json['email_verified_at'];
    role = json['role'];
    isApproved = json['isApproved'];
    isEmailVerified = json['is_email_verified'];
    isContactVerified = json['is_contact_verified'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contactNo'] = this.contactNo;
    data['contactNo2'] = this.contactNo2;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['role'] = this.role;
    data['isApproved'] = this.isApproved;
    data['is_email_verified'] = this.isEmailVerified;
    data['is_contact_verified'] = this.isContactVerified;
    data['status'] = this.status;
    return data;
  }
}
