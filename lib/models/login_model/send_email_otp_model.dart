class SendEmailOtpModel {
  bool? success;
  String? message;
  SendEmailOtpModelData? data;

  SendEmailOtpModel({this.success, this.message, this.data});

  SendEmailOtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new SendEmailOtpModelData.fromJson(json['data']) : null;
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

class SendEmailOtpModelData {
  bool? isNewUser;
  String? email;

  SendEmailOtpModelData({this.isNewUser, this.email});

  SendEmailOtpModelData.fromJson(Map<String, dynamic> json) {
    isNewUser = json['isNewUser'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isNewUser'] = this.isNewUser;
    data['email'] = this.email;
    return data;
  }
}
