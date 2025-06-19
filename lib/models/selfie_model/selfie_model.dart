class GetSelfieZone {
  bool? status;
  String? message;
  List<GetSelfieZoneData>? data;

  GetSelfieZone({this.status, this.message, this.data});

  GetSelfieZone.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GetSelfieZoneData>[];
      json['data'].forEach((v) {
        data!.add(new GetSelfieZoneData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GetSelfieZoneData {
  int? id;
  String? title;
  String? description;
  String? question;
  String? suggestedImage;
  GetSelfieZoneData({this.id, this.title});

  GetSelfieZoneData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    question = json['question'];
    suggestedImage = json['suggestedImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['question'] = this.question;
    data['suggestedImage'] = this.suggestedImage;
    return data;
  }
}
