class OnBoardingModel {
  bool? success;
  String? message;
  List<OnBoardingInfo>? data;

  OnBoardingModel({this.success, this.message, this.data});

  OnBoardingModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OnBoardingInfo>[];
      json['data'].forEach((v) {
        data!.add(new OnBoardingInfo.fromJson(v));
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

class OnBoardingInfo {
  int? id;
  String? title;
  String? description;
  String? status;
  String? image;
  String? videoUrl;
  String? audioUrl;
  int? sortOrder;

  OnBoardingInfo({
    this.id,
    this.title,
    this.description,
    this.status,
    this.image,
    this.videoUrl,
    this.audioUrl,
    this.sortOrder,
  });

  OnBoardingInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    status = json['status'];
    image = json['image'];
    videoUrl = json['videoUrl'];
    audioUrl = json['audioUrl'];
    sortOrder = json['sortOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['image'] = this.image;
    data['videoUrl'] = this.videoUrl;
    data['audioUrl'] = this.audioUrl;
    data['sortOrder'] = this.sortOrder;
    return data;
  }
}
