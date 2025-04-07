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
  String? date;
  String? time;
  String? isAnnouncement;
  String? status;

  EventModel({
    this.id,
    this.title,
    this.description,
    this.poster,
    this.venue,
    this.date,
    this.time,
    this.isAnnouncement,
    this.status,
  });

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    poster = json['poster'];
    venue = json['venue'];
    date = json['date'];
    time = json['time'];
    isAnnouncement = json['isAnnouncement'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['poster'] = this.poster;
    data['venue'] = this.venue;
    data['date'] = this.date;
    data['time'] = this.time;
    data['isAnnouncement'] = this.isAnnouncement;
    data['status'] = this.status;
    return data;
  }
}
