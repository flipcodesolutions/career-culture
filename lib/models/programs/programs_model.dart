class ProgramsModel {
  bool? success;
  String? message;
  List<ProgramsInfo>? data;

  ProgramsModel({this.success, this.message, this.data});

  ProgramsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProgramsInfo>[];
      json['data'].forEach((v) {
        data!.add(new ProgramsInfo.fromJson(v));
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

class ProgramsInfo {
  int? id;
  String? title;
  String? description;
  String? image;
  String? status;

  ProgramsInfo({
    this.id,
    this.title,
    this.description,
    this.image,
    this.status,
  });

  ProgramsInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['status'] = this.status;
    return data;
  }
}
