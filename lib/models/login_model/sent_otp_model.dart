class SentOtpModel {
  bool? success;
  String? message;
  OtpModelData? data;

  SentOtpModel({this.success, this.message, this.data});

  SentOtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new OtpModelData.fromJson(json['data']) : null;
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

class OtpModelData {
  bool? isNewUser;
  int? otp;

  OtpModelData({this.isNewUser, this.otp});

  OtpModelData.fromJson(Map<String, dynamic> json) {
    isNewUser = json['isNewUser'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isNewUser'] = this.isNewUser;
    data['otp'] = this.otp;
    return data;
  }
}
