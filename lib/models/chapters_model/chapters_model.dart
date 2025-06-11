class ChaptersModel {
  bool? success;
  String? message;
  List<ChaptersInfo>? data;

  ChaptersModel({this.success, this.message, this.data});

  ChaptersModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ChaptersInfo>[];
      json['data'].forEach((v) {
        data!.add(new ChaptersInfo.fromJson(v));
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

class ChaptersInfo {
  int? id;
  String? title;
  String? description;
  int? programId;
  String? image;
  String? status;
  bool? isOpen;
  ChaptersInfo({
    this.id,
    this.title,
    this.description,
    this.programId,
    this.image,
    this.status,
    this.isOpen,
  });

  ChaptersInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    programId = json['program_id'];
    image = json['image'];
    status = json['status'];
    isOpen = json['isOpen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['program_id'] = this.programId;
    data['image'] = this.image;
    data['status'] = this.status;
    data['isOpen'] = this.isOpen;
    return data;
  }
}
