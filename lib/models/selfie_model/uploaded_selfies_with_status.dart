class UploadedSelfiesWithStatusModel {
  bool? success;
  String? message;
  List<UploadedSelfiesWithStatusModelData>? data;

  UploadedSelfiesWithStatusModel({this.success, this.message, this.data});

  UploadedSelfiesWithStatusModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UploadedSelfiesWithStatusModelData>[];
      json['data'].forEach((v) {
        data!.add(new UploadedSelfiesWithStatusModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UploadedSelfiesWithStatusModelData {
  int? id;
  int? userId;
  int? selfieZoneId;
  String? images;
  int? mentorId;
  String? status;
  String? rejectionReason;

  UploadedSelfiesWithStatusModelData({
    this.id,
    this.userId,
    this.selfieZoneId,
    this.images,
    this.mentorId,
    this.status,
    this.rejectionReason,
  });

  UploadedSelfiesWithStatusModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    selfieZoneId = json['selfie_zone_id'];
    images = json['images'];
    mentorId = json['mentor_id'];
    status = json['status'];
    rejectionReason = json['rejection_reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['selfie_zone_id'] = this.selfieZoneId;
    data['images'] = this.images;
    data['mentor_id'] = this.mentorId;
    data['status'] = this.status;
    data['rejection_reason'] = this.rejectionReason;
    return data;
  }
}
