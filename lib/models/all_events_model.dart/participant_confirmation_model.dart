class EventParticipantConfirmation {
  bool? success;
  String? message;
  EventParticipantConfirmationData? data;

  EventParticipantConfirmation({this.success, this.message, this.data});

  EventParticipantConfirmation.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? new EventParticipantConfirmationData.fromJson(json['data'])
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

class EventParticipantConfirmationData {
  int? userId;
  String? eventId;
  String? status;
  String? remarks;
  int? id;

  EventParticipantConfirmationData({
    this.userId,
    this.eventId,
    this.status,
    this.remarks,
    this.id,
  });

  EventParticipantConfirmationData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    eventId = json['event_id'];
    status = json['status'];
    remarks = json['remarks'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['event_id'] = this.eventId;
    data['status'] = this.status;
    data['remarks'] = this.remarks;
    data['id'] = this.id;
    return data;
  }
}
