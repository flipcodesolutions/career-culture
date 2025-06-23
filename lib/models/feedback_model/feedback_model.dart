class FeedbackModel {
  bool? success;
  String? message;
  List<FeedbackModelData>? data;

  FeedbackModel({this.success, this.message, this.data});

  FeedbackModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <FeedbackModelData>[];
      json['data'].forEach((v) {
        data!.add(new FeedbackModelData.fromJson(v));
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

class FeedbackModelData {
  String? notificationTitle;
  String? notificationDescription;
  String? notificationNavigateScreen;
  FeedbackModelPayload? payload;

  FeedbackModelData({
    this.notificationTitle,
    this.notificationDescription,
    this.notificationNavigateScreen,
    this.payload,
  });

  FeedbackModelData.fromJson(Map<String, dynamic> json) {
    notificationTitle = json['notificationTitle'];
    notificationDescription = json['notificationDescription'];
    notificationNavigateScreen = json['notificationNavigateScreen'];
    payload =
        json['payload'] != null
            ? new FeedbackModelPayload.fromJson(json['payload'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notificationTitle'] = this.notificationTitle;
    data['notificationDescription'] = this.notificationDescription;
    data['notificationNavigateScreen'] = this.notificationNavigateScreen;
    if (this.payload != null) {
      data['payload'] = this.payload!.toJson();
    }
    return data;
  }
}

class FeedbackModelPayload {
  CounselingBy? counselingBy;
  Appointment? appointment;

  FeedbackModelPayload({this.counselingBy, this.appointment});

  FeedbackModelPayload.fromJson(Map<String, dynamic> json) {
    counselingBy =
        json['counselingBy'] != null
            ? new CounselingBy.fromJson(json['counselingBy'])
            : null;
    appointment =
        json['appointment'] != null
            ? new Appointment.fromJson(json['appointment'])
            : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.counselingBy != null) {
      data['counselingBy'] = this.counselingBy!.toJson();
    }
    if (this.appointment != null) {
      data['appointment'] = this.appointment!.toJson();
    }
    return data;
  }
}

class CounselingBy {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? createdAt;
  CounselingBy({this.id, this.name, this.email, this.phone});

  CounselingBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }
}

class Appointment {
  int? id;
  int? userId;
  String? appointmentDate;
  String? slot;
  String? mode;
  String? counselingBy;
  String? status;
  String? message;
  String? notificationRead;

  Appointment({
    this.id,
    this.userId,
    this.appointmentDate,
    this.slot,
    this.mode,
    this.counselingBy,
    this.status,
    this.message,
    this.notificationRead,
  });

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    appointmentDate = json['appointmentDate'];
    slot = json['slot'];
    mode = json['mode'];
    counselingBy = json['counseling_by'];
    status = json['status'];
    message = json['message'];
    notificationRead = json['notificationRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['appointmentDate'] = this.appointmentDate;
    data['slot'] = this.slot;
    data['mode'] = this.mode;
    data['counseling_by'] = this.counselingBy;
    data['status'] = this.status;
    data['message'] = this.message;
    data['notificationRead'] = this.notificationRead;
    return data;
  }
}
