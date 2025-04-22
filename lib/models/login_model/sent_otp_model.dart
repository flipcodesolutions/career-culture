class SentOtpModel {
  bool? success;
  String? message;
  SentOtpModelData? data;

  SentOtpModel({this.success, this.message, this.data});

  SentOtpModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? new SentOtpModelData.fromJson(json['data'])
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

class SentOtpModelData {
  String? contact;

  SentOtpModelData({this.contact});

  SentOtpModelData.fromJson(Map<String, dynamic> json) {
    contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contact'] = this.contact;
    return data;
  }
}
