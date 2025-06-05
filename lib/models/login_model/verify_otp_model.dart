class OtpVerifyModel {
  bool? success;
  String? message;
  OtpVerifyModelData? data;

  OtpVerifyModel({this.success, this.message, this.data});

  OtpVerifyModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? new OtpVerifyModelData.fromJson(json['data'])
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

class OtpVerifyModelData {
  bool? isNewUser;
  String? contactNo;

  OtpVerifyModelData({this.isNewUser, this.contactNo});

  OtpVerifyModelData.fromJson(Map<String, dynamic> json) {
    isNewUser = json['isNewUser'];
    contactNo = json['contactNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isNewUser'] = this.isNewUser;
    data['contactNo'] = this.contactNo;
    return data;
  }
}
