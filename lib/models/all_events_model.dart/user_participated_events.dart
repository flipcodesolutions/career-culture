import 'package:mindful_youth/models/all_events_model.dart/all_events_model.dart';

class MyEventsModel {
  bool? success;
  String? message;
  List<MyEventsModelData>? data;

  MyEventsModel({this.success, this.message, this.data});

  MyEventsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MyEventsModelData>[];
      json['data'].forEach((v) {
        data!.add(new MyEventsModelData.fromJson(v));
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

class MyEventsModelData {
  int? id;
  int? userId;
  int? eventId;
  String? status;
  String? remarks;
  EventModel? event;

  MyEventsModelData({
    this.id,
    this.userId,
    this.eventId,
    this.status,
    this.remarks,
    this.event,
  });

  MyEventsModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    eventId = json['event_id'];
    status = json['status'];
    remarks = json['remarks'];
    event =
        json['event'] != null ? new EventModel.fromJson(json['event']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['event_id'] = this.eventId;
    data['status'] = this.status;
    data['remarks'] = this.remarks;
    if (this.event != null) {
      data['event'] = this.event!.toJson();
    }
    return data;
  }
}
