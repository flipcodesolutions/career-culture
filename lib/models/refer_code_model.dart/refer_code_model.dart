class ReferCodeModel {
  bool? success;
  String? message;
  ReferCodeModelData? data;

  ReferCodeModel({this.success, this.message, this.data});

  ReferCodeModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? new ReferCodeModelData.fromJson(json['data'])
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

class ReferCodeModelData {
  String? referCode;
  String? points;

  ReferCodeModelData({this.referCode, this.points});

  ReferCodeModelData.fromJson(Map<String, dynamic> json) {
    referCode = json['referCode'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['referCode'] = this.referCode;
    data['points'] = this.points;
    return data;
  }
}
