import 'package:file_picker/file_picker.dart';

class UserSignUpRequestModel {
  String? name;
  String? email;
  String? isEmailVerified;
  String? isContactVerified;
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
  String? study;
  String? degree;
  String? university;
  String? workingStatus;
  String? nameOfCompanyOrBusiness;
  String? images = "String";
  int? convenerId;
  List<PlatformFile> imageFile = [];

  UserSignUpRequestModel({
    this.name,
    this.email,
    this.isEmailVerified,
    this.isContactVerified,
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
    this.study,
    this.degree,
    this.university,
    this.workingStatus,
    this.nameOfCompanyOrBusiness,
    this.images,
    this.convenerId,
    this.imageFile = const [],
  });

  UserSignUpRequestModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    isEmailVerified = json['is_email_verified'];
    isContactVerified = json['is_contact_verified'];
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
    study = json['study'];
    degree = json['degree'];
    university = json['university'];
    workingStatus = json['workingStatus'];
    nameOfCompanyOrBusiness = json['nameOfCompanyOrBusiness'];
    images = json['images'];
    convenerId = json['convener_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['is_email_verified'] = this.isEmailVerified;
    data['is_contact_verified'] = this.isContactVerified;
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
    data['study'] = this.study;
    data['degree'] = this.degree;
    data['university'] = this.university;
    data['workingStatus'] = this.workingStatus;
    data['nameOfCompanyOrBusiness'] = this.nameOfCompanyOrBusiness;
    data['images'] = this.images;
    data['convener_id'] = this.convenerId;
    return data;
  }
}
