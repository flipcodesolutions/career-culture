class ConvenerListModel {
  bool? success;
  String? message;
  ConvenerListModelData? data;

  ConvenerListModel({this.success, this.message, this.data});

  ConvenerListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data =
        json['data'] != null
            ? new ConvenerListModelData.fromJson(json['data'])
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

class ConvenerListModelData {
  List<Convener>? convener;

  ConvenerListModelData({this.convener});

  ConvenerListModelData.fromJson(Map<String, dynamic> json) {
    if (json['convener'] != null) {
      convener = <Convener>[];
      json['convener'].forEach((v) {
        convener!.add(new Convener.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.convener != null) {
      data['convener'] = this.convener!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Convener {
  int? id;
  String? name;
  String? email;
  String? role;
  String? isApproved;
  String? status;

  Convener({
    this.id,
    this.name,
    this.email,
    this.role,
    this.isApproved,
    this.status,
  });

  Convener.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    isApproved = json['isApproved'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    data['isApproved'] = this.isApproved;
    data['status'] = this.status;
    return data;
  }
}
