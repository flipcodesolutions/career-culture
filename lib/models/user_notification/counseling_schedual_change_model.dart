class CounselingSchedualChangeNotificationModel {
  bool? success;
  String? message;
  CounselingSchedualChangeNotification? data;

  CounselingSchedualChangeNotificationModel({
    this.success,
    this.message,
    this.data,
  });

  CounselingSchedualChangeNotificationModel.fromJson(
    Map<String, dynamic> json,
  ) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? new CounselingSchedualChangeNotification.fromJson(json['data'])
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

class CounselingSchedualChangeNotification {
  String? notificationTitle;
  String? notificationDescription;
  int? appointmentId;
  CounselingSchedualChangeNotification({
    this.notificationTitle,
    this.notificationDescription,
    this.appointmentId
  });

  CounselingSchedualChangeNotification.fromJson(Map<String, dynamic> json) {
    notificationTitle = json['notificationTitle'];
    notificationDescription = json['notificationDescription'];
    appointmentId = json['appointmentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notificationTitle'] = this.notificationTitle;
    data['notificationDescription'] = this.notificationDescription;
    data['appointmentId'] = this.appointmentId;
    return data;
  }
}
