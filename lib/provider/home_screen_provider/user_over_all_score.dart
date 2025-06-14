class UserOverAllScoreModel {
  bool? success;
  String? message;
  UserOverAllScoreModelData? data;

  UserOverAllScoreModel({this.success, this.message, this.data});

  UserOverAllScoreModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? new UserOverAllScoreModelData.fromJson(json['data'])
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

class UserOverAllScoreModelData {
  int? userId;
  String? name;
  String? image;
  int? totalPoints;
  int? counselingCount;

  UserOverAllScoreModelData({
    this.userId,
    this.name,
    this.image,
    this.totalPoints,
    this.counselingCount,
  });

  UserOverAllScoreModelData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    name = json['name'];
    image = json['image'];
    totalPoints = json['total_points'];
    counselingCount = json['counselingCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['total_points'] = this.totalPoints;
    data['counselingCount'] = this.counselingCount;
    return data;
  }
}
