class AllEventModel {
  bool? success;
  String? message;
  List<EventModel>? data;

  AllEventModel({this.success, this.message, this.data});

  AllEventModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EventModel>[];
      json['data'].forEach((v) {
        data!.add(new EventModel.fromJson(v));
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

class EventModel {
  int? id;
  String? title;
  String? description;
  String? poster;
  String? venue;
  String? registrationEndDate;
  String? startDate;
  String? endDate;
  String? amount;
  String? time;
  String? isAnnouncement;
  int? points;
  String? terms;
  String? status;

  EventModel({
    this.id,
    this.title,
    this.description,
    this.poster,
    this.venue,
    this.registrationEndDate,
    this.startDate,
    this.endDate,
    this.amount,
    this.time,
    this.isAnnouncement,
    this.points,
    this.terms,
    this.status,
  });

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    poster = json['poster'];
    venue = json['venue'];
    registrationEndDate = json['registrationEndDate'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    amount = json['amount'];
    time = json['time'];
    isAnnouncement = json['isAnnouncement'];
    points = json['points'];
    terms = json['terms'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['poster'] = this.poster;
    data['venue'] = this.venue;
    data['registrationEndDate'] = this.registrationEndDate;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['amount'] = this.amount;
    data['time'] = this.time;
    data['isAnnouncement'] = this.isAnnouncement;
    data['points'] = this.points;
    data['terms'] = this.terms;
    data['status'] = this.status;
    return data;
  }
}
