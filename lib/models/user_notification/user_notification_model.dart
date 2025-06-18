class UserNotifications {
  bool? success;
  String? message;
  List<UserNotificationsData>? data;

  UserNotifications({this.success, this.message, this.data});

  UserNotifications.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserNotificationsData>[];
      json['data'].forEach((v) {
        data!.add(new UserNotificationsData.fromJson(v));
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

class UserNotificationsData {
  int? id;
  String? notificationTitle;
  String? notificationDescription;
  String? notificationNavigateScreen;
  String? payload;
  String? createdAt;
  UserNotificationsData({
    this.id,
    this.notificationTitle,
    this.notificationDescription,
    this.notificationNavigateScreen,
    this.payload,
  });

  UserNotificationsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    notificationTitle = json['notificationTitle'];
    notificationDescription = json['notificationDescription'];
    notificationNavigateScreen = json['notificationNavigateScreen'];
    payload = json['payload'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['notificationTitle'] = this.notificationTitle;
    data['notificationDescription'] = this.notificationDescription;
    data['notificationNavigateScreen'] = this.notificationNavigateScreen;
    data['payload'] = this.payload;
    data['created_at'] = this.createdAt;
    return data;
  }
}
