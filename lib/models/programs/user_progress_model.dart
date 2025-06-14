class UserProgressModel {
  bool? success;
  String? message;
  UserProgressModelData? data;

  UserProgressModel({this.success, this.message, this.data});

  UserProgressModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? new UserProgressModelData.fromJson(json['data'])
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

class UserProgressModelData {
  String? programId;
  int? totalPosts;
  // int? completedPosts;
  // int? totalUserPoints;
  // String? totalPossiblePoints;
  double? percentage;

  UserProgressModelData({
    this.programId,
    this.totalPosts,
    // this.completedPosts,
    // this.totalUserPoints,
    // this.totalPossiblePoints,
    this.percentage,
  });

  UserProgressModelData.fromJson(Map<String, dynamic> json) {
    programId = json['program_id'];
    totalPosts = json['total_posts'];
    // completedPosts = json['completed_posts'];
    // totalUserPoints = json['total_user_points'];
    // totalPossiblePoints = json['total_possible_points'];
    percentage = double.tryParse(json['percentage'].toString()) ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['program_id'] = this.programId;
    data['total_posts'] = this.totalPosts;
    // data['completed_posts'] = this.completedPosts;
    // data['total_user_points'] = this.totalUserPoints;
    // data['total_possible_points'] = this.totalPossiblePoints;
    data['percentage'] = this.percentage;
    return data;
  }
}
